import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:partyhaan_app/constants/firebase_constants.dart';
import 'package:partyhaan_app/models/party_model.dart';
import 'package:partyhaan_app/services/cloud_firestore.dart';
import 'package:partyhaan_app/services/firebase_storage.dart';

class PartyController extends GetxController {
  static PartyController instance = Get.find();

  bool _isLoading = true;
  List<Party> _partys = [];

  bool get isLoading => _isLoading;
  List<Party> get partys => _partys;

  Future<void> onReadParty() async {
    _isLoading = true;

    List<QueryDocumentSnapshot<Object?>> querySnapshotList =
        await CloudFireStore.onReadDocumentParty();
    List<Party> partys = querySnapshotList
        .map((QueryDocumentSnapshot<Object?> snapshot) =>
            Party.fromJson(snapshot.data() as Map<String, dynamic>))
        .toList();

    print('data ${partys.toString()}');

    _partys = partys;
    _isLoading = false;
    update();
  }

  Future<void> onAddParty(String title, String description, int maximum, File? file) async {
    String? uid = auth.currentUser?.uid;
    String key = DateTime.now().microsecondsSinceEpoch.toString();
    String? image = "";
    if(file != null){
      image = await CloudStorage.uploadImage(file, key);
    }

    Party party = Party(
      partyID: key,
      creator: uid,
      image: image,
      title: title,
      description: description,
      maximum: maximum,
      participantList: [uid!],
    );

    await CloudFireStore.onAddDocumentParty(key, party.toJson());

    List<Party> result = [...partys];
    result.add(party);
    _partys = result;

    update();
  }

  Future<void> onJoinParty(Party party, String uid) async {
    print('length ${party.participantList?.length}');
    if ((party.participantList!.length + 1) > party.maximum!) {
      Get.snackbar(
        "เกิดข้อผิดพลาดในการเข้าร่วม",
        "จำนวนคนเต็มแล้ว",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Party temp = party.copyWith();
    temp.participantList?.add(uid);

    await CloudFireStore.onUpdateParty(party.partyID!, temp.toJson());

    _partys =
        _partys.map((e) => (e.partyID == party.partyID) ? temp : e).toList();

    print('update ${_partys.toString()} id: ${party.partyID}');

    update();
  }

  Future<void> onLeaveParty(Party party, String uid) async {
    Party temp = party.copyWith();
    temp.participantList?.remove(uid);

    await CloudFireStore.onUpdateParty(party.partyID!, temp.toJson());

    _partys =
        _partys.map((e) => (e.partyID == party.partyID) ? temp : e).toList();

    print('update ${_partys.toString()} id: ${party.partyID}');

    update();
  }

  Future<void> onDeleteParty(String partyID, String image) async {
    if(image.isNotEmpty){
      String? result = await CloudStorage.removeImage(image);
      if(result != "delete success"){
        return;
      }
    }
    await CloudFireStore.onDeleteParty(partyID);

    _partys = _partys.where((e) => e.partyID != partyID).toList();

    print('delete ${_partys.toString()} id: ${partyID}');

    update();
  }

  @override
  void onReady() async {
    super.onReady();
    await onReadParty();
  }
}
