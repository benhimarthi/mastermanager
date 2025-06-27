import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/session/session.manager.dart';
import '../models/financial.entry.model.dart';

abstract class FinancialEntryRemoteDataSource {
  Future<void> createFinancialEntry(FinancialEntryModel model);
  Future<List<FinancialEntryModel>> getAllFinancialEntries();
  Future<FinancialEntryModel> getFinancialEntryById(String id);
  Future<void> updateFinancialEntry(FinancialEntryModel model);
  Future<void> deleteFinancialEntry(String id);
}

class FinancialEntryRemoteDataSourceImpl
    implements FinancialEntryRemoteDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'financial_entries';

  FinancialEntryRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createFinancialEntry(FinancialEntryModel model) async {
    final uid = SessionManager.getUserSession()!.id;
    final data = model.toMap()..addAll({'creatorId': uid});
    await _firestore.collection(_collection).doc(model.id).set(data);
  }

  @override
  Future<List<FinancialEntryModel>> getAllFinancialEntries() async {
    final uid = SessionManager.getUserSession()!.id;
    final snapshot = await _firestore
        .collection(_collection)
        .where('creatorId', isEqualTo: uid)
        .get();

    return snapshot.docs
        .map((doc) => FinancialEntryModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<FinancialEntryModel> getFinancialEntryById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists) throw Exception('FinancialEntry not found');
    return FinancialEntryModel.fromMap(doc.data()!);
  }

  @override
  Future<void> updateFinancialEntry(FinancialEntryModel model) async {
    final data = model.toMap();
    await _firestore.collection(_collection).doc(model.id).update(data);
  }

  @override
  Future<void> deleteFinancialEntry(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
