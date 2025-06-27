import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.saleId,
    required super.amountPaid,
    required super.method,
    required super.paidAt,
    required super.transactionId,
    required super.isRefunded,
  });

  factory PaymentModel.fromEntity(Payment entity) {
    return PaymentModel(
      id: entity.id,
      saleId: entity.saleId,
      amountPaid: entity.amountPaid,
      method: entity.method,
      paidAt: entity.paidAt,
      transactionId: entity.transactionId,
      isRefunded: entity.isRefunded,
    );
  }

  Payment toEntity() {
    return Payment(
      id: id,
      saleId: saleId,
      amountPaid: amountPaid,
      method: method,
      paidAt: paidAt,
      transactionId: transactionId,
      isRefunded: isRefunded,
    );
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] as String,
      saleId: map['saleId'] as String,
      amountPaid: (map['amountPaid'] as num).toDouble(),
      method: map['method'] as String,
      paidAt: DateTime.parse(map['paidAt'] as String),
      transactionId: map['transactionId'] as String,
      isRefunded: map['isRefunded'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'saleId': saleId,
      'amountPaid': amountPaid,
      'method': method,
      'paidAt': paidAt.toIso8601String(),
      'transactionId': transactionId,
      'isRefunded': isRefunded,
    };
  }

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
