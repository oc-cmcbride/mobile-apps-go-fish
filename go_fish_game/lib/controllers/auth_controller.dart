import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth.dart';

class AuthController {
  factory AuthController() => _singleton;

  AuthController._internal();

  static final AuthController _singleton = AuthController._internal();
  final _auth = Auth();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> createAccount(
      {required String email, required String password}) {
    return _auth.createAccountWithEmailAndPassword(
        email: email, password: password);
  }

  Future<String?> signIn({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  void signOut() => _auth.signOut();

  bool get isGoogleSignIn {
    final user = _auth.currentUser;
    if (user != null) {
      for (final provider in user.providerData) {
        if (provider.providerId == 'google.com') {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      _auth.signOut();
      // Additional sign-out logic for Google sign-in
    } catch (e) {
      // Handle error
    }
  }

  String? get userId => _auth.userId;

  bool get signedIn => userId != null;

  Stream<bool> get loggedInStream => _auth.stream.map((user) => user != null);
}
