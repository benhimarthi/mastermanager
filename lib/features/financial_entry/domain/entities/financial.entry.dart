import 'package:equatable/equatable.dart';

class FinancialEntry extends Equatable {
  final String id;
  final String statementId; // FK to FinancialStatement
  final String
      category; // e.g., "Sales", "Salaries", "Office Supplies", "Bank Loan"
  final String type; // "income", "expense", "asset", "liability", "equity"
  final double amount;
  final String notes;

  const FinancialEntry({
    required this.id,
    required this.statementId,
    required this.category,
    required this.type,
    required this.amount,
    required this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        statementId,
        category,
        type,
        amount,
        notes,
      ];
}
