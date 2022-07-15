import 'dart:convert';

class StockData {
  final double ask;
  final double bid;
  final double spread;
  final double ltp;
  StockData({
    required this.ask,
    required this.bid,
    required this.spread,
    required this.ltp,
  });

  StockData copyWith({
    double? ask,
    double? bid,
    double? spread,
    double? ltp,
  }) {
    return StockData(
      ask: ask ?? this.ask,
      bid: bid ?? this.bid,
      spread: spread ?? this.spread,
      ltp: ltp ?? this.ltp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ask': ask,
      'bid': bid,
      'spread': spread,
      'ltp': ltp,
    };
  }

  factory StockData.fromMap(Map<String, dynamic> map) {
    return StockData(
      ask: map['ask']?.toDouble() ?? 0.0,
      bid: map['bid']?.toDouble() ?? 0.0,
      spread: map['spread']?.toDouble() ?? 0.0,
      ltp: map['ltp']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory StockData.fromJson(String source) =>
      StockData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StockData(ask: $ask, bid: $bid, spread: $spread, ltp: $ltp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockData &&
        other.ask == ask &&
        other.bid == bid &&
        other.spread == spread &&
        other.ltp == ltp;
  }

  @override
  int get hashCode {
    return ask.hashCode ^ bid.hashCode ^ spread.hashCode ^ ltp.hashCode;
  }
}
