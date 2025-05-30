import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testnow/backEnd/supbase/supbaseAuth.dart';
import 'package:testnow/model/profilemodel.dart';

import '../backEnd/supbase/supbaseDB.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  getProfile() async {
    emit(ProfileLoading());
    try {
      String id = SupabaseAuth().currentUserId ?? "no id";
      final user = await SupbaseDb().getUserProfile(id);
      emit(ProfileSuccess(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  final subabase = Supabase.instance.client;
  final userid = SupabaseAuth().currentUserId ?? "usernotfont";

  Future<void> upadateProfileImage(
    String proplem,
  ) async {
    try {
      await subabase
          .from("registration")
          .update({"vision_problem": proplem}).eq('id', userid);
      print("update successfully");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
