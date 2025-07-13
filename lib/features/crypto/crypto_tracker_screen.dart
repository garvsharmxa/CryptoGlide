import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/crypto_provider.dart';
import 'crypto_details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CryptoTrackerScreen extends StatelessWidget {
  const CryptoTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cryptoProvider = Provider.of<CryptoProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(isDarkMode),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isDarkMode
                    ? [const Color(0xFF0A0A0A), const Color(0xFF1A1A1A)]
                    : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildHeaderStats(cryptoProvider, isDarkMode),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:
                    cryptoProvider.isLoading
                        ? _buildLoadingState(isDarkMode)
                        : _buildCryptoList(cryptoProvider, isDarkMode, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.trending_up, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'Crypto Watchlist',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.search,
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
              size: 20,
            ),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeaderStats(CryptoProvider cryptoProvider, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDarkMode
                  ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                  : [Colors.white, const Color(0xFFF8FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            "Total Assets",
            "${cryptoProvider.cryptos.length}",
            Icons.account_balance_wallet,
            const Color(0xFF3B82F6),
            isDarkMode,
          ),
          Container(
            height: 40,
            width: 1,
            color: (isDarkMode ? Colors.white : Colors.grey).withOpacity(0.2),
          ),
          _buildStatItem(
            "Market Cap",
            "\$2.4T",
            Icons.trending_up,
            const Color(0xFF10B981),
            isDarkMode,
          ),
          Container(
            height: 40,
            width: 1,
            color: (isDarkMode ? Colors.white : Colors.grey).withOpacity(0.2),
          ),
          _buildStatItem(
            "24h Change",
            "+5.2%",
            Icons.show_chart,
            const Color(0xFF059669),
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isDarkMode ? Colors.white60 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return ListView.builder(
      itemCount: 10,
      physics: const BouncingScrollPhysics(),
      itemBuilder:
          (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Shimmer.fromColors(
              baseColor:
                  isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              highlightColor:
                  isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 18,
                            decoration: BoxDecoration(
                              color:
                                  isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 100,
                            height: 14,
                            decoration: BoxDecoration(
                              color:
                                  isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 80,
                          height: 20,
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 14,
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildCryptoList(
    CryptoProvider cryptoProvider,
    bool isDarkMode,
    BuildContext context,
  ) {
    return ListView.builder(
      itemCount: cryptoProvider.cryptos.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        String crypto = cryptoProvider.cryptos[index];
        String fullName = cryptoProvider.cryptoNames[crypto] ?? crypto;
        double price = cryptoProvider.cryptoData[crypto]?['price'] ?? 0.0;
        bool isIncreasing =
            cryptoProvider.cryptoData[crypto]?['isIncreasing'] ?? false;
        double change = cryptoProvider.cryptoData[crypto]?['change'] ?? 0.0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        CryptoDetailsScreen(
                          cryptoSymbol: crypto,
                        ),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutCubic;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Hero(
            tag: crypto,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      isDarkMode
                          ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                          : [Colors.white, const Color(0xFFF8FAFC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDarkMode
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color:
                      isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  _buildCryptoIcon(crypto, isDarkMode),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color:
                                isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          crypto.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                isDarkMode ? Colors.white60 : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${price.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color:
                              isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: (isIncreasing
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444))
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isIncreasing
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color:
                                  isIncreasing
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${change.toStringAsFixed(2)}%",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color:
                                    isIncreasing
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCryptoIcon(String crypto, bool isDarkMode) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: _getCryptoGradient(crypto),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _getCryptoGradient(crypto)[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'Assets/icons/$crypto.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _getCryptoGradient(crypto),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.currency_bitcoin,
                  size: 30,
                  color: Colors.white,
                ),
              ),
        ),
      ),
    );
  }

  List<Color> _getCryptoGradient(String crypto) {
    switch (crypto.toLowerCase()) {
      case 'btc':
        return [const Color(0xFFF7931A), const Color(0xFFFFB800)];
      case 'eth':
        return [const Color(0xFF627EEA), const Color(0xFF3C3C3D)];
      case 'bnb':
        return [const Color(0xFFF3BA2F), const Color(0xFFF0B90B)];
      case 'ada':
        return [const Color(0xFF0033AD), const Color(0xFF3468C0)];
      case 'dot':
        return [const Color(0xFFE6007A), const Color(0xFFE6007A)];
      case 'xrp':
        return [const Color(0xFF23292F), const Color(0xFF525860)];
      case 'sol':
        return [const Color(0xFF9945FF), const Color(0xFF14F195)];
      case 'doge':
        return [const Color(0xFFC2A633), const Color(0xFFD4AF37)];
      case 'avax':
        return [const Color(0xFFE84142), const Color(0xFFE84142)];
      case 'matic':
        return [const Color(0xFF8247E5), const Color(0xFF8247E5)];
      default:
        return [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];
    }
  }
}
