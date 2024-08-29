import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  static IO.Socket? socket;

  void connect(String token) {
    socket?.disconnect();
    socket = IO.io(
      'https://api.sportdivers.tn',
      IO.OptionBuilder()
          .setTransports(['websocket']).setAuth({"token": token}).build(),
    );
    socket!.on('connect', (_) {
      print('Connected to server');
    });
    socket!.on('connect_error', (error) {
      print(error);
    });
    socket!.on('connect_time_out', (error) {
      print(error);
    });
    socket!.on('error', (error) {
      print(error);
    });
    socket!.connect();
  }
}
