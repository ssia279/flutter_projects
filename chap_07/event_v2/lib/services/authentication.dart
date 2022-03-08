import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user?.uid;
    }
    catch(e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  User? getUser()  {
    try {
      User? userCredential = _firebaseAuth.currentUser;
      return userCredential;
    }
    catch(e) {
      print(e);
    }
  }
}