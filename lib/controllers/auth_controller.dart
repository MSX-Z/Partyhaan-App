import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:partyhaan_app/Utils/validation.dart';
import 'package:partyhaan_app/constants/firebase_constants.dart';
import 'package:partyhaan_app/pages/home_page.dart';
import 'package:partyhaan_app/pages/login_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  Rx<User?> get user => _user;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, _onPageInit);
  }

  _onPageInit(User? user) {
    _user = Rx<User?>(auth.currentUser);
    update();

    Future.delayed(const Duration(seconds: 1), () {
      if (user == null) {
        Get.offAll(() => const LoginPage(), transition: Transition.leftToRight);
      } else {
        Get.offAll(() => HomePage(), transition: Transition.leftToRight);
      }
    });
  }

  Future<void> onSingIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('เข้าสู่ระบบสำเร็จ');
    } on FirebaseAuthException catch (e) {
      String message = Validation.validationExceptionCode(e);
      Get.snackbar(
        "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> onSingUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();

      print('user ${auth.currentUser?.displayName}');
    } on FirebaseAuthException catch (e) {
      String message = Validation.validationExceptionCode(e);
      Get.snackbar(
        "เกิดข้อผิดพลาดในการสร้างบัญชีผู้ใช้งาน",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> onSingOut() async {
    try {
      await auth.signOut();

      print('user ${auth.currentUser?.displayName}');
    } on FirebaseAuthException catch (e) {
      String message = Validation.validationExceptionCode(e);
      Get.snackbar(
        "เกิดข้อผิดพลาดในการสร้างบัญชีผู้ใช้งาน",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
