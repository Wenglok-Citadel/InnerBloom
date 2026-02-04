import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:inner_bloom_app/core/repository/firebase_auth_repository.dart';
import 'package:inner_bloom_app/core/states/firebase_auth_service_cubit.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/screens/landing_page.dart';

import 'core/services/locator.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FirebaseAuthServiceCubit(
            GetIt.instance<FirebaseAuthRepository>(),
          ),
        ),
      ],
      child: MaterialApp(home: LandingPage()),
    ),
  );
}
