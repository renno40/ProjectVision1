import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class featurefour extends StatelessWidget {
  const featurefour({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
          child: Image.asset(
            "images/glasses.png",
            height: 200.h,
            width: 400.w,
            fit: BoxFit.cover, // Ensures the image fills the rounded area
          ),
        ),
        SizedBox(height: 40.h),
        Text("Locate My Glasses",
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
        Text("Easily locate misplaced glasses using AI-powered detection. Scan the environment receive precise directions, and follow voice guidance to find them effortlessly.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
              fontWeight: FontWeight.bold
          ),
    ),
    ),
      ],
    );

  }
}
