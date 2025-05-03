import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testnow/6th_text.dart';
import 'package:testnow/7thwalk.dart';

import '8th_glass.dart';

class Homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7ECFB), // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 100.w),
            Text(
              "HOME",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 90.w),
            Image.asset(
              "assets/Vision Mate.png", // Replace with actual logo path
              width: 70.w,
              height: 65.h,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Text(
                "HELLO!!",
                style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                "Welcome to VisionMate",
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.normal),
              ),

              SizedBox(height: 40.h),

              // Feature Buttons
              buildFeatureTile(
                context,
                "Read Text",
                "assets/text.png",
                ReadTextPage(),
              ),
              buildFeatureTile(
                context,
                "Walk Assist",
                "assets/walk.png",
                walkassistScreen(),
              ),
              buildFeatureTile(
                context,
                "Find My Glasses",
                "assets/glasses.png",
                GlassesScreen(),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF1D9AC6),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  // Function to build feature buttons
  Widget buildFeatureTile(BuildContext context, String title, String imagePath, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 2.w),
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                imagePath,
                width: 150.w,
                height: 150.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
