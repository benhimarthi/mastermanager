import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mastermanager/features/authentication/synchronisation/cubit/sync.trigger.state.dart';
import '../../data/data_source/sync.manager.dart';

class SyncTriggerCubit extends Cubit<SyncTriggerState> {
  final SyncManager _syncManager;
  Timer? _syncTimer;
  late final StreamSubscription<ConnectivityResult> _subscription;

  SyncTriggerCubit(this._syncManager) : super(SyncInitial()) {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        runOnAppStart();
      }
    });
  }

  void startSyncing() {
    _syncTimer = Timer.periodic(const Duration(minutes: 10), (timer) async {
      //print("TTTTTTTTTTTTTTTTGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
      emit(SyncInProgress()); // 🔄 Sync is happening
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _syncManager.syncData();
          emit(SyncSuccess()); // ✅ Sync completed successfully
        } catch (e) {
          emit(SyncFailure(e.toString())); // ❌ Handle sync failure
        }
      }
    });
  }

  void runOnAppStart() async {
    print("XVVVVVVVVVVVVVVVVYUUUUUUUUUUUUUU");
    emit(SyncInProgress());
    try {
      await _syncManager.syncData();
      emit(SyncSuccess());
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }

  void stopSyncing() {
    _syncTimer?.cancel();
    emit(SyncInitial());
  }
}
