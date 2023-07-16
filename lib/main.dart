import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylecase/screens/home.dart';
import 'package:stylecase/screens/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? uid = pref.get("uid") as String?;

  print(uid);

  StatefulWidget screen = uid == null ? const Login() : const Home();

  runApp(GetMaterialApp(
    home: screen,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(scaffoldBackgroundColor: Colors.white),
  ));
}
