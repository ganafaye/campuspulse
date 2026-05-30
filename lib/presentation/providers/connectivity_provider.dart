import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus {
  online,
  offline,
}

class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityNotifier() : super(ConnectivityStatus.offline) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = await _currentStatus();
    _subscription = _connectivity.onConnectivityChanged.listen(
      (result) async {
        state = await _statusFromResult(result);
      },
    );
  }

  Future<ConnectivityStatus> _currentStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return await _statusFromResult(result);
    } catch (_) {
      return ConnectivityStatus.offline;
    }
  }

  Future<ConnectivityStatus> _statusFromResult(
      ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      return ConnectivityStatus.offline;
    }
    final hasInternet = await _hasInternetAccess();
    return hasInternet ? ConnectivityStatus.online : ConnectivityStatus.offline;
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityStatus>(
  (ref) => ConnectivityNotifier(),
);
