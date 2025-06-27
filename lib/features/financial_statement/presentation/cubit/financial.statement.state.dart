import 'package:equatable/equatable.dart';

import '../../domain/entities/financial.statement.dart';

abstract class FinancialStatementState extends Equatable {
  const FinancialStatementState();

  @override
  List<Object> get props => [];
}

class FinancialStatementManagerInitial extends FinancialStatementState {}

class FinancialStatementManagerLoading extends FinancialStatementState {}

class FinancialStatementManagerLoaded extends FinancialStatementState {
  final List<FinancialStatement> statementList;

  const FinancialStatementManagerLoaded(this.statementList);

  @override
  List<Object> get props => [statementList];
}

class FinancialStatementManagerError extends FinancialStatementState {
  final String message;

  const FinancialStatementManagerError(this.message);

  @override
  List<Object> get props => [message];
}
