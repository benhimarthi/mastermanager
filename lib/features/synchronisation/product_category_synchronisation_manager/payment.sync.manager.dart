import '../../payment/data/data_source/payment.local.data.source.dart';
import '../../payment/data/data_source/payment.remote.data.source.dart';

abstract class PaymentSyncManager {
  Future<void> pushLocalChanges();
  Future<void> pullRemoteData();
  Future<void> refreshFromRemote();
}

class PaymentSyncManagerImpl implements PaymentSyncManager {
  final PaymentLocalDataSource _local;
  final PaymentRemoteDataSource _remote;

  PaymentSyncManagerImpl(this._local, this._remote);

  @override
  Future<void> pushLocalChanges() async {
    final created = _local.getPendingCreates();
    final updated = _local.getPendingUpdates();
    final deleted = _local.getPendingDeletions();

    for (final payment in created) {
      await _remote.createPayment(payment);
    }
    for (final payment in updated) {
      await _remote.updatePayment(payment);
    }
    for (final id in deleted) {
      await _remote.deletePayment(id);
    }

    await _local.clearAll();
    for (final item in _local.getAllLocalPayments()) {
      await _local.applyCreate(item);
    }
  }

  @override
  Future<void> pullRemoteData() async {
    final remoteList = await _remote.getAllPayments();
    await _local.clearAll();
    for (final payment in remoteList) {
      await _local.applyCreate(payment);
    }
  }

  @override
  Future<void> refreshFromRemote() async {
    await pullRemoteData();
  }
}
