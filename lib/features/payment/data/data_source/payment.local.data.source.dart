import 'package:hive/hive.dart';

import '../models/payment.model.dart';

abstract class PaymentLocalDataSource {
  Future<void> addCreatedPayment(PaymentModel model);
  Future<void> addUpdatedPayment(PaymentModel model);
  Future<void> addDeletedPaymentId(String id);

  Future<void> applyCreate(PaymentModel model);
  Future<void> applyUpdate(PaymentModel model);
  Future<void> applyDelete(String id);

  List<PaymentModel> getAllLocalPayments();

  List<PaymentModel> getPendingCreates();
  List<PaymentModel> getPendingUpdates();
  List<String> getPendingDeletions();

  Future<void> clearAll();
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  final Box _mainBox;
  final Box _createdBox;
  final Box _updatedBox;
  final Box<String> _deletedBox;

  PaymentLocalDataSourceImpl({
    required Box mainBox,
    required Box createdBox,
    required Box updatedBox,
    required Box<String> deletedBox,
  })  : _mainBox = mainBox,
        _createdBox = createdBox,
        _updatedBox = updatedBox,
        _deletedBox = deletedBox;

  @override
  Future<void> addCreatedPayment(PaymentModel model) async {
    await _mainBox.put(model.id, model.toMap());
    await _createdBox.put(model.id, model.toMap());
  }

  @override
  Future<void> addUpdatedPayment(PaymentModel model) async {
    await _mainBox.put(model.id, model.toMap());
    await _updatedBox.put(model.id, model.toMap());
  }

  @override
  Future<void> addDeletedPaymentId(String id) async {
    await _mainBox.delete(id);
    await _deletedBox.put(id, id);
  }

  @override
  Future<void> applyCreate(PaymentModel model) async {
    await _mainBox.put(model.id, model.toMap());
  }

  @override
  Future<void> applyUpdate(PaymentModel model) async {
    await _mainBox.put(model.id, model.toMap());
  }

  @override
  Future<void> applyDelete(String id) async {
    await _mainBox.delete(id);
  }

  @override
  List<PaymentModel> getAllLocalPayments() {
    return _mainBox.values
        .map((m) => PaymentModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  List<PaymentModel> getPendingCreates() {
    return _createdBox.values
        .map((m) => PaymentModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  List<PaymentModel> getPendingUpdates() {
    return _updatedBox.values
        .map((m) => PaymentModel.fromMap(Map<String, dynamic>.from(m)))
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
