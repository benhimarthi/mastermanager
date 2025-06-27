import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/payment.dart';
import '../repositories/payment.repository.dart';

class CreatePayment implements UsecaseWithParams<void, Payment> {
  final PaymentRepository _repo;

  CreatePayment(this._repo);

  @override
  ResultFuture<void> call(Payment params) {
    return _repo.createPayment(params);
  }
}
