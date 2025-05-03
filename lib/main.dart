import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '1sr_splash.dart';
import '2nd_register.dart';
import '3rd_login.dart';
import '4rth_onboard.dart';
import '5th_home.dart';
import '6th_text.dart';
import '8th_glass.dart';
import '9th_history.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(402, 874),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: OnboardScreen(),
            routes: {
              "/splash": (context)=> splashScreen(),
              "/OnboardScreen":(context)=>OnboardScreen(),
              "/register":(context)=>Register(),
              "/login":(context) => LoginScreen(),
              "/Home":(context) => Homescreen(),
              "/ReadTextScreen":(context) =>ReadTextPage(),
              "/FindGlassesScreen":(context) => GlassesScreen(),
              "/history":(context) => HistoryScreen(),
            },
            initialRoute: "/splash",

          );
        });
  }
}