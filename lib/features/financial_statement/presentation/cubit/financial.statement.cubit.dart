import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../synchronisation/cubit/financial_statement_sync_trigger_cubit/financial.statement.sync.trigger.cubit.dart';
import '../../domain/entities/financial.statement.dart';
import '../../domain/usecases/create.financial.statement.dart';
import '../../domain/usecases/delete.financial.statement.dart';
import '../../domain/usecases/get.all.financial.statements.dart';
import '../../domain/usecases/update.financial.statement.dart';
import 'financial.statement.state.dart';

class FinancialStatementCubit extends Cubit<FinancialStatementState> {
  final GetAllFinancialStatements _getAll;
  final CreateFinancialStatement _create;
  final UpdateFinancialStatement _update;
  final DeleteFinancialStatement _delete;
  final FinancialStatementSyncTriggerCubit _syncCubit;
  final Connectivity _connectivity;

  FinancialStatementCubit({
    required GetAllFinancialStatements getAll,
    required CreateFinancialStatement create,
    required UpdateFinancialStatement update,
    required DeleteFinancialStatement delete,
    required FinancialStatementSyncTriggerCubit syncCubit,
    required Connectivity connectivity,
  })  : _getAll = getAll,
        _create = create,
        _update = update,
        _delete = delete,
        _syncCubit = syncCubit,
        _connectivity = connectivity,
        super(FinancialStatementManagerInitial());

  Future<void> _tryAutoSync() async {
    final conn = await _connectivity.checkConnectivity();
    if (conn != ConnectivityResult.none) {
      await _syncCubit.triggerManualSync();
    }
  }

  Future<void> loadFinancialStatements() async {
    emit(FinancialStatementManagerLoading());
    final result = await _getAll();
    result.fold(
      (failure) => emit(FinancialStatementManagerError(failure.message)),
      (list) => emit(FinancialStatementManagerLoaded(list)),
    );
  }

  Future<void> addFinancialStatement(FinancialStatement statement) async {
    final result = await _create(statement);
    result.fold(
      (failure) => emit(FinancialStatementManagerError(failure.message)),
      (_) async {
        await loadFinancialStatements();
        await _tryAutoSync();
      },
    );
  }

  Future<void> updateFinancialStatement(FinancialStatement statement) async {
    final result = await _update(statement);
    result.fold(
      (failure) => emit(FinancialStatementManagerError(failure.message)),
      (_) async {
        await loadFinancialStatements();
        await _tryAutoSync();
      },
    );
  }

  Future<void> deleteFinancialStatement(String id) async {
    final result = await _delete(id);
    result.fold(
      (failure) => emit(FinancialStatementManagerError(failure.message)),
      (_) async {
        await loadFinancialStatements();
        await _tryAutoSync();
      },
    );
  }
}
