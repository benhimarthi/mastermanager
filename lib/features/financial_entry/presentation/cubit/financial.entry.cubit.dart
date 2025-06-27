import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../synchronisation/cubit/financial_entry_sync_trigger_cubit/financial.entry.sync.trigger.cubit.dart';
import '../../domain/entities/financial.entry.dart';
import '../../domain/usecases/create.financial.entry.dart';
import '../../domain/usecases/delete.financial.entry.dart';
import '../../domain/usecases/get.all.financial.entries.dart';
import '../../domain/usecases/update.financial.entry.dart';
import 'financial.entry.state.dart';

class FinancialEntryCubit extends Cubit<FinancialEntryState> {
  final GetAllFinancialEntries _getAll;
  final CreateFinancialEntry _create;
  final UpdateFinancialEntry _update;
  final DeleteFinancialEntry _delete;
  final FinancialEntrySyncTriggerCubit _syncCubit;
  final Connectivity _connectivity;

  FinancialEntryCubit({
    required GetAllFinancialEntries getAll,
    required CreateFinancialEntry create,
    required UpdateFinancialEntry update,
    required DeleteFinancialEntry delete,
    required FinancialEntrySyncTriggerCubit syncCubit,
    required Connectivity connectivity,
  })  : _getAll = getAll,
        _create = create,
        _update = update,
        _delete = delete,
        _syncCubit = syncCubit,
        _connectivity = connectivity,
        super(FinancialEntryManagerInitial());

  Future<void> _tryAutoSync() async {
    final conn = await _connectivity.checkConnectivity();
    if (conn != ConnectivityResult.none) {
      await _syncCubit.triggerManualSync();
    }
  }

  Future<void> loadFinancialEntries() async {
    emit(FinancialEntryManagerLoading());
    final result = await _getAll();
    result.fold(
      (failure) => emit(FinancialEntryManagerError(failure.message)),
      (list) => emit(FinancialEntryManagerLoaded(list)),
    );
  }

  Future<void> addFinancialEntry(FinancialEntry entry) async {
    final result = await _create(entry);
    result.fold(
      (failure) => emit(FinancialEntryManagerError(failure.message)),
      (_) async {
        await loadFinancialEntries();
        await _tryAutoSync();
      },
    );
  }

  Future<void> updateFinancialEntry(FinancialEntry entry) async {
    final result = await _update(entry);
    result.fold(
      (failure) => emit(FinancialEntryManagerError(failure.message)),
      (_) async {
        await loadFinancialEntries();
        await _tryAutoSync();
      },
    );
  }

  Future<void> deleteFinancialEntry(String id) async {
    final result = await _delete(id);
    result.fold(
      (failure) => emit(FinancialEntryManagerError(failure.message)),
      (_) async {
        await loadFinancialEntries();
        await _tryAutoSync();
      },
    );
  }
}
