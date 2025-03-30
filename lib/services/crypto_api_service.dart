import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fl_chart/fl_chart.dart';

class CryptoDetailProvider with ChangeNotifier {
  static const Map<String, String> _periodMap = {
    "1H": "1", "1D": "24", "1W": "7", "1M": "30", "6M": "180", "1Y": "365",
  };

  static const Map<String, String> _cryptoIds = {
    "BNB": "binancecoin", "BTC": "bitcoin", "ETH": "ethereum", "XRP": "ripple", "ADA": "cardano", "DOGE": "dogecoin", "SOL": "solana", "MATIC": "matic-network",
  };

  Map<String, dynamic> _cryptoDetails = {};
  List<FlSpot> _chartData = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _selectedPeriod = "1D";

  WebSocketChannel? _channel;

  Map<String, dynamic> get cryptoDetails => _cryptoDetails;
  List<FlSpot> get chartData => _chartData;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get selectedPeriod => _selectedPeriod;

  Future<void> fetchCryptoDetails(String cryptoSymbol) async {
    _setLoading(true);

    cryptoSymbol = _sanitizeSymbol(cryptoSymbol);
    String? cryptoId = _cryptoIds[cryptoSymbol];

    if (cryptoId == null) {
      _setError(true);
      return;
    }

    String url = "https://api.coingecko.com/api/v3/coins/$cryptoId";

    try {
      final response = await _getWithRetry(url);
      if (response == null) {
        _setError(true);
        return;
      }

      final data = jsonDecode(response.body);
      _cryptoDetails = {
        "price": data["market_data"]["current_price"]["usd"] ?? "N/A",
        "rank": data["market_cap_rank"] ?? "N/A",
        "marketCap": data["market_data"]["market_cap"]["usd"] ?? "N/A",
        "maxSupply": data["market_data"]["max_supply"] ?? "N/A",
        "totalSupply": data["market_data"]["total_supply"] ?? "N/A",
        "issueDate": data["genesis_date"] ?? "Unknown",
        "allTimeHigh": data["market_data"]["ath"]["usd"] ?? "N/A",
        "allTimeLow": data["market_data"]["atl"]["usd"] ?? "N/A",
        "website": data["links"]["homepage"].isNotEmpty ? data["links"]["homepage"][0] : "",
        "blockExplorer": data["links"]["blockchain_site"].isNotEmpty ? data["links"]["blockchain_site"][0] : "",
      };
      _setLoading(false);

      // Start WebSocket for real-time updates
      _connectWebSocket(cryptoSymbol);
    } catch (e) {
      debugPrint("Crypto details fetch error: $e");
      _setError(true);
    }
  }

  void _connectWebSocket(String cryptoSymbol) {
    String wsSymbol = cryptoSymbol.toLowerCase();
    _channel = IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws/${wsSymbol}usdt@trade');

    _channel!.stream.listen((message) {
      final data = jsonDecode(message);
      if (data.containsKey("p")) {
        _cryptoDetails["price"] = double.parse(data["p"]).toStringAsFixed(2);

        notifyListeners();
      }
    }, onError: (error) {
      debugPrint("WebSocket Error: $error");
    });
  }

  void disconnectWebSocket() {
    _channel?.sink.close();
  }

  Future<void> fetchChartData(String cryptoSymbol) async {
    _setLoading(true);

    cryptoSymbol = _sanitizeSymbol(cryptoSymbol);
    String? cryptoId = _cryptoIds[cryptoSymbol];
    String? interval = _periodMap[_selectedPeriod];

    if (cryptoId == null || interval == null) {
      _setError(true);
      return;
    }

    String url =
        "https://api.coingecko.com/api/v3/coins/$cryptoId/market_chart?vs_currency=usd&days=$interval";

    try {
      final response = await _getWithRetry(url);
      if (response == null) {
        _setError(true);
        return;
      }

      final data = jsonDecode(response.body);
      List<FlSpot> newChartData = (data["prices"] as List<dynamic>)
          .where((entry) => entry is List && entry.length > 1)
          .map((entry) => FlSpot(
        (entry[0] as num).toDouble(),
        (entry[1] as num).toDouble(),
      ))
          .toList();

      if (newChartData.isNotEmpty) {
        _chartData = newChartData;
        notifyListeners();
      }
      _setLoading(false);
    } catch (e) {
      debugPrint("Chart data fetch error: $e");
      _setError(true);
    }
  }

  void updateSelectedPeriod(String period, String cryptoSymbol) {
    if (_selectedPeriod != period) {
      _selectedPeriod = period;
      fetchChartData(cryptoSymbol);
      notifyListeners();
    }
  }

  static String _sanitizeSymbol(String symbol) =>
      symbol.replaceAll(RegExp(r'USDT|USD'), '').toUpperCase();

  void _setLoading(bool value) {
    _isLoading = value;
    _hasError = false;
    notifyListeners();
  }

  void _setError(bool value) {
    _hasError = value;
    _isLoading = false;
    notifyListeners();
  }

  Future<http.Response?> _getWithRetry(String url, {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          return response;
        } else if (response.statusCode == 429) {
          debugPrint("Rate limit exceeded, retrying in 2 seconds...");
          await Future.delayed(Duration(seconds: 2));
        } else {
          debugPrint("HTTP error: ${response.statusCode}");
          return null;
        }
      } catch (e) {
        debugPrint("Network error: $e");
      }
    }
    return null;
  }
}
