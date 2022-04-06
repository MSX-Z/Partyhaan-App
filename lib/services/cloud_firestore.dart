import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partyhaan_app/constants/firebase_constants.dart';
import 'package:partyhaan_app/models/party_model.dart';

class CloudFireStore {
  static CollectionReference partyRef = firestore.collection('Partys');
  
  static Future<List<QueryDocumentSnapshot<Object?>>>
      onReadDocumentParty() async {
    QuerySnapshot querySnapshot = await partyRef.get().catchError((error){throw Exception(error);});
    return querySnapshot.docs;
  }

  static Future<void> onAddDocumentParty(String doc, Map<String, dynamic> value) async {
    await partyRef.doc(doc).set(value).catchError((error){throw Exception(error);});
  }

  static Future<void> onUpdateParty(String doc, Map<String, dynamic> value) async {
    await partyRef.doc(doc).update(value).catchError((error){print('Error $error');});
  }

  static Future<void> onDeleteParty(String doc) async {
    await partyRef.doc(doc).delete().catchError((error){print('Error $error');});
  }
}
