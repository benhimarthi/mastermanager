import '../../../../core/util/typedef.dart';
import '../entities/financial.entry.dart';

abstract class FinancialEntryRepository {
  ResultFuture<void> createFinancialEntry(FinancialEntry entry);
  ResultFuture<List<FinancialEntry>> getAllFinancialEntries();
  ResultFuture<FinancialEntry> getFinancialEntryById(String id);
  ResultFuture<void> updateFinancialEntry(FinancialEntry entry);
  ResultFuture<void> deleteFinancialEntry(String id);
}
