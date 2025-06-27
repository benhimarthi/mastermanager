import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/financial.entry.dart';
import '../repositories/financial.entry.repository.dart';

class GetFinancialEntryById
    implements UsecaseWithParams<FinancialEntry, String> {
  final FinancialEntryRepository _repo;

  GetFinancialEntryById(this._repo);

  @override
  ResultFuture<FinancialEntry> call(String id) {
    return _repo.getFinancialEntryById(id);
  }
}
