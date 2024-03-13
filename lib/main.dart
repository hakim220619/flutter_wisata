import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_riverpod/shared_preferences_riverpod.dart';
import 'package:wisata/home/HomePage.dart';
import 'package:wisata/login/view/login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


late SharedPreferences prefs;

final booPrefProvider = createPrefProvider<String>(
  prefs: (_) => prefs,
  prefKey: "role",
  defaultValue: "",
);

enum EnumValues {
  foo,
  bar,
}

final enumPrefProvider = createMapPrefProvider<EnumValues>(
  prefs: (_) => prefs,
  prefKey: "enumValue",
  mapFrom: (v) => EnumValues.values
      .firstWhere((e) => e.toString() == v, orElse: () => EnumValues.foo),
  mapTo: (v) => v.toString(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LoginApp",
      debugShowCheckedModeBanner: false,
      home:  const LoginPage(),
      builder: EasyLoading.init(),
    );
  }
}
