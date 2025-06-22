import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastermanager/features/synchronisation/cubit/product_pricing_sync_manager_cubit/product.pricing.sync.trigger.state.dart';
import '../../product_category_synchronisation_manager/product.pricing.sync.manager.dart';

class ProductPricingSyncTriggerCubit
    extends Cubit<ProductPricingSyncTriggerState> {
  final ProductPricingSyncManager _sync;

  ProductPricingSyncTriggerCubit(this._sync) : super(SyncIdle());

  Future<void> triggerManualSync() async {
    try {
      emit(SyncInProgress());
      await _sync.pushLocalChanges();
      await _sync.pullRemoteData();
      emit(SyncSuccess());
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }

  Future<void> refreshFromRemote() async {
    try {
      emit(SyncInProgress());
      await _sync.refreshFromRemote();
      emit(SyncSuccess());
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }
}
