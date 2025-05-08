import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testnow/backEnd/supbase/supbaseDB.dart';

import '../../model/profilemodel.dart';

class SupabaseAuth {
  // i need more fun auth by google and facbook
  final supabase = Supabase.instance.client;
  String?get CurrentUserId{
    return supabase.auth.currentUser?.id;
  }
  Future SingUp(String email, String password, String username,
      String date_birth, String vision_problem) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      print(response.user);

      if (response.user != null) {

        if(response.user != null){

          Profile profile=Profile(id: response.user!.id,
              email: email,
              username: username,
              date_birth: date_birth,
              vision_problem: vision_problem,
              password: password);

          await  SupbaseDb().insertProfile(profile);
        }
      }
      print(response.user);
    } catch (e) {
      throw Exception(e.toString());
    }

    Future SingIn(String email, String password) async {
      try {
        final AuthResponse response =
            // Email and password sign up
            await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        print(response.user);
        print("login Succesfully");
      } catch (e) {
        throw Exception(e.toString());
      }
    }
  }
}
