part of 'firebase_auth_service_cubit.dart';

sealed class FirebaseAuthServiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FirebaseAuthServiceInitial extends FirebaseAuthServiceState {}

class FirebaseAuthServiceLoadingState extends FirebaseAuthServiceState {}

class FirebaseAuthServiceSuccessfulState extends FirebaseAuthServiceState {}

class FirebaseAuthServiceSuccessfulSignUpState
    extends FirebaseAuthServiceState {
  final String tempPassword;

  FirebaseAuthServiceSuccessfulSignUpState(this.tempPassword);

  @override
  List<Object?> get props => [tempPassword];
}

class FirebaseAuthServiceFailedState extends FirebaseAuthServiceState {
  final String message;

  FirebaseAuthServiceFailedState(this.message);

  @override
  List<Object?> get props => [message];
}
