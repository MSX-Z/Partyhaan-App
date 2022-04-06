import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partyhaan_app/components/button.dart';
import 'package:partyhaan_app/components/input_field.dart';
import 'package:partyhaan_app/controllers/party_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartyPage extends StatelessWidget {
  PartyPage({Key? key}) : super(key: key);
  final PartyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("หน้าการจัดการปาร์ตี้"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: 1.sw,
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    ScreenUtil().statusBarHeight),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    'สร้างปาร์ตี้',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                const _PartyForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PartyForm extends StatefulWidget {
  const _PartyForm({
    Key? key,
  }) : super(key: key);

  @override
  State<_PartyForm> createState() => _PartyFormState();
}

class _PartyFormState extends State<_PartyForm> {
  final partyFormKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController maximumController;
  File? fileImage;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
    maximumController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
    maximumController.dispose();
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      setState(() {
        fileImage = File(image.path);
      });

      print('file $fileImage');
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }
  }

  void _onLoading(Function callback) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const [
              CircularProgressIndicator(
                color: Colors.green,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Loading",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: partyFormKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: (fileImage == null)
                        ? Image.asset(
                            'assets/images/party_haan.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            fileImage!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: const Icon(
                        Icons.add_photo_alternate,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InputField(
              labelText: 'ชื่อปาร์ตี้',
              hintText: '',
              controller: titleController,
              validator: (value) {
                return (value.isEmpty) ? 'กรุณาระบุชื่อปาร์ตี้' : null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              labelText: 'รายละเอียดชื่อปาร์ตี้',
              hintText: '',
              controller: descController,
              validator: (value) {
                return (value.isEmpty)
                    ? 'กรุณาระบุรายละเอียดชื่อปาร์ตี้'
                    : null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              keyboardType: TextInputType.number,
              labelText: 'จำนวนคนในปาร์ตี้ทั้งหมด',
              hintText: '',
              iconData: Icons.person,
              controller: maximumController,
              validator: (value) {
                try {
                  int maximum = int.parse(value);
                  if (maximum < 1) {
                    return 'จำนวนคนในปาร์ตี้ขั้นต่ำ 1 คน';
                  }
                  return null;
                } catch (error) {
                  return 'รูปแบบไม่ถูกต้อง';
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              title: 'สร้างปาร์ตี้',
              onPressed: () {
                bool isValid = partyFormKey.currentState!.validate();
                if (!isValid) {
                  return;
                }

                File? file = fileImage;
                String title = titleController.text;
                String description = descController.text;
                int maximum = int.parse(maximumController.text);

                _onLoading(() async {
                  await PartyController.instance
                      .onAddParty(title, description, maximum, file);
                  Navigator.pop(context);
                  Get.back();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
