import '../../../../core/util/typedef.dart';
import '../entities/financial.statement.dart';

abstract class FinancialStatementRepository {
  ResultFuture<void> createFinancialStatement(FinancialStatement statement);
  ResultFuture<List<FinancialStatement>> getAllFinancialStatements();
  ResultFuture<FinancialStatement> getFinancialStatementById(String id);
  ResultFuture<void> updateFinancialStatement(FinancialStatement statement);
  ResultFuture<void> deleteFinancialStatement(String id);
}
