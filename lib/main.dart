import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:partyhaan_app/Themes/theme.dart';
import 'package:partyhaan_app/controllers/auth_controller.dart';
import 'package:partyhaan_app/controllers/party_controller.dart';
import 'package:partyhaan_app/pages/home_page.dart';
import 'package:partyhaan_app/pages/login_page.dart';
import 'package:partyhaan_app/pages/register_page.dart';
import 'package:partyhaan_app/pages/splash_page.dart';
import 'package:partyhaan_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    Get.put(AuthController());
    Get.put(PartyController());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Party Haan',
        theme: themeApp,
        home: SplashPage(),
      ),
    );
  }
}
