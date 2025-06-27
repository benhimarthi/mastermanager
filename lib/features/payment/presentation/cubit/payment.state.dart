import 'package:equatable/equatable.dart';
import '../../domain/entities/payment.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentManagerInitial extends PaymentState {}

class PaymentManagerLoading extends PaymentState {}

class PaymentManagerLoaded extends PaymentState {
  final List<Payment> paymentList;

  const PaymentManagerLoaded(this.paymentList);

  @override
  List<Object> get props => [paymentList];
}

class PaymentManagerError extends PaymentState {
  final String message;

  const PaymentManagerError(this.message);

  @override
  List<Object> get props => [message];
}
