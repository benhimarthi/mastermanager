import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String saleId;
  final double amountPaid;
  final String method; // e.g., "credit_card", "paypal"
  final DateTime paidAt;
  final String transactionId; // From payment gateway
  final bool isRefunded;

  const Payment({
    required this.id,
    required this.saleId,
    required this.amountPaid,
    required this.method,
    required this.paidAt,
    required this.transactionId,
    required this.isRefunded,
  });

  @override
  List<Object?> get props => [
        id,
        saleId,
        amountPaid,
        method,
        paidAt,
        transactionId,
        isRefunded,
      ];
}
