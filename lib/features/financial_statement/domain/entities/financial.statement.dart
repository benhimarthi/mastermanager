import 'package:equatable/equatable.dart';

class FinancialStatement extends Equatable {
  final String id;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String notes;

  const FinancialStatement({
    required this.id,
    required this.periodStart,
    required this.periodEnd,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        periodStart,
        periodEnd,
        createdAt,
        updatedAt,
        createdBy,
        notes,
      ];
}
