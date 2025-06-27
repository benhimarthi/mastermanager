import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../repositories/financial.statement.repository.dart';

class DeleteFinancialStatement implements UsecaseWithParams<void, String> {
  final FinancialStatementRepository _repo;

  DeleteFinancialStatement(this._repo);

  @override
  ResultFuture<void> call(String id) {
    return _repo.deleteFinancialStatement(id);
  }
}
