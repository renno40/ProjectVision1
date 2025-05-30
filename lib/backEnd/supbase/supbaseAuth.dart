import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testnow/backEnd/supbase/supbaseDB.dart';

import '../../model/profilemodel.dart';

class SupabaseAuth {
  final supabase = Supabase.instance.client;

  String? get currentUserId => supabase.auth.currentUser?.id;

  Future<void> signUp(String email, String password, String username,
      String dateBirth, String visionProblem) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      print("✅ Registered user: ${response.user?.id}");

      if (response.user != null) {
        Profile profile = Profile(
          id: response.user!.id,
          email: email,
          username: username,
          date_birth: dateBirth,
          vision_problem: visionProblem,
          password: password,
        );

        await SupbaseDb().insertProfile(profile);
        print("✅ Profile saved");
      }
    } catch (e) {
      print("❌ Auth error: $e");
      throw Exception("Authentication failed: ${e.toString()}");
    }
  }
}
