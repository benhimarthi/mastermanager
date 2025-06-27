import 'package:bloc/bloc.dart';

import '../../product_category_synchronisation_manager/financial.statement.sync.manager.dart';
import '../product_pricing_sync_manager_cubit/product.pricing.sync.trigger.state.dart';

class FinancialStatementSyncTriggerCubit
    extends Cubit<ProductPricingSyncTriggerState> {
  final FinancialStatementSyncManager _sync;

  FinancialStatementSyncTriggerCubit(this._sync) : super(SyncIdle());

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
