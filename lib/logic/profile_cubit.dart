import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:testnow/backEnd/supbase/supbaseAuth.dart';
import 'package:testnow/model/profilemodel.dart';

import '../backEnd/supbase/supbaseDB.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  getProfile() async {
    emit(ProfileLoading());
    try{
      String id =SupabaseAuth().CurrentUserId??"no id";
      final user =await SupbaseDb().getUserProfile(id);
      emit(ProfileSuccess(user));
    }catch(e){
      emit(ProfileError(e.toString()));
    }
  }
}
