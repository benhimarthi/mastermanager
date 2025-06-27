import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/financial.entry.dart';
import '../repositories/financial.entry.repository.dart';

class CreateFinancialEntry implements UsecaseWithParams<void, FinancialEntry> {
  final FinancialEntryRepository _repo;

  CreateFinancialEntry(this._repo);

  @override
  ResultFuture<void> call(FinancialEntry params) {
    return _repo.createFinancialEntry(params);
  }
}
