import '../../domain/entities/financial.statement.dart';

class FinancialStatementModel extends FinancialStatement {
  const FinancialStatementModel({
    required super.id,
    required super.periodStart,
    required super.periodEnd,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
    required super.notes,
  });

  factory FinancialStatementModel.fromEntity(FinancialStatement entity) {
    return FinancialStatementModel(
      id: entity.id,
      periodStart: entity.periodStart,
      periodEnd: entity.periodEnd,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
      notes: entity.notes,
    );
  }

  FinancialStatement toEntity() {
    return FinancialStatement(
      id: id,
      periodStart: periodStart,
      periodEnd: periodEnd,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      notes: notes,
    );
  }

  factory FinancialStatementModel.fromMap(Map<String, dynamic> map) {
    return FinancialStatementModel(
      id: map['id'] as String,
      periodStart: DateTime.parse(map['periodStart'] as String),
      periodEnd: DateTime.parse(map['periodEnd'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdBy: map['createdBy'] as String,
      notes: map['notes'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'notes': notes,
    };
  }

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
