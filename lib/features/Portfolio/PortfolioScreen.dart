import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../providers/PortfolioProvider.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final Map<String, String> cryptoNames = {
      "BTCUSDT": "Bitcoin",
      "ETHUSDT": "Ethereum",
      "SOLUSDT": "Solana",
      "BNBUSDT": "Binance Coin",
    };

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Portfolio',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _totalBalanceCard(cardColor, textColor),
              const SizedBox(height: 20),
              _actionButtons(isDarkMode),
              const SizedBox(height: 30),
              Text(
                "Top Cryptos",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 15),
              ...portfolioProvider.cryptoData.keys.map(
                (symbol) =>
                    portfolioProvider.isLoading
                        ? _shimmerCard(cardColor)
                        : _cryptoCard(
                          symbol,
                          portfolioProvider.cryptoData,
                          cryptoNames,
                          cardColor,
                          textColor,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalBalanceCard(Color cardColor, Color textColor) => Container(
    padding: const EdgeInsets.all(20),
    decoration: _cardDecoration(cardColor),
    child: Row(
      children: [
        Icon(Icons.account_balance_wallet, size: 40, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Balance",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            SizedBox(height: 5),
            Text(
              "\$12,540.75",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _actionButtons(bool isDarkMode) => Row(
    children: [
      _actionButton(
        "Deposit",
        Icons.download,
        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        isDarkMode,
      ),
      const SizedBox(width: 10),
      _actionButton(
        "Buy Crypto",
        Icons.shopping_cart,
        Colors.blueAccent.shade400,
        isDarkMode,
      ),
    ],
  );

  Widget _actionButton(
    String text,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) => Expanded(
    child: ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: color,
      ),
      icon: Icon(
        icon,
        color: isDarkMode ? Colors.white : Colors.black,
        size: 22,
      ),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    ),
  );

  Widget _cryptoCard(
    String symbol,
    Map<String, dynamic> cryptoData,
    Map<String, String> cryptoNames,
    Color cardColor,
    Color textColor,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration(cardColor),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset('Assets/icons/$symbol.png', width: 40),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cryptoNames[symbol] ?? symbol,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "\$${cryptoData[symbol]['price'].toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Row(
              children: [
                Icon(
                  cryptoData[symbol]['isIncreasing']
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color:
                      cryptoData[symbol]['isIncreasing']
                          ? Colors.green
                          : Colors.red,
                  size: 20,
                ),
                Text(
                  "${cryptoData[symbol]['change'].toStringAsFixed(2)}%",
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        cryptoData[symbol]['isIncreasing']
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  Widget _shimmerCard(Color cardColor) => Shimmer.fromColors(
    baseColor: cardColor,
    highlightColor: Colors.grey.shade100,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(cardColor),
      height: 70,
    ),
  );

  BoxDecoration _cardDecoration(Color color) =>
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(15));
}
