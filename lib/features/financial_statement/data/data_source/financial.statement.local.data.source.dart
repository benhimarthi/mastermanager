import 'package:hive/hive.dart';

import '../models/financial.statement.model.dart';

abstract class FinancialStatementLocalDataSource {
  Future<void> addCreatedFinancialStatement(FinancialStatementModel model);
  Future<void> addUpdatedFinancialStatement(FinancialStatementModel model);
  Future<void> addDeletedFinancialStatementId(String id);

  Future<void> applyCreate(FinancialStatementModel model);
  Future<void> applyUpdate(FinancialStatementModel model);
  Future<void> applyDelete(String id);

  List<FinancialStatementModel> getAllLocalFinancialStatements();

  List<FinancialStatementModel> getPendingCreates();
  List<FinancialStatementModel> getPendingUpdates();
  List<String> getPendingDeletions();

  Future<void> clearAll();
}

class FinancialStatementLocalDataSourceImpl
    implements FinancialStatementLocalDataSource {
  final Box _mainBox;
  final Box _createdBox;
  final Box _updatedBox;
  final Box<String> _deletedBox;

  FinancialStatementLocalDataSourceImpl({
    required Box mainBox,
    required Box createdBox,
    required Box updatedBox,
    required Box<String> deletedBox,
  })  : _mainBox = mainBox,
        _createdBox = createdBox,
        _updatedBox = updatedBox,
        _deletedBox = deletedBox;

  @override
  Future<void> addCreatedFinancialStatement(
      FinancialStatementModel model) async {
    await _mainBox.put(model.id, model.toMap());
    await _createdBox.put(model.id, model.toMap());
  }

  @override
  Future<void> addUpdatedFinancialStatement(
      FinancialStatementModel model) async {
    await _mainBox.put(model.id, model.toMap());
    await _updatedBox.put(model.id, model.toMap());
  }

  @override
  Future<void> addDeletedFinancialStatementId(String id) async {
    await _mainBox.delete(id);
    await _deletedBox.put(id, id);
  }

  @override
  Future<void> applyCreate(FinancialStatementModel model) async {
    await _mainBox.put(model.id, model.toMap());
  }

  @override
  Future<void> applyUpdate(FinancialStatementModel model) async {
    await _mainBox.put(model.id, model.toMap());
  }

  @override
  Future<void> applyDelete(String id) async {
    await _mainBox.delete(id);
  }

  @override
  List<FinancialStatementModel> getAllLocalFinancialStatements() {
    return _mainBox.values
        .map((m) =>
            FinancialStatementModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  List<FinancialStatementModel> getPendingCreates() {
    return _createdBox.values
        .map((m) =>
            FinancialStatementModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  List<FinancialStatementModel> getPendingUpdates() {
    return _updatedBox.values
        .map((m) =>
            FinancialStatementModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  List<String> getPendingDeletions() {
    return _deletedBox.values.toList();
  }

  @override
  Future<void> clearAll() async {
    await _mainBox.clear();
    await _createdBox.clear();
    await _updatedBox.clear();
    await _deletedBox.clear();
  }
}
