import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:partyhaan_app/Utils/validation.dart';
import 'package:partyhaan_app/components/button.dart';
import 'package:partyhaan_app/components/input_field.dart';
import 'package:partyhaan_app/components/password_field.dart';
import 'package:partyhaan_app/controllers/auth_controller.dart';
import 'package:partyhaan_app/pages/register_page.dart';
import '../components/email_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("หน้าเข้าสู่ระบบ"),
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
                  margin: const EdgeInsets.only(bottom: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/party_haan.png',
                      height: 300,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                const _LoginForm(),
                const _LoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final loginFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: loginFormKey,
        child: Column(
          children: [
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
              height: 20,
            ),
            Button(
              title: "เข้าสู่ระบบ",
              onPressed: () {
                bool isValidate = loginFormKey.currentState!.validate();
                if (!isValidate) {
                  return;
                }
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                AuthController.instance.onSingIn(email, password);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginFooter extends StatelessWidget {
  const _LoginFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('คุณยังไม่มีบัญชีผู้ใช้งานใช่หรือไม่? '),
          GestureDetector(
            onTap: () => {
              Get.to(const RegisterPage(), transition: Transition.leftToRight)
            },
            child: const Text(
              'ลงทะเบียน',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
