import 'package:equatable/equatable.dart';
import '../../domain/entities/financial.entry.dart';

abstract class FinancialEntryState extends Equatable {
  const FinancialEntryState();

  @override
  List<Object> get props => [];
}

class FinancialEntryManagerInitial extends FinancialEntryState {}

class FinancialEntryManagerLoading extends FinancialEntryState {}

class FinancialEntryManagerLoaded extends FinancialEntryState {
  final List<FinancialEntry> entryList;

  const FinancialEntryManagerLoaded(this.entryList);

  @override
  List<Object> get props => [entryList];
}

class FinancialEntryManagerError extends FinancialEntryState {
  final String message;

  const FinancialEntryManagerError(this.message);

  @override
  List<Object> get props => [message];
}
