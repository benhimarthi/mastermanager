import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/payment.dart';
import '../repositories/payment.repository.dart';

class GetAllPayments implements UseCaseWithoutParams<List<Payment>> {
  final PaymentRepository _repo;

  GetAllPayments(this._repo);

  @override
  ResultFuture<List<Payment>> call() => _repo.getAllPayments();
}
