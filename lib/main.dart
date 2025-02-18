import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:muze/models/user_model.dart';
import 'package:muze/pages/home_page.dart';
import 'package:muze/pages/login_page.dart';
import 'package:muze/utils/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Box<UserModel> _userBox = await _hiveSetup();
  runApp(MyApp(userBox: _userBox));
}

Future<Box<UserModel>> _hiveSetup() async {
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(UserModelAdapter());
  final Box<UserModel> _userBox = await Hive.openBox<UserModel>('userModel');
  return _userBox;
}

class MyApp extends StatelessWidget {
  final Box<UserModel> userBox;
  MyApp({this.userBox});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Box<UserModel>>(create: (context) => userBox),
      ],
      child: MaterialApp(
        title: 'Muze',
        theme: ThemeData(
          primaryColor: MyColors.primary,
          accentColor: MyColors.secondary,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Nunito',
        ),
        initialRoute: userBox.isEmpty ? '/login' : '/home',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return PageTransition(
                child: MyLoginPage(),
                type: PageTransitionType.fade,
              );
              break;
            case '/home':
              return PageTransition(
                child: MyHomePage(),
                type: PageTransitionType.fade,
              );
              break;
            default:
              return null;
          }
        },
      ),
    );
  }
}
