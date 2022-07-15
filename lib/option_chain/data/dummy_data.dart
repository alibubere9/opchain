import 'dart:async';
import 'dart:math';

import 'package:flutter_application_1/option_chain/model/option_chain_model.dart';

import '../model/stock_data_model.dart';

StreamController<List<OptionChainModel>> streamController = StreamController();
Stream<List<OptionChainModel>> opChStream() async* {
  var list = List.generate(
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
          strike: Random().nextInt(16000).toDouble()));
  streamController.add(list);
  yield list;
}
