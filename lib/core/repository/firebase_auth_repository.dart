import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get name => _auth.currentUser?.displayName;

  // String _generateTempPassword() {
  //   const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789@#\$%";
  //   final rand = Random.secure();
  //   return List.generate(10, (_) => chars[rand.nextInt(chars.length)]).join();
  // }

  Future<String> signUpWithTempPassword(String email) async {
    // final tempPassword = _generateTempPassword();

    final String displayName = email.split('@').first;

    final UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: "123456",
    );

    // Update display name
    await result.user?.updateDisplayName(displayName);

    // Reload user to ensure changes are reflected
    await result.user?.reload();

    await _auth.currentUser?.sendEmailVerification();

    return "123456";
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    print('current username: ${_auth.currentUser?.displayName}');
  }

  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn.instance
        .attemptLightweightAuthentication();

    if (googleUser == null) throw Exception("Google sign-in cancelled");

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: null,
    );

    await _auth.signInWithCredential(credential);
  }
}
