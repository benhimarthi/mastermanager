import 'package:hive/hive.dart';

import '../models/financial.entry.model.dart';

abstract class FinancialEntryLocalDataSource {
  Future<void> addCreatedFinancialEntry(FinancialEntryModel model);
  Future<void> addUpdatedFinancialEntry(FinancialEntryModel model);
  Future<void> addDeletedFinancialEntryId(String id);

  Future<void> applyCreate(FinancialEntryModel model);
  Future<void> applyUpdate(FinancialEntryModel model);
  Future<void> applyDelete(String id);

  List<FinancialEntryModel> getAllLocalFinancialEntries();

  List<FinancialEntryModel> getPendingCreates();
  List<FinancialEntryModel> getPendingUpdates();
  List<String> getPendingDeletions();

  Future<void> clearAll();
}

class FinancialEntryLocalDataSourceImpl
    implements FinancialEntryLocalDataSource {
  final Box _mainBox;
  final Box _createdBox;
  final Box _updatedBox;
  final Box<String> _deletedBox;

  FinancialEntryLocalDataSourceImpl({
    required Box mainBox,
    required Box createdBox,
    required Box updatedBox,
    required Box<String> deletedBox,
  })  : _mainBox = mainBox,
        _createdBox = createdBox,
        _updatedBox = updatedBox,
        _deletedBox = deletedBox;

  @override
  Future<void> addCreatedFinancialEntry(FinancialEntryModel model) async {
    await _mainBox.put(model.id, model.toMap());
    await _createdBox.put(model.id, model.toMap());
  }

  @override
  Future<void> addUpdatedFinancialEntry(FinancialEntryModel model) async {
    await _mainBox.put(model.id, model.toMap());
    await _updatedBox.put(model.id, model.toMap());
  }

  @override
  Future<void> addDeletedFinancialEntryId(String id) async {
    await _mainBox.delete(id);
    await _deletedBox.put(id, id);
  }

  @override
  Future<void> applyCreate(FinancialEntryModel model) async {
    await _mainBox.put(model.id, model.toMap());
  }

  @override
  Future<void> applyUpdate(FinancialEntryModel model) async {
    await _mainBox.put(model.id, model.toMap());
  }

  @override
  Future<void> applyDelete(String id) async {
    await _mainBox.delete(id);
  }

  @override
  List<FinancialEntryModel> getAllLocalFinancialEntries() {
    return _mainBox.values
        .map((m) => FinancialEntryModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  List<FinancialEntryModel> getPendingCreates() {
    return _createdBox.values
        .map((m) => FinancialEntryModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  List<FinancialEntryModel> getPendingUpdates() {
    return _updatedBox.values
        .map((m) => FinancialEntryModel.fromMap(Map<String, dynamic>.from(m)))
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
