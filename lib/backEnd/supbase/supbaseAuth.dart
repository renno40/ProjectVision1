import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  final supabase = Supabase.instance.client;
  Future SingUp(String email,String password)async{
    try{
      final AuthResponse response =
          // Email and password sign up
          await supabase.auth.signUp(
        email: email,
        password: password,
      );
      print(response.user);
    }catch(e){
      throw Exception(e.toString());
    }

    Future SingIn(String email,String password)async{
      try{
        final AuthResponse response =
            // Email and password sign up
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        print(response.user);
        print("login Succesfully");
      }catch(e){
        throw Exception(e.toString());
      }
    }




  }
}
