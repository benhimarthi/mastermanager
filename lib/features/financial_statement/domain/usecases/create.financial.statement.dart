import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/financial.statement.dart';
import '../repositories/financial.statement.repository.dart';

class CreateFinancialStatement
    implements UsecaseWithParams<void, FinancialStatement> {
  final FinancialStatementRepository _repo;

  CreateFinancialStatement(this._repo);

  @override
  ResultFuture<void> call(FinancialStatement params) {
    return _repo.createFinancialStatement(params);
  }
}
