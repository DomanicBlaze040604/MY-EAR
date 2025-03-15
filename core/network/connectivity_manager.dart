import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityManager {
  final _connectivity = Connectivity();
  final _controller = StreamController<ConnectivityStatus>.broadcast();
  Timer? _timer;

  Stream<ConnectivityStatus> get status => _controller.stream;

  ConnectivityManager() {
    _init();
  }

  void _init() {
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });

    // Start periodic connectivity check
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      final result = await _connectivity.checkConnectivity();
      _checkStatus(result);
    });
  }

  Future<void> _checkStatus(ConnectivityResult result) async {
    final status = _getStatus(result);
    _controller.add(status);
  }

  ConnectivityStatus _getStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectivityStatus.online;
      case ConnectivityResult.mobile:
        return ConnectivityStatus.online;
      case ConnectivityResult.ethernet:
        return ConnectivityStatus.online;
      default:
        return ConnectivityStatus.offline;
    }
  }

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet;
  }

  void dispose() {
    _controller.close();
    _timer?.cancel();
  }
}

enum ConnectivityStatus { online, offline }
