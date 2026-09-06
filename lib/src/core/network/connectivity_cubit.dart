import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectivityStatus { unknown, connected, disconnected }

class ConnectivityState {
  final ConnectivityStatus status;
  final bool wasEverConnected;
  final int reconnectCounter;
  final bool isChecking;

  const ConnectivityState({
    this.status = ConnectivityStatus.unknown,
    this.wasEverConnected = false,
    this.reconnectCounter = 0,
    this.isChecking = false,
  });

  bool get isConnected => status == ConnectivityStatus.connected;
  bool get isDisconnected => status == ConnectivityStatus.disconnected;

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    bool? wasEverConnected,
    int? reconnectCounter,
    bool? isChecking,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      wasEverConnected: wasEverConnected ?? this.wasEverConnected,
      reconnectCounter: reconnectCounter ?? this.reconnectCounter,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  ConnectivityCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(const ConnectivityState()) {
    _init();
  }

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _onResult(results);
    _sub = _connectivity.onConnectivityChanged.listen(_onResult);
  }

  void _onResult(List<ConnectivityResult> results) {
    final hasNet = results.any((r) => r != ConnectivityResult.none);
    final newStatus =
        hasNet ? ConnectivityStatus.connected : ConnectivityStatus.disconnected;
    final wasEver = state.wasEverConnected || hasNet;
    final isRestoring = hasNet && (state.status == ConnectivityStatus.disconnected || (!state.wasEverConnected && state.status != ConnectivityStatus.unknown));
    emit(state.copyWith(
      status: newStatus,
      wasEverConnected: wasEver,
      reconnectCounter: isRestoring ? state.reconnectCounter + 1 : state.reconnectCounter,
    ));
  }

  Future<void> retry() async {
    if (state.isChecking) return;
    emit(state.copyWith(isChecking: true));
    try {
      final results = await _connectivity.checkConnectivity();
      bool hasNet = results.any((r) => r != ConnectivityResult.none);
      if (hasNet) {
        try {
          final lookup = await InternetAddress.lookup('1.1.1.1')
              .timeout(const Duration(seconds: 2));
          hasNet = lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
        } catch (_) {
          // Keep hasNet as reported by system interface if lookup timed out
        }
      }
      final newStatus =
          hasNet ? ConnectivityStatus.connected : ConnectivityStatus.disconnected;
      final wasEver = state.wasEverConnected || hasNet;
      emit(state.copyWith(
        status: newStatus,
        wasEverConnected: wasEver,
        reconnectCounter: hasNet ? state.reconnectCounter + 1 : state.reconnectCounter,
        isChecking: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ConnectivityStatus.disconnected,
        isChecking: false,
      ));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
