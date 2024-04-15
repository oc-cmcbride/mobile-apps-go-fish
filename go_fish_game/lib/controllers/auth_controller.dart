import '../services/auth.dart';

class AuthController {
  factory AuthController() => _singleton;

  AuthController._internal();

  static final AuthController _singleton = AuthController._internal();
  final _auth = Auth();

  Future<String?> createAccount(
      {required String email, required String password}) {
    return _auth.createAccountWithEmailAndPassword(
        email: email, password: password);
  }

  Future<String?> signIn({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  void signOut() => _auth.signOut();

  String? get userId => _auth.userId;

  bool get signedIn => userId != null;

  Stream<bool> get loggedInStream => _auth.stream.map((user) => user != null);
}
