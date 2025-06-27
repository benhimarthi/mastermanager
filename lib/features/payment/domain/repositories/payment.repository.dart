import '../../../../core/util/typedef.dart';
import '../entities/payment.dart';

abstract class PaymentRepository {
  ResultFuture<void> createPayment(Payment payment);
  ResultFuture<List<Payment>> getAllPayments();
  ResultFuture<Payment> getPaymentById(String id);
  ResultFuture<void> updatePayment(Payment payment);
  ResultFuture<void> deletePayment(String id);
}
