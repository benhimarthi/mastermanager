import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/payment.dart';
import '../repositories/payment.repository.dart';

class UpdatePayment implements UsecaseWithParams<void, Payment> {
  final PaymentRepository _repo;

  UpdatePayment(this._repo);

  @override
  ResultFuture<void> call(Payment params) => _repo.updatePayment(params);
}
