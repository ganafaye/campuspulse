import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus {
  checking,
  online,
  offline,
}

class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityNotifier() : super(ConnectivityStatus.checking) {
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
    // First try DNS lookup
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) {
      // ignore and try HTTP fallback
    }

    // Fallback: try a lightweight HTTP request used by many platforms
    try {
      final uri = Uri.parse('https://clients3.google.com/generate_204');
      final httpClient = HttpClient()
        ..connectionTimeout = const Duration(seconds: 5);
      final request =
          await httpClient.getUrl(uri).timeout(const Duration(seconds: 5));
      request.followRedirects = false;
      final response =
          await request.close().timeout(const Duration(seconds: 5));
      httpClient.close();
      return response.statusCode == 204;
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
