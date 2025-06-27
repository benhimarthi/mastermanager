import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mastermanager/features/payment/presentation/cubit/payment.state.dart';
import '../../../synchronisation/cubit/payment_sync_trigger_cubit/payment.sync.trigger.cubit.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/create.payment.dart';
import '../../domain/usecases/delete.payment.dart';
import '../../domain/usecases/get.all.payments.dart';
import '../../domain/usecases/update.payment.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final GetAllPayments _getAll;
  final CreatePayment _create;
  final UpdatePayment _update;
  final DeletePayment _delete;
  final PaymentSyncTriggerCubit _syncCubit;
  final Connectivity _connectivity;

  PaymentCubit({
    required GetAllPayments getAll,
    required CreatePayment create,
    required UpdatePayment update,
    required DeletePayment delete,
    required PaymentSyncTriggerCubit syncCubit,
    required Connectivity connectivity,
  })  : _getAll = getAll,
        _create = create,
        _update = update,
        _delete = delete,
        _syncCubit = syncCubit,
        _connectivity = connectivity,
        super(PaymentManagerInitial());

  Future<void> _tryAutoSync() async {
    final conn = await _connectivity.checkConnectivity();
    if (conn != ConnectivityResult.none) {
      await _syncCubit.triggerManualSync();
    }
  }

  Future<void> loadPayments() async {
    emit(PaymentManagerLoading());
    final result = await _getAll();
    result.fold(
      (failure) => emit(PaymentManagerError(failure.message)),
      (list) => emit(PaymentManagerLoaded(list)),
    );
  }

  Future<void> addPayment(Payment payment) async {
    final result = await _create(payment);
    result.fold(
      (failure) => emit(PaymentManagerError(failure.message)),
      (_) async {
        await loadPayments();
        await _tryAutoSync();
      },
    );
  }

  Future<void> updatePayment(Payment payment) async {
    final result = await _update(payment);
    result.fold(
      (failure) => emit(PaymentManagerError(failure.message)),
      (_) async {
        await loadPayments();
        await _tryAutoSync();
      },
    );
  }

  Future<void> deletePayment(String id) async {
    final result = await _delete(id);
    result.fold(
      (failure) => emit(PaymentManagerError(failure.message)),
      (_) async {
        await loadPayments();
        await _tryAutoSync();
      },
    );
  }
}
