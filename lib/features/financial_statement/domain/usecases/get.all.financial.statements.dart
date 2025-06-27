import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/financial.statement.dart';
import '../repositories/financial.statement.repository.dart';

class GetAllFinancialStatements
    implements UseCaseWithoutParams<List<FinancialStatement>> {
  final FinancialStatementRepository _repo;

  GetAllFinancialStatements(this._repo);

  @override
  ResultFuture<List<FinancialStatement>> call() {
    return _repo.getAllFinancialStatements();
  }
}
