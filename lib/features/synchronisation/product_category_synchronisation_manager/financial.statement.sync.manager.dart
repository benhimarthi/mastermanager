import '../../financial_statement/data/data_source/financial.statement.local.data.source.dart';
import '../../financial_statement/data/data_source/financial.statement.remote.data.source.dart';

abstract class FinancialStatementSyncManager {
  Future<void> pushLocalChanges();
  Future<void> pullRemoteData();
  Future<void> refreshFromRemote();
}

class FinancialStatementSyncManagerImpl
    implements FinancialStatementSyncManager {
  final FinancialStatementLocalDataSource _local;
  final FinancialStatementRemoteDataSource _remote;

  FinancialStatementSyncManagerImpl(this._local, this._remote);

  @override
  Future<void> pushLocalChanges() async {
    final created = _local.getPendingCreates();
    final updated = _local.getPendingUpdates();
    final deleted = _local.getPendingDeletions();

    for (final statement in created) {
      await _remote.createFinancialStatement(statement);
    }
    for (final statement in updated) {
      await _remote.updateFinancialStatement(statement);
    }
    for (final id in deleted) {
      await _remote.deleteFinancialStatement(id);
    }

    await _local.clearAll();
    for (final item in _local.getAllLocalFinancialStatements()) {
      await _local.applyCreate(item);
    }
  }

  @override
  Future<void> pullRemoteData() async {
    final remoteList = await _remote.getAllFinancialStatements();
    await _local.clearAll();
    for (final statement in remoteList) {
      await _local.applyCreate(statement);
    }
  }

  @override
  Future<void> refreshFromRemote() async {
    await pullRemoteData();
  }
}
