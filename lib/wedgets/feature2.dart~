import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class featuretwo extends StatelessWidget {
  const featuretwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
          child: Image.asset(
            "images/text.png",
            height: 200.h,
            width: 400.w,
            fit: BoxFit.cover, // Ensures the image fills the rounded area
          ),
        ),

        Text("Text Recognition",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 35.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40.w, right: 40.w), // Adds 10 pixels padding on all sides
          child: Text("just point your camera,and we'll read it out loud for you, making reading effortless anytime, anywhere!",
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
