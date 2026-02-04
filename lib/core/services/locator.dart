import 'package:get_it/get_it.dart';
import 'package:inner_bloom_app/core/repository/firebase_auth_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepository(),
  );
}
