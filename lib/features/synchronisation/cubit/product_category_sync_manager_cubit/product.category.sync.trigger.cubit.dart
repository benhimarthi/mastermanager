import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../synchronisation_manager/product.category.sync.manager.dart';
import '../authentication_synch_manager_cubit/sync.trigger.state.dart';

class ProductCategorySyncTriggerCubit extends Cubit<SyncTriggerState> {
  final ProductCategorySyncManager _syncManager;
  Timer? _syncTimer;

  ProductCategorySyncTriggerCubit(this._syncManager) : super(SyncInitial());

  void startSyncing() {
    _syncTimer?.cancel(); // avoid duplicates
    _syncTimer =
        Timer.periodic(const Duration(minutes: 10), (_) => _triggerSync());
    _triggerSync(); // immediate first run
  }

  Future<void> _triggerSync() async {
    emit(SyncInProgress());
    final result = await _syncManager.syncPendingChanges();
    result.fold(
      (failure) => emit(SyncFailure(failure.message)),
      (_) => emit(SyncSuccess()),
    );
  }

  void stopSyncing() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  @override
  Future<void> close() {
    stopSyncing();
    return super.close();
  }
}
