import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static WebSocketChannel connect(String crypto) {
    return IOWebSocketChannel.connect(
        'wss://stream.binance.com:9443/ws/${crypto.toLowerCase()}@trade');
  }
}
