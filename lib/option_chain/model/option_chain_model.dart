import 'dart:convert';

import 'package:flutter_application_1/option_chain/model/stock_data_model.dart';

class OptionChainModel {
  final StockData call;
  final StockData put;
  final double strike;
  OptionChainModel({
    required this.call,
    required this.put,
    required this.strike,
  });

  OptionChainModel copyWith({
    StockData? call,
    StockData? put,
    double? strike,
  }) {
    return OptionChainModel(
      call: call ?? this.call,
      put: put ?? this.put,
      strike: strike ?? this.strike,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'call': call.toMap(),
      'put': put.toMap(),
      'strike': strike,
    };
  }

  factory OptionChainModel.fromMap(Map<String, dynamic> map) {
    return OptionChainModel(
      call: StockData.fromMap(map['call']),
      put: StockData.fromMap(map['put']),
      strike: map['strike']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OptionChainModel.fromJson(String source) =>
      OptionChainModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'OptionChainModel(call: $call, put: $put, strike: $strike)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OptionChainModel &&
        other.call == call &&
        other.put == put &&
        other.strike == strike;
  }

  @override
  int get hashCode => call.hashCode ^ put.hashCode ^ strike.hashCode;
}
