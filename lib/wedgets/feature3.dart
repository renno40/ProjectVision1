import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class featurethree extends StatelessWidget {
  const featurethree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
          child: Image.asset(
            "assets/objectdetection.png",
            height: 200.h,
            width: 400.w,
            fit: BoxFit.cover, // Ensures the image fills the rounded area
          ),
        ),

        SizedBox(height: 40.h),
        Text("Objective Detiction",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 35.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        ),
    Padding(
    padding: EdgeInsets.only(left: 40.w, right: 40.w),
        child: Text("Identifies the presence of various objects in your environment, assisting in real-time detection of them, ensuring trust and safety.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.sp,
              color: Colors.black54,
              fontWeight: FontWeight.bold
          ),
        )
    ),
      ],
    );

  }
}
