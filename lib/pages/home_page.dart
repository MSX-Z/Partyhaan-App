import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partyhaan_app/components/card_item.dart';
import 'package:partyhaan_app/components/navbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:partyhaan_app/constants/firebase_constants.dart';
import 'package:partyhaan_app/controllers/party_controller.dart';
import 'package:partyhaan_app/models/party_model.dart';
import 'package:partyhaan_app/pages/party_page.dart';
import 'package:partyhaan_app/services/cloud_firestore.dart';
import 'package:partyhaan_app/services/firebase_storage.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final PartyController controller = Get.put(PartyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        title: const Text("หน้าหลัก"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          controller.onReadParty();
          print('refreshing');
        },
        child: const _HomeBody(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Get.to(() => PartyPage(), transition: Transition.leftToRight);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: GetBuilder<PartyController>(
        builder: (_) {
          if (_.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.665,
            ),
            itemCount: _.partys.length,
            itemBuilder: (context, index) {
              Party party = _.partys[index];
              return CardItem(party: party);
            },
          );
        },
      ),
    );
  }
}
