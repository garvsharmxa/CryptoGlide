import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class CryptoProvider with ChangeNotifier {
  final String _binanceSocketUrl = "wss://stream.binance.com:9443/ws";
  late final IOWebSocketChannel _channel;

  final List<String> cryptos = [
    'BNBUSDT', 'BTCUSDT', 'ETHUSDT', 'SOLUSDT', 'XRPUSDT',
    'ADAUSDT', 'DOGEUSDT', 'MATICUSDT', 'DOTUSDT', 'LTCUSDT'
  ];

  final Map<String, String> cryptoNames = {
    "BTCUSDT": "Bitcoin",
    "ETHUSDT": "Ethereum",
    "SOLUSDT": "Solana",
    "BNBUSDT": "Binance Coin",
    "XRPUSDT": "XRP",
    "ADAUSDT": "Cardano",
    "DOGEUSDT": "Dogecoin",
    "MATICUSDT": "Polygon",
    "DOTUSDT": "Polkadot",
    "LTCUSDT": "Litecoin",
  };

  Map<String, double> _previousPrices = {};
  Map<String, Map<String, dynamic>> _cryptoData = {};
  bool _isLoading = true;

  CryptoProvider() {
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    String streams = cryptos.map((crypto) => "${crypto.toLowerCase()}@ticker").join("/");
    _channel = IOWebSocketChannel.connect("$_binanceSocketUrl/$streams");

    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      String symbol = data["s"]; // Symbol from Binance

      if (symbol.isNotEmpty && cryptos.contains(symbol)) {
        double currentPrice = double.tryParse(data["c"]?.toString() ?? "0") ?? 0.0;
        double previousPrice = _previousPrices[symbol] ?? currentPrice;

        // Calculate percentage change
        double change = previousPrice != 0 ? ((currentPrice - previousPrice) / previousPrice) * 100 : 0.0;
        bool isIncreasing = currentPrice >= previousPrice;

        // Store updated values
        _previousPrices[symbol] = currentPrice;
        _cryptoData[symbol] = {
          "price": currentPrice,
          "change": change,
          "isIncreasing": isIncreasing,
        };

        _isLoading = false;
        notifyListeners();
      }
    }, onError: (error) {
      print("WebSocket error: $error");
    });
  }

  Map<String, Map<String, dynamic>> get cryptoData => _cryptoData;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
