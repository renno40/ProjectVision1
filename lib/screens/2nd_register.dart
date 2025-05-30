import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../backEnd/supbase/supbaseAuth.dart';
import '3rd_login.dart';
import '4rth_onboard.dart';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController datebirthController = TextEditingController();
  TextEditingController visionProblemController = TextEditingController();

  // For password visibility
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  "assets/Vision Mate.png",
                  height: 150.h,
                  width: 200.w,
                ),

                // Welcome text
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30.sp,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20.h),

                // Name field
                buildTextField(
                  controller: usernameController,
                  labelText: "Full Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15.h),

                // Email field
                buildTextField(
                  controller: emailController,
                  labelText: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!value.contains("@")) {
                      return "Invalid email format";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15.h),

                // Password field
                buildTextField(
                  controller: passwordController,
                  labelText: "Password",
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15.h),

                // Date of Birth field
                buildTextField(
                  controller: datebirthController,
                  labelText: "Date of Birth",
                  readOnly: true,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your date of birth";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15.h),

                // Vision Problem field
                buildTextField(
                  controller: visionProblemController,
                  labelText: "What is your vision problem",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your vision problem";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30.h),

                // Register button with Supabase Auth
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        // Call the Supabase registration method
                        await SupabaseAuth().signUp(
                            emailController.text,
                            passwordController.text
                            , usernameController.text
                            , datebirthController.text
                            , visionProblemController.text);

                        // Navigate to home screen after successful registration
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OnboardScreen()),
                        );
                      } catch (e) {
                        // Handle registration errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Registration failed: ${e.toString()}")),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1D9AC6),
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                // Already have an account row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent text fields
  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.grey[100],
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          suffixIcon: suffixIcon,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: readOnly,
        validator: validator,
      ),
    );
  }

  // Date picker method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        datebirthController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    datebirthController.dispose();
    visionProblemController.dispose();
    super.dispose();
  }
}