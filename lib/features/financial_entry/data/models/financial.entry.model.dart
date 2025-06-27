import '../../domain/entities/financial.entry.dart';

class FinancialEntryModel extends FinancialEntry {
  const FinancialEntryModel({
    required super.id,
    required super.statementId,
    required super.category,
    required super.type,
    required super.amount,
    required super.notes,
  });

  factory FinancialEntryModel.fromEntity(FinancialEntry entity) {
    return FinancialEntryModel(
      id: entity.id,
      statementId: entity.statementId,
      category: entity.category,
      type: entity.type,
      amount: entity.amount,
      notes: entity.notes,
    );
  }

  FinancialEntry toEntity() {
    return FinancialEntry(
      id: id,
      statementId: statementId,
      category: category,
      type: type,
      amount: amount,
      notes: notes,
    );
  }

  factory FinancialEntryModel.fromMap(Map<String, dynamic> map) {
    return FinancialEntryModel(
      id: map['id'] as String,
      statementId: map['statementId'] as String,
      category: map['category'] as String,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      notes: map['notes'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'statementId': statementId,
      'category': category,
      'type': type,
      'amount': amount,
      'notes': notes,
    };
  }

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
