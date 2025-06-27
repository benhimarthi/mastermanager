import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/financial.entry.dart';
import '../repositories/financial.entry.repository.dart';

class UpdateFinancialEntry implements UsecaseWithParams<void, FinancialEntry> {
  final FinancialEntryRepository _repo;

  UpdateFinancialEntry(this._repo);

  @override
  ResultFuture<void> call(FinancialEntry params) {
    return _repo.updateFinancialEntry(params);
  }
}
