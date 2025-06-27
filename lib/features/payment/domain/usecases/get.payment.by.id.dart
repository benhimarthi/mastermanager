import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/payment.dart';
import '../repositories/payment.repository.dart';

class GetPaymentById implements UsecaseWithParams<Payment, String> {
  final PaymentRepository _repo;

  GetPaymentById(this._repo);

  @override
  ResultFuture<Payment> call(String id) => _repo.getPaymentById(id);
}
