import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  var auth = FirebaseAuth.instance;

  Future<User?> registerUsingEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      user = userCredential.user;
      user!.updateDisplayName(name);
    } catch (err) {
      throw Exception(err.toString());
    }
    return user;
  }

  Future<User?> loginUsingEmailAndPassword(
      {required String email, required String password}) async {
    User? user;

    try {
      var userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      user = userCredential.user;
    } catch (err) {
      throw Exception(err.toString());
    }
    return user;
  }
}
