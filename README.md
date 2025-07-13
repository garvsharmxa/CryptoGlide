# CryptoGlide

**CryptoGlide** is a modern, real-time cryptocurrency portfolio and market tracking app built with Flutter. It features real-time price updates via Binance WebSocket, beautiful UI/UX with dark mode support, detailed crypto analytics and charts, portfolio management, and customizable settings.

## Features

- **Live Market Tracker:**  
  View trending, top, and favorite cryptocurrencies with real-time prices, percentage changes, and color-coded indicators.

- **Portfolio Management:**  
  Track your top crypto holdings, view total balance and performance, and see detailed stats for each holding.

- **Crypto Details:**  
  Tap any coin for animated details including live price, interactive charts (powered by fl_chart), supply/cap stats, all-time high/low, and external links.

- **Real-Time Data:**  
  Prices, charts, and stats update live using Binance WebSocket and CoinGecko API.

- **Beautiful UI:**  
  Animated cards, custom gradients, icons, and smooth transitions. Full support for both light and dark themes.

- **Settings:**  
  Toggle notifications, enable two-factor authentication, manage wallets, and more—all from a unified settings page.

- **Extensible:**  
  Built using Provider for state management. Easily add new coins, widgets, or features.

## Screenshots

<img src="assets/screenshots/market_dark.png" width="320"/>
<img src="assets/screenshots/portfolio_light.png" width="320"/>
<img src="assets/screenshots/details_chart.png" width="320"/>
<img src="assets/screenshots/settings.png" width="320"/>

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0 recommended)
- Dart (Compatible with your Flutter version)
- Android Studio, VSCode, or other IDE

### Installation

1. **Clone the repo:**
   ```bash
   git clone https://github.com/Manshi2921/CryptoGlide.git
   cd CryptoGlide
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Directory Structure

```
lib/
  features/
    crypto/           # Market tracker & details
    Portfolio/        # Portfolio screen
    Settings /        # Settings screen
  providers/          # State management (Provider)
  services/           # API/WebSocket services
  Widgets/            # Reusable widgets (e.g., bottom nav bar)
  main.dart           # App entry point
assets/
  icons/              # Crypto icons (png)
  screenshots/        # App screenshots
```

## Main Packages Used

- [provider](https://pub.dev/packages/provider) — State management
- [fl_chart](https://pub.dev/packages/fl_chart) — Animated charts
- [web_socket_channel](https://pub.dev/packages/web_socket_channel) — Real-time data from Binance
- [http](https://pub.dev/packages/http) — REST API for CoinGecko
- [google_fonts](https://pub.dev/packages/google_fonts) — Custom fonts
- [shimmer](https://pub.dev/packages/shimmer) — Loading animations

## Customization

- **Add new coins:**  
  Edit `cryptos` and `cryptoNames` in `CryptoProvider` or `PortfolioProvider`.
- **Add icons:**  
  Place PNG icon in `assets/icons/` named as `<SYMBOL>.png` (e.g., `BTCUSDT.png`) and update `pubspec.yaml`.
- **Change theme colors:**  
  Edit color values in widgets or override theme in `main.dart`.

## API & Data Sources

- [Binance WebSocket API](https://binance-docs.github.io/apidocs/spot/en/#websocket-market-streams)
- [CoinGecko API](https://www.coingecko.com/en/api/documentation)

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)

---

## About

Maintained by [Garv](https://github.com/garvsharmxa)  
For any questions or feature requests, open a GitHub issue or contact me.
