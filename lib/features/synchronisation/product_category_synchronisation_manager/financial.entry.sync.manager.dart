import '../../financial_entry/data/data_sources/financial.entry.local.data.source.dart';
import '../../financial_entry/data/data_sources/financial.entry.remote.data.source.dart';

abstract class FinancialEntrySyncManager {
  Future<void> pushLocalChanges();
  Future<void> pullRemoteData();
  Future<void> refreshFromRemote();
}

class FinancialEntrySyncManagerImpl implements FinancialEntrySyncManager {
  final FinancialEntryLocalDataSource _local;
  final FinancialEntryRemoteDataSource _remote;

  FinancialEntrySyncManagerImpl(this._local, this._remote);

  @override
  Future<void> pushLocalChanges() async {
    final created = _local.getPendingCreates();
    final updated = _local.getPendingUpdates();
    final deleted = _local.getPendingDeletions();

    for (final entry in created) {
      await _remote.createFinancialEntry(entry);
    }
    for (final entry in updated) {
      await _remote.updateFinancialEntry(entry);
    }
    for (final id in deleted) {
      await _remote.deleteFinancialEntry(id);
    }

    await _local.clearAll();
    for (final item in _local.getAllLocalFinancialEntries()) {
      await _local.applyCreate(item);
    }
  }

  @override
  Future<void> pullRemoteData() async {
    final remoteList = await _remote.getAllFinancialEntries();
    await _local.clearAll();
    for (final entry in remoteList) {
      await _local.applyCreate(entry);
    }
  }

  @override
  Future<void> refreshFromRemote() async {
    await pullRemoteData();
  }
}
