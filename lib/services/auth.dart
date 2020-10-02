import 'package:firebase_auth/firebase_auth.dart';

//  class to work with firebase auth services
class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // method to sign in with email id and password.
  Future signInEmail(email, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("error");
    }
  }
}
