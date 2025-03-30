import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class PortfolioProvider with ChangeNotifier {
  final String _binanceSocketUrl = "wss://stream.binance.com:9443/ws";
  late final IOWebSocketChannel _channel;

  Map<String, dynamic> _cryptoData = {
    for (var symbol in ["BTCUSDT", "ETHUSDT", "SOLUSDT", "BNBUSDT"])
      symbol: {"price": 0.0, "change": 0.0, "isIncreasing": true},
  };

  bool _isLoading = true;

  PortfolioProvider() {
    _channel = IOWebSocketChannel.connect(
      "$_binanceSocketUrl/bnbusdt@ticker/btcusdt@ticker/ethusdt@ticker/solusdt@ticker",
    );
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data.containsKey("s") && _cryptoData.containsKey(data["s"])) {
        _cryptoData[data["s"]] = {
          "price": double.parse(data["c"]),
          "change": double.parse(data["P"]),
          "isIncreasing": double.parse(data["P"]) >= 0,
        };
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Map<String, dynamic> get cryptoData => _cryptoData;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
