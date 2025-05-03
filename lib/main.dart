import 'package:flutter/material.dart';
import 'screens/7th_detectScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testnow/text_detect.dart';

import 'screens/1sr_splash.dart';
import 'screens/2nd_register.dart';
import 'screens/3rd_login.dart';
import 'screens/4rth_onboard.dart';
import 'screens/5th_home.dart';
import 'screens/6th_text.dart';
import 'screens/8th_glass.dart';
import 'screens/9th_history.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await await Supabase.initialize(
      url: "https://nierhnzvsouakqbvsfhz.supabase.co",
      anonKey:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pZXJobnp2c291YWtxYnZzZmh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYyNzAyODksImV4cCI6MjA2MTg0NjI4OX0.846QDHPbxOGiwoc2eArY_s6vXwZA03JhJiOpcc8Ws_U");
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
              "/text":(context) => TextRecognitionScreen(),
              "/detect":(context) => ObjectDetectionScreen(),
            },
            initialRoute: "/splash",

          );
        });
  }
}