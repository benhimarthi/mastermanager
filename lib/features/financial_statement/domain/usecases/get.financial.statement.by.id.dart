import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/financial.statement.dart';
import '../repositories/financial.statement.repository.dart';

class GetFinancialStatementById
    implements UsecaseWithParams<FinancialStatement, String> {
  final FinancialStatementRepository _repo;

  GetFinancialStatementById(this._repo);

  @override
  ResultFuture<FinancialStatement> call(String id) {
    return _repo.getFinancialStatementById(id);
  }
}
