import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class Validation {
  static String? validateName(String value) {
    value = value.trim();

    RegExp rex =
        RegExp(r"[0-9~!@#$%^&*()_+{}\\[\]:;,.<>/?-]", caseSensitive: false);
    int whitespaces = RegExp(r"\s\b|\b\s").allMatches(value).length;
    if (value.isEmpty) {
      return "กรุณาระบุชื่อ-นามสกุล";
    } else if (rex.hasMatch(value) || whitespaces == 0) {
      return "ชื่อ-นามสกุลไม่ถูกต้อง";
    }
    return null;
  }

  static String? validateEmail(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return "กรุณาระบุอีเมล";
    } else if (!GetUtils.isEmail(value)) {
      return "รูปแบบอีเมลไม่ถูกต้อง";
    }
    return null;
  }

  static String? validatePassword(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return "กรุณาระบุรหัสผ่าน";
    } else if (value.length < 6) {
      return "รหัสผ่านต้องมีความยาวมากกว่า 6 ตัวอักษร";
    }
    return null;
  }

  static String? validateConfirmPassword(String value, String password) {
    value = value.trim();

    if (value.isEmpty) {
      return "กรุณาระบุยืนยันรหัสผ่าน";
    } else if (value.length < 6) {
      return "รหัสผ่านต้องมีความยาวมากกว่า 6 ตัวอักษร";
    } else if (value != password) {
      return "รหัสผ่านตรงกัน!!!";
    }
    return null;
  }

  static String validationExceptionCode(FirebaseException e) {
    String? message = 'เกิดข้อผิดพลาด';
    switch (e.code) {
      case 'user-not-found':
        message = "ไม่พบผู้ใช้สำหรับอีเมลดังกล่าว";
        break;
      case 'wrong-password':
        message = "รหัสผ่านไม่ถูกต้อง";
        break;
      case 'weak-password':
        message = "รหัสผ่านที่ให้มานั้นอ่อนแอเกินไป";
        break;
      case 'email-already-in-use':
        message = "อีเมลดังกล่าวได้มีบัญชีผู้ใช้อยู่แล้ว";
        break;
      case 'invalid-action-code':
        message = "รหัสไม่ถูกต้อง";
        break;
      case 'requires-recent-login':
        message = "ผู้ใช้ต้องตรวจสอบสิทธิ์อีกครั้งก่อนจึงจะสามารถดำเนินการได้";
        break;
    }

    return message;
  }
}
