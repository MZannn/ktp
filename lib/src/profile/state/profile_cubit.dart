import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ktp/env/class/env.dart';
import 'package:ktp/src/profile/model/user_model.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  fetchUser() async {
    emit(ProfileLoading());
    try {
      final response = await KTPApi().get(path: 'user');
      UserModel user = UserModel.fromJson(response.data['data']);
      if (response.statusCode == 200) {
        emit(
          ProfileLoaded(user: user),
        );
      }
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
        ),
      );
    }
  }
}
