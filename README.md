# CryptoGlide - Real-Time Cryptocurrency Tracker

CryptoGlide is a Flutter-based mobile application that provides real-time cryptocurrency price tracking using WebSockets. The app features dynamic price updates, interactive charts with customizable time periods, and a clean, intuitive user interface.

## Features

### Real-Time Cryptocurrency Tracking
- Live price updates via Binance WebSocket API
- Supports multiple cryptocurrencies including BTC, ETH, BNB, SOL, XRP, ADA, DOGE, MATIC
- Instant price change indicators with visual feedback

### Interactive Price Charts
- Interactive line charts using fl_chart
- Multiple time period options (1H, 1D, 1W, 1M, 6M, 1Y)
- Smooth animations and responsive UI

### Portfolio Management
- Track your crypto holdings in one place
- View total balance and individual asset performance
- Real-time updates on portfolio value

### Clean and Modern UI
- Dark and light theme support
- Responsive design for different screen sizes
- Smooth animations and transitions

## Screenshots

![Simulator Screenshot - Iphone 16 - 2025-03-30 at 22 55 42](https://github.com/user-attachments/assets/3601edf3-c973-4ac5-a923-a1ba5809a626)

![Simulator Screenshot - Iphone 16 - 2025-03-30 at 22 55 51](https://github.com/user-attachments/assets/d9cb8d13-7ccd-40d2-be49-e627659365a3)

![Simulator Screenshot - Iphone 16 - 2025-03-30 at 22 55 46](https://github.com/user-attachments/assets/ec3d1a99-90aa-4a3d-aa96-025b242f459a)

![Simulator Screenshot - Iphone 16 - 2025-03-30 at 23 04 56](https://github.com/user-attachments/assets/18f8a6f3-d293-4371-a3ae-e555546dc04d)




## Architecture

CryptoGlide follows a clean architecture approach with:

- **Provider Pattern** for state management
- **WebSocket Services** for real-time data
- **Repository Pattern** for data handling

### Project Structure

```
lib/
├── features/
│   ├── crypto/
│   │   ├── crypto_tracker_screen.dart
│   │   └── crypto_details_screen.dart
│   ├── portfolio/
│   │   └── portfolio_screen.dart
│   └── settings/
│       └── setting_screen.dart
├── providers/
│   ├── crypto_provider.dart
│   └── portfolio_provider.dart
├── services/
│   ├── crypto_api_service.dart
│   └── websocket_service.dart
├── widgets/
│   └── bottom_nav_bar.dart
└── main.dart
```

## APIs Used

- **Binance WebSocket API** - For real-time cryptocurrency price data
- **CoinGecko API** - For historical price data and cryptocurrency details

## Getting Started

### Prerequisites

- Flutter 2.10.0 or higher
- Dart 2.16.0 or higher

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/cryptoglide.git
```

2. Navigate to project directory
```bash
cd cryptoglide
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Implementation Details

### WebSocket Connection

The app connects to Binance's WebSocket API to receive real-time price updates:

```dart
String wsSymbol = cryptoSymbol.toLowerCase();
_channel = IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws/${wsSymbol}usdt@trade');
```

### Chart Data

Chart data is fetched from CoinGecko API with customizable time periods:

```dart
String url = "https://api.coingecko.com/api/v3/coins/$cryptoId/market_chart?vs_currency=usd&days=$interval";
```

### State Management

The app uses Provider for state management:

```dart
return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => CryptoProvider()),
    ChangeNotifierProvider(create: (_) => PortfolioProvider()),
  ],
  child: const CryptoApp(),
);
```

## Libraries Used

- **provider**: For state management
- **http**: For API requests
- **web_socket_channel**: For WebSocket connections
- **fl_chart**: For interactive charts
- **google_fonts**: For typography
- **shimmer**: For loading animations

## Future Improvements

- Price alerts and push notifications
- User authentication and cloud sync
- More detailed technical analysis tools
- Additional cryptocurrencies and custom watchlists
- News integration

## License

[Your License Here]

## Acknowledgments

- [Binance API](https://developers.binance.com/docs/binance-spot-api-docs/web-socket-streams) for real-time data
- [CoinGecko API](https://www.coingecko.com/en/api) for cryptocurrency information
