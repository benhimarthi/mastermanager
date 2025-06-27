import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/session/session.manager.dart';
import '../models/financial.statement.model.dart';

abstract class FinancialStatementRemoteDataSource {
  Future<void> createFinancialStatement(FinancialStatementModel model);
  Future<List<FinancialStatementModel>> getAllFinancialStatements();
  Future<FinancialStatementModel> getFinancialStatementById(String id);
  Future<void> updateFinancialStatement(FinancialStatementModel model);
  Future<void> deleteFinancialStatement(String id);
}

class FinancialStatementRemoteDataSourceImpl
    implements FinancialStatementRemoteDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'financial_statements';

  FinancialStatementRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createFinancialStatement(FinancialStatementModel model) async {
    final uid = SessionManager.getUserSession()!.id;
    final data = model.toMap()..addAll({'creatorId': uid});
    await _firestore.collection(_collection).doc(model.id).set(data);
  }

  @override
  Future<List<FinancialStatementModel>> getAllFinancialStatements() async {
    final uid = SessionManager.getUserSession()!.id;
    final snapshot = await _firestore
        .collection(_collection)
        .where('creatorId', isEqualTo: uid)
        .get();

    return snapshot.docs
        .map((doc) => FinancialStatementModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<FinancialStatementModel> getFinancialStatementById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists) throw Exception('FinancialStatement not found');
    return FinancialStatementModel.fromMap(doc.data()!);
  }

  @override
  Future<void> updateFinancialStatement(FinancialStatementModel model) async {
    final data = model.toMap();
    await _firestore.collection(_collection).doc(model.id).update(data);
  }

  @override
  Future<void> deleteFinancialStatement(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
