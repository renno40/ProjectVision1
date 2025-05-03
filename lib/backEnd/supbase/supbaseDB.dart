import 'package:supabase_flutter/supabase_flutter.dart';

class SupbaseDb {

  final supbase = Supabase.instance.client;

  Future insertprofil(
      String id,String username, String email, String password, String date_birth, String vision_problem) async {
    try {
      var values = {
        'id': id,
        'username': username,
        'email': email,
        'password': password,
        'date_birth': date_birth,
        'vision_problem': vision_problem,
      };
      await supbase.from('registration').insert(values);
      print("Insert Successfully");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  //how too get user profile
  Future<Map<String, dynamic>>getUserProfile(String id)async{
    try{
      final userprofile = await supbase.from('registration').select().eq('id', id).single();
      return userprofile;
    }catch(e){
      throw Exception(e.toString());
    }

  }
}