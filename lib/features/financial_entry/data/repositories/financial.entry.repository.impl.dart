import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/util/typedef.dart';
import '../../domain/entities/financial.entry.dart';
import '../../domain/repositories/financial.entry.repository.dart';
import '../data_sources/financial.entry.local.data.source.dart';
import '../models/financial.entry.model.dart';

class FinancialEntryRepositoryImpl implements FinancialEntryRepository {
  final FinancialEntryLocalDataSource _local;

  FinancialEntryRepositoryImpl({required FinancialEntryLocalDataSource local})
      : _local = local;

  @override
  ResultFuture<void> createFinancialEntry(FinancialEntry entry) async {
    try {
      final model = FinancialEntryModel.fromEntity(entry);
      await _local.addCreatedFinancialEntry(model);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<List<FinancialEntry>> getAllFinancialEntries() async {
    try {
      final models = _local.getAllLocalFinancialEntries();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(LocalFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<FinancialEntry> getFinancialEntryById(String id) async {
    try {
      final list = _local.getAllLocalFinancialEntries();
      final found = list.firstWhere((e) => e.id == id);
      return Right(found.toEntity());
    } catch (e) {
      return const Left(
          LocalFailure(message: 'FinancialEntry not found', statusCode: 500));
    }
  }

  @override
  ResultFuture<void> updateFinancialEntry(FinancialEntry entry) async {
    try {
      final model = FinancialEntryModel.fromEntity(entry);
      await _local.addUpdatedFinancialEntry(model);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<void> deleteFinancialEntry(String id) async {
    try {
      await _local.addDeletedFinancialEntryId(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString(), statusCode: 500));
    }
  }
}
