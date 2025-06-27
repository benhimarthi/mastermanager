import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/session/session.manager.dart';
import '../models/payment.model.dart';

abstract class PaymentRemoteDataSource {
  Future<void> createPayment(PaymentModel model);
  Future<List<PaymentModel>> getAllPayments();
  Future<PaymentModel> getPaymentById(String id);
  Future<void> updatePayment(PaymentModel model);
  Future<void> deletePayment(String id);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'payments';

  PaymentRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createPayment(PaymentModel model) async {
    final uid = SessionManager.getUserSession()!.id;
    final data = model.toMap()..addAll({'creatorId': uid});
    await _firestore.collection(_collection).doc(model.id).set(data);
  }

  @override
  Future<List<PaymentModel>> getAllPayments() async {
    final uid = SessionManager.getUserSession()!.id;
    final snapshot = await _firestore
        .collection(_collection)
        .where('creatorId', isEqualTo: uid)
        .get();

    return snapshot.docs
        .map((doc) => PaymentModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<PaymentModel> getPaymentById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists) throw Exception('Payment not found');
    return PaymentModel.fromMap(doc.data()!);
  }

  @override
  Future<void> updatePayment(PaymentModel model) async {
    final data = model.toMap();
    await _firestore.collection(_collection).doc(model.id).update(data);
  }

  @override
  Future<void> deletePayment(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
