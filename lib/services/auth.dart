import 'package:dinendash/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUser);
  }

  // Google Sign In for Users
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken
      );
      
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      // Send email verification
      if (!user.isEmailVerified) {
        user.sendEmailVerification();
      }

      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign In users
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Up users
  Future signUpWithEmailAndPassword({String email, String password}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      user.sendEmailVerification();
      
      // Create new database document for the user
      

      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out users
  Future signOut() async {
    try {
      return Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut()
      ]);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Verify User
  Future<bool> isVerified() async {
    final FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  // Create User class from FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, verified: user.isEmailVerified) : null;
  }

}