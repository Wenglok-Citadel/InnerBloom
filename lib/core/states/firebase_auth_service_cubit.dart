import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/firebase_auth_repository.dart';

part 'firebase_auth_service_state.dart';

class FirebaseAuthServiceCubit extends Cubit<FirebaseAuthServiceState> {
  FirebaseAuthServiceCubit(this.repo) : super(FirebaseAuthServiceInitial());

  final FirebaseAuthRepository repo;

  Future<void> signUpWithTempPassword(String email) async {
    emit(FirebaseAuthServiceLoadingState());

    try {
      final tempPwd = await repo.signUpWithTempPassword(email);
      emit(FirebaseAuthServiceSuccessfulSignUpState(tempPwd));
    } catch (e) {
      emit(FirebaseAuthServiceFailedState(e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(FirebaseAuthServiceLoadingState());

    try {
      await repo.signIn(email, password);

      emit(FirebaseAuthServiceSuccessfulState());
    } catch (e) {
      emit(FirebaseAuthServiceFailedState(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(FirebaseAuthServiceLoadingState());
    try {
      await repo.signUp(email, password);
      emit(FirebaseAuthServiceSuccessfulState());
    } catch (e) {
      emit(FirebaseAuthServiceFailedState(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(FirebaseAuthServiceLoadingState());

    try {
      await repo.signOut();

      emit(FirebaseAuthServiceSuccessfulState());
    } catch (e) {
      emit(FirebaseAuthServiceFailedState(e.toString()));
    }
  }
}
