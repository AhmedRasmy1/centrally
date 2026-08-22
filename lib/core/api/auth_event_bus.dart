import 'dart:async';
import 'package:injectable/injectable.dart';

enum AuthEvent { logout }

@singleton
class AuthEventBus {
  final _controller = StreamController<AuthEvent>.broadcast();

  Stream<AuthEvent> get stream => _controller.stream;

  void fire(AuthEvent event) {
    if (!_controller.isClosed) _controller.add(event);
  }

  void dispose() => _controller.close();
}
