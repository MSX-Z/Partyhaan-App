import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:partyhaan_app/Utils/validation.dart';
import 'package:partyhaan_app/components/button.dart';
import 'package:partyhaan_app/components/input_field.dart';
import 'package:partyhaan_app/components/password_field.dart';
import 'package:partyhaan_app/controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("หน้าลงทะเบียน"),
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
                    'สร้างบัญชีผู้ใช้งาน',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                const _RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final registerFormKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: registerFormKey,
        child: Column(
          children: [
            InputField(
              labelText: 'ชื่อ-นามสกุล',
              hintText: 'ชื่อ นามสกุล',
              iconData: Icons.person,
              controller: nameController,
              validator: Validation.validateName,
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              labelText: 'อีเมล',
              hintText: 'example@gmail.com',
              iconData: Icons.email,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: Validation.validateEmail,
            ),
            const SizedBox(
              height: 10,
            ),
            PasswordField(
              labelText: 'รหัสผ่าน',
              controller: passwordController,
              validator: Validation.validatePassword,
            ),
            const SizedBox(
              height: 10,
            ),
            PasswordField(
              labelText: 'ยืนยันรหัสผ่าน',
              controller: confirmPasswordController,
              validator: (value) {
                return Validation.validateConfirmPassword(
                  value,
                  passwordController.text,
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            _CheckBoxAndButton(
              onPressed: () {
                bool isValidate =
                    registerFormKey.currentState!.validate();
                if (!isValidate) {
                  return;
                }
                String name = nameController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                AuthController.instance.onSingUp(name, email, password);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckBoxAndButton extends StatefulWidget {
  const _CheckBoxAndButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function()? onPressed;

  @override
  State<_CheckBoxAndButton> createState() => _CheckBoxAndButtonState();
}

class _CheckBoxAndButtonState extends State<_CheckBoxAndButton> {
  late bool isCheck;

  @override
  void initState() {
    super.initState();
    isCheck = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Theme(
              child: Checkbox(
                value: isCheck,
                onChanged: (bool? b) {
                  setState(() {
                    isCheck = b!;
                  });
                },
              ),
              data: ThemeData(
                primarySwatch: Colors.green,
              ),
            ),
            Text('ข้อตกลง')
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Button(
          title: "ลงทะเบียน",
          enable: isCheck,
          onPressed:(){widget.onPressed!();}
        ),
      ],
    );
  }
}
