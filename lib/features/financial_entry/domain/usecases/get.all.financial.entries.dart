import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/financial.entry.dart';
import '../repositories/financial.entry.repository.dart';

class GetAllFinancialEntries
    implements UseCaseWithoutParams<List<FinancialEntry>> {
  final FinancialEntryRepository _repo;

  GetAllFinancialEntries(this._repo);

  @override
  ResultFuture<List<FinancialEntry>> call() {
    return _repo.getAllFinancialEntries();
  }
}
