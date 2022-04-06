import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partyhaan_app/controllers/auth_controller.dart';
import 'package:partyhaan_app/pages/home_page.dart';
import 'package:partyhaan_app/pages/login_page.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xfffb7369),
          image: DecorationImage(
            image: AssetImage('assets/images/party_haan.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
