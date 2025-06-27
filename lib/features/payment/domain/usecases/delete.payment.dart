import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../repositories/payment.repository.dart';

class DeletePayment implements UsecaseWithParams<void, String> {
  final PaymentRepository _repo;

  DeletePayment(this._repo);

  @override
  ResultFuture<void> call(String id) => _repo.deletePayment(id);
}
