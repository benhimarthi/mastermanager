import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../repositories/financial.entry.repository.dart';

class DeleteFinancialEntry implements UsecaseWithParams<void, String> {
  final FinancialEntryRepository _repo;

  DeleteFinancialEntry(this._repo);

  @override
  ResultFuture<void> call(String id) {
    return _repo.deleteFinancialEntry(id);
  }
}
