import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../services/crypto_api_service.dart';

class CryptoDetailsScreen extends StatelessWidget {
  final String cryptoSymbol;

  const CryptoDetailsScreen({super.key, required this.cryptoSymbol});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) {
        final provider = CryptoDetailProvider();
        provider.fetchChartData(cryptoSymbol);
        provider.fetchCryptoDetails(cryptoSymbol);
        return provider;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          title: Text(
            "$cryptoSymbol Price",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          elevation: 0,
        ),
        body: Consumer<CryptoDetailProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildPeriodSelector(context, isDarkMode),
                  const SizedBox(height: 20),
                  _buildPrice(provider),
                  SizedBox(
                    height: 300,
                    child: _buildChart(provider, isDarkMode),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildCryptoDetails(provider, isDarkMode),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrice(CryptoDetailProvider provider) {
    return Row(
      children: [
        SizedBox(width: 10),
        Text(
          "${provider.cryptoDetails['price'] != null ? "\$${provider.cryptoDetails['price']}" : "Loading..."}",
          style: TextStyle(
            fontSize: 25,
            color: Colors.green,
            fontWeight: FontWeight.w700,
          ),
        ),
        Spacer(),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildPeriodSelector(BuildContext context, bool isDarkMode) {
    return Selector<CryptoDetailProvider, String>(
      selector: (_, provider) => provider.selectedPeriod,
      builder: (context, selectedPeriod, _) {
        List<String> periods = ["1H", "1D", "1W", "1M", "6M", "1Y"];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              periods.map((period) {
                bool isSelected = selectedPeriod == period;
                return GestureDetector(
                  onTap:
                      () => context
                          .read<CryptoDetailProvider>()
                          .updateSelectedPeriod(period, cryptoSymbol),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.blueAccent
                              : (isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[300]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      period,
                      style: TextStyle(
                        color:
                            isSelected
                                ? Colors.white
                                : (isDarkMode ? Colors.white70 : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildCryptoDetails(CryptoDetailProvider provider, bool isDarkMode) {
    if (provider.cryptoDetails.isEmpty)
      return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          provider.cryptoDetails.entries
              .map(
                (entry) => _buildInfoRow(
                  entry.key,
                  entry.value.toString(),
                  isDarkMode,
                ),
              )
              .toList(),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(CryptoDetailProvider provider, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black54 : Colors.black26,
            blurRadius: 10,
          ),
        ],
      ),
      child:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.hasError
              ? const Center(
                child: Text(
                  "Error loading chart",
                  style: TextStyle(color: Colors.red),
                ),
              )
              : LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: provider.chartData,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.15),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
    );
  }
}
