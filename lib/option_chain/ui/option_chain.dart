import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/option_chain/constants.dart';
import 'package:flutter_application_1/option_chain/data/dummy_data.dart';
import 'package:flutter_application_1/option_chain/model/option_chain_model.dart';
import 'package:flutter_application_1/option_chain/model/stock_data_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptionChainWidget extends StatefulWidget {
  const OptionChainWidget({Key? key}) : super(key: key);

  @override
  State<OptionChainWidget> createState() => _OptionChainWidgetState();
}

enum VisibleColumnType { center, callExpanded, putExpanded }

class _OptionChainWidgetState extends State<OptionChainWidget> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      streamController.add(List.generate(
          15,
          (index) => OptionChainModel(
              call: StockData(
                  bid: 210 + Random().nextInt(250).toDouble(),
                  ltp: 240 + Random().nextInt(250).toDouble(),
                  spread: 240 + Random().nextInt(250).toDouble(),
                  ask: 240 + Random().nextInt(250).toDouble()),
              put: StockData(
                  bid: 210 + Random().nextInt(250).toDouble(),
                  ltp: 240 + Random().nextInt(250).toDouble(),
                  spread: 240 + Random().nextInt(250).toDouble(),
                  ask: 240 + Random().nextInt(250).toDouble()),
              strike: Random().nextInt(16000).toDouble())));
    });
    // _scrollController = ScrollController(initialScrollOffset: 150);
    _scrollController.addListener(() {
      if (_scrollController.offset < 50) {
        visibleColumnType = VisibleColumnType.callExpanded;
      } else if (_scrollController.offset > 250) {
        visibleColumnType = VisibleColumnType.putExpanded;
      } else if (_scrollController.offset < 80 &&
          _scrollController.offset > 250) {
        visibleColumnType = VisibleColumnType.center;
      }
      // setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  List<OptionChainModel> models = [];

  List<String> columns = ConstantValues.all;
  List<DataCell> cellsToShow(OptionChainModel optionChainModel) {
    double width = MediaQuery.of(context).size.width / 5;
    List<DataCell> cells = [];
    var callLTP = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          color: Colors.yellow.withOpacity(0.3),
          child: Text(optionChainModel.call.ltp.toStringAsFixed(2))),
    );
    var callSpread = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          color: Colors.yellow.withOpacity(0.3),
          child: Text(optionChainModel.call.spread.toStringAsFixed(2))),
    );
    var callBid = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          color: Colors.yellow.withOpacity(0.3),
          child: Text(optionChainModel.call.bid.toStringAsFixed(2))),
    );
    var callAsk = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          color: Colors.yellow.withOpacity(0.3),
          child: Text(optionChainModel.call.ask.toStringAsFixed(2))),
    );
    var strike = DataCell(
      Container(
          alignment: Alignment.center,
          width: width,
          height: width,
          color: Colors.yellow.withOpacity(0.3),
          child: Text(optionChainModel.strike.toStringAsFixed(0))),
    );

    var putAsk = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          color: Colors.yellow.withOpacity(0.3),
          child: Text(optionChainModel.put.ask.toStringAsFixed(2))),
    );
    var putBid = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          color: Colors.yellow.withOpacity(0.3),
          child: Text(optionChainModel.put.bid.toStringAsFixed(2))),
    );
    var putSpread = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          color: Colors.yellow.withOpacity(0.3),
          child: Text(optionChainModel.put.spread.toStringAsFixed(2))),
    );
    var putLTP = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          color: Colors.yellow.withOpacity(0.3),
          child: Text(optionChainModel.put.ltp.toStringAsFixed(2))),
    );

    // updateScroll();
    cells.clear();
    cells.add(callLTP);
    cells.add(callSpread);
    cells.add(callBid);
    cells.add(callAsk);
    cells.add(strike);
    cells.add(putAsk);
    cells.add(putBid);
    cells.add(putSpread);
    cells.add(putLTP);
    // setState(() {});

    return cells;
  }

  void updateScroll() {
    if (visibleColumnType == VisibleColumnType.center) {
      _scrollController.animateTo(150,
          duration: Duration(milliseconds: 299), curve: Curves.bounceIn);
    } else if (visibleColumnType == VisibleColumnType.callExpanded) {
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 299), curve: Curves.bounceIn);
    } else if (visibleColumnType == VisibleColumnType.putExpanded) {
      _scrollController.animateTo(310,
          duration: Duration(milliseconds: 299), curve: Curves.bounceIn);
    }
  }

  List<DataRow> generate(List<OptionChainModel> op) {
    return List.generate(
        op.length, (index) => DataRow(cells: cellsToShow(op[index])));
  }

  VisibleColumnType visibleColumnType = VisibleColumnType.center;
  OptionChainModel optionChainModel = OptionChainModel(
      call: StockData(ask: 123.00, bid: 124.00, spread: 144.00, ltp: 22.25),
      put: StockData(ask: 123.00, bid: 124.00, spread: 144.00, ltp: 22.25),
      strike: 15000.00);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible:
                          visibleColumnType == VisibleColumnType.callExpanded ||
                              visibleColumnType == VisibleColumnType.center,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        width: MediaQuery.of(context).size.width /
                            (visibleColumnType == VisibleColumnType.center
                                ? 2.3
                                : 1.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Call"),
                            IconButton(
                                onPressed: () {
                                  if (visibleColumnType ==
                                      VisibleColumnType.callExpanded) {
                                    visibleColumnType =
                                        VisibleColumnType.center;
                                  } else {
                                    visibleColumnType =
                                        VisibleColumnType.callExpanded;
                                  }
                                  updateScroll();

                                  setState(() {});
                                },
                                icon: Icon(FontAwesomeIcons.chevronLeft))
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          visibleColumnType == VisibleColumnType.putExpanded ||
                              visibleColumnType == VisibleColumnType.center,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        width: MediaQuery.of(context).size.width /
                            (visibleColumnType == VisibleColumnType.center
                                ? 2.4
                                : 1.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (visibleColumnType ==
                                      VisibleColumnType.putExpanded) {
                                    visibleColumnType =
                                        VisibleColumnType.center;
                                  } else {
                                    visibleColumnType =
                                        VisibleColumnType.putExpanded;
                                  }
                                  updateScroll();
                                  setState(() {});
                                },
                                icon: Icon(FontAwesomeIcons.chevronRight)),
                            Text("Put"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<OptionChainModel>>(
                  stream: streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // updateScroll();
                      return SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          horizontalMargin: 0,
                          columnSpacing: 0,
                          columns: columns
                              .map((e) => DataColumn(
                                  label: Container(
                                      alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      child: Text(e))))
                              .toList(),
                          rows: generate(snapshot.data!),
                        ),
                      );
                    } else
                      return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
