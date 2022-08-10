import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/option_chain/constants.dart';
import 'package:flutter_application_1/option_chain/data/dummy_data.dart';
import 'package:flutter_application_1/option_chain/model/option_chain_model.dart';
import 'package:flutter_application_1/option_chain/model/stock_data_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OptionChainWidget extends StatefulWidget {
  const OptionChainWidget({Key? key}) : super(key: key);

  @override
  State<OptionChainWidget> createState() => _OptionChainWidgetState();
}

enum VisibleColumnType { center, callExpanded, putExpanded }

class _OptionChainWidgetState extends State<OptionChainWidget> {
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 165);
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
      } else if (_scrollController.offset > 270) {
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

  List<DataCell> cellsToShow(OptionChainModel optionChainModel, int index) {
    double width = MediaQuery.of(context).size.width / 5;
    List<DataCell> cells = [];
    var callLTP = DataCell(
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: width,
            width: width,
            decoration: BoxDecoration(
              color: Color(0xfff5f8fe),
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey),
                right: BorderSide(width: 0.5, color: Colors.grey),
                left: BorderSide(width: 0.5, color: Colors.grey),
              ),
            ),
            child: Visibility(
              visible: visibleColumnType == VisibleColumnType.callExpanded,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xfff5d6da),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(3),
                        topRight: Radius.circular(3))),
                height: 30,
                width: width * (Random().nextInt(10) / 10),
              ),
            ),
          ),
          Center(
            child: Text(
              optionChainModel.call.ltp.toStringAsFixed(2),
            ),
          ),
        ],
      ),
    );
    var callSpread = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          decoration: BoxDecoration(
            color: Color(0xfff5f8fe),
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey),
              right: BorderSide(width: 0.5, color: Colors.grey),
            ),
          ),
          child: Text(optionChainModel.call.spread.toStringAsFixed(2))),
    );
    var callBid = DataCell(
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: width,
            width: width,
            decoration: BoxDecoration(
              color: Color(0xfff5f8fe),
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey),
                right: BorderSide(width: 0.5, color: Colors.grey),
              ),
            ),
            child: Visibility(
              visible: visibleColumnType == VisibleColumnType.center,
              child: Container(
                height: 30,
                width: width * (Random().nextInt(10) / 10),
                decoration: BoxDecoration(
                    color: Color(0xfff5d6da),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(3),
                        bottomRight: Radius.circular(3))),
              ),
            ),
          ),
          Center(
            child: Text(
              optionChainModel.call.bid.toStringAsFixed(2),
            ),
          ),
          Visibility(
            visible: (index == 3 || index == 5) || (index == 2 || index == 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.all(2),
                width: 25,
                alignment: Alignment.centerRight,
                height: 15,
                decoration: BoxDecoration(
                  color: (index == 2 || index == 5) ? Colors.red : Colors.green,
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey),
                    right: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                ),
                child: Text(
                  Random().nextInt(150).toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    var callAsk = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          decoration: BoxDecoration(
            color: Color(0xfff5f8fe),
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey),
              right: BorderSide(width: 0.5, color: Colors.grey),
            ),
          ),
          child: Text(optionChainModel.call.ask.toStringAsFixed(2))),
    );
    var f = NumberFormat("##,###", "en_US");
    var strike = DataCell(
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.centerRight,
            height: width,
            width: width,
            decoration: BoxDecoration(
              color: Color(0xfffefaf5),
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey),
                right: BorderSide(width: 0.5, color: Colors.grey),
              ),
            ),
            child: Visibility(
              visible: Random().nextInt(5) < 3,
              child: Container(
                width: 5,
                color: Color(0xfff4daac),
              ),
            ),
          ),
          Center(
            child: Text(
              f.format(optionChainModel.strike),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    var putAsk = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey),
              right: BorderSide(width: 0.5, color: Colors.grey),
            ),
          ),
          child: Text(optionChainModel.put.ask.toStringAsFixed(2))),
    );
    var putBid = DataCell(
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.centerRight,
            height: width,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey),
                right: BorderSide(width: 0.5, color: Colors.grey),
              ),
            ),
            child: Visibility(
              visible: visibleColumnType == VisibleColumnType.center,
              child: Container(
                height: 30,
                width: width * (Random().nextInt(10) / 10),
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3),
                        bottomLeft: Radius.circular(3))),
              ),
            ),
          ),
          Center(
            child: Text(
              optionChainModel.put.bid.toStringAsFixed(2),
            ),
          ),
          Visibility(
            visible: (index == 3 || index == 5) || (index == 2 || index == 4),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(2),
                width: 25,
                alignment: Alignment.centerRight,
                height: 15,
                decoration: BoxDecoration(
                  color: (index == 2 || index == 5) ? Colors.green : Colors.red,
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey),
                    right: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                ),
                child: Text(
                  Random().nextInt(150).toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    var putSpread = DataCell(
      Container(
          height: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey),
              right: BorderSide(width: 0.5, color: Colors.grey),
            ),
          ),
          child: Text(optionChainModel.put.spread.toStringAsFixed(2))),
    );
    var putLTP = DataCell(
      Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: visibleColumnType == VisibleColumnType.putExpanded,
            child: Container(
                alignment: Alignment.centerRight,
                height: width,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey),
                    right: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                ),
                child: Container(
                  height: 30,
                  width: width * (Random().nextInt(10) / 10),
                  decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3),
                          bottomLeft: Radius.circular(3))),
                )),
          ),
          Center(
            child: Text(
              optionChainModel.put.ltp.toStringAsFixed(2),
            ),
          ),
        ],
      ),
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
    double w = MediaQuery.of(context).size.width / 5;

    if (visibleColumnType == VisibleColumnType.center) {
      _scrollController.animateTo(165,
          duration: Duration(milliseconds: 299), curve: Curves.bounceIn);
    } else if (visibleColumnType == VisibleColumnType.callExpanded) {
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 299), curve: Curves.bounceIn);
    } else if (visibleColumnType == VisibleColumnType.putExpanded) {
      _scrollController.animateTo(320,
          duration: Duration(milliseconds: 299), curve: Curves.bounceIn);
    }
  }

  List<DataRow> generate(List<OptionChainModel> op) {
    return List.generate(
        op.length, (index) => DataRow(cells: cellsToShow(op[index], index)));
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
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible:
                          visibleColumnType == VisibleColumnType.callExpanded ||
                              visibleColumnType == VisibleColumnType.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width /
                                  (visibleColumnType == VisibleColumnType.center
                                      ? 2.55
                                      : 1.14),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: Center(
                                  child: Text(
                                "Call".toUpperCase(),
                                style: TextStyle(color: Colors.black),
                              ))),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: IconButton(
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
                                icon: Icon(
                                  FontAwesomeIcons.angleDoubleLeft,
                                  color: Colors.black,
                                  size: 15,
                                )),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible:
                          visibleColumnType == VisibleColumnType.putExpanded ||
                              visibleColumnType == VisibleColumnType.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: IconButton(
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
                                icon: Icon(FontAwesomeIcons.angleDoubleRight,
                                    size: 15, color: Colors.black)),
                          ),
                          Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width /
                                  (visibleColumnType == VisibleColumnType.center
                                      ? 2.55
                                      : 1.14),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: Center(
                                  child: Text(
                                "put".toUpperCase(),
                                style: TextStyle(color: Colors.black),
                              ))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Column(
                    children: [
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
                                  columns: [
                                    DataColumn(
                                        label: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Text(
                                              "LTP",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                    DataColumn(
                                        label: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Text(
                                              "Spread",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                    DataColumn(
                                        label: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Bid",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  "(SELL)",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ))),
                                    DataColumn(
                                        label: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Ask",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  "(BUY)",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ))),
                                    DataColumn(
                                        label: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Strike",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "(12)",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      FontAwesomeIcons
                                                          .chevronDown,
                                                      size: 8,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ))),
                                    DataColumn(
                                        label: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Ask",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "(BUY)",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ))),
                                    DataColumn(
                                        label: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Bid",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "(SELL)",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ))),
                                    DataColumn(
                                        label: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Text(
                                              "Spread",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                    DataColumn(
                                        label: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Text(
                                              "LTP",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                  ],
                                  rows: generate(snapshot.data!),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width / 5 * 1.65,
                    child: Container(
                      child: Row(
                        children: [
                          Text("SD - 1",
                              style:
                                  TextStyle(color: Colors.brown, fontSize: 10)),
                          Text(
                            " -------------------------------------------------------------",
                            style: TextStyle(color: Colors.brown, fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width / 5 * 1.72 * 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("ITM",
                                style: TextStyle(
                                    color: Colors.blue.shade700, fontSize: 10)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.blue.shade700,
                            height: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width / 5 * 5.14,
                    child: Container(
                      child: Row(
                        children: [
                          Text("SD - 2",
                              style:
                                  TextStyle(color: Colors.brown, fontSize: 10)),
                          Text(
                            " -------------------------------------------------------------",
                            style: TextStyle(color: Colors.brown, fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
