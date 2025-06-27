import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/util/typedef.dart';
import '../../domain/entities/financial.statement.dart';
import '../../domain/repositories/financial.statement.repository.dart';
import '../data_source/financial.statement.local.data.source.dart';
import '../models/financial.statement.model.dart';

class FinancialStatementRepositoryImpl implements FinancialStatementRepository {
  final FinancialStatementLocalDataSource _local;

  FinancialStatementRepositoryImpl(
      {required FinancialStatementLocalDataSource local})
      : _local = local;

  @override
  ResultFuture<void> createFinancialStatement(
      FinancialStatement statement) async {
    try {
      final model = FinancialStatementModel.fromEntity(statement);
      await _local.addCreatedFinancialStatement(model);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<List<FinancialStatement>> getAllFinancialStatements() async {
    try {
      final models = _local.getAllLocalFinancialStatements();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(LocalFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<FinancialStatement> getFinancialStatementById(String id) async {
    try {
      final list = _local.getAllLocalFinancialStatements();
      final found = list.firstWhere((e) => e.id == id);
      return Right(found.toEntity());
    } catch (e) {
      return const Left(LocalFailure(
          message: 'FinancialStatement not found', statusCode: 500));
    }
  }

  @override
  ResultFuture<void> updateFinancialStatement(
      FinancialStatement statement) async {
    try {
      final model = FinancialStatementModel.fromEntity(statement);
      await _local.addUpdatedFinancialStatement(model);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<void> deleteFinancialStatement(String id) async {
    try {
      await _local.addDeletedFinancialStatementId(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString(), statusCode: 500));
    }
  }
}
