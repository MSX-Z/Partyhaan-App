import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:partyhaan_app/constants/firebase_constants.dart';
import 'package:partyhaan_app/controllers/auth_controller.dart';

class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(auth.currentUser?.displayName ?? ""),
                  accountEmail: Text(auth.currentUser?.email ?? ""),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(
                      (auth.currentUser?.displayName?[0] != null)
                          ? '${auth.currentUser?.displayName?[0]}.'
                          : "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(239, 83, 80, 1)),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('ออกจากระบบ'),
            onTap: () {
              print('user ${AuthController.instance.user.value?.displayName}');
              AuthController.instance.onSingOut();
            },
          ),
        ],
      ),
    );
  }
}
