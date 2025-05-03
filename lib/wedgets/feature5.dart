import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class featurefive extends StatelessWidget {
  const featurefive({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
          child: Image.asset(
            "assets/walk.png",
            height: 200.h,
            width: 400.w,
            fit: BoxFit.cover, // Ensures the image fills the rounded area
          ),
        ),
        SizedBox(height: 30.h),
        Text("Localization and guidance",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 35.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        ),
    Padding(
    padding: EdgeInsets.only(left: 40.w, right: 40.w),
    child:
        Text("Empowerment at your fingertip.Our application leverages advanced technologies to make sure you have the tools to take control of your surrounding.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
              fontWeight: FontWeight.bold
          ),
        )
    ),],
    );

  }
}
