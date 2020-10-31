import 'package:common_knowledge/models/User.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);

//  Stream<User> get getCurrentUser => _firebaseAuth.onAuthStateChanged.map(
//        (FirebaseUser user) => User(
//          email: user?.email,
//          displayName: user?.displayName,
//          photoURL: user?.photoUrl,
//          phoneNumber: user?.phoneNumber,
//          creationTime:
//              DateFormat('dd MMMM yyyy').format(user.metadata.creationTime),
//          lastSignInTime:
//              DateFormat('dd.MM.yyyy').format(user.metadata.lastSignInTime),
//        ),
//      );

  // Email and Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final currentUser = result.user;
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
    final newUser = User(
      email: currentUser.email,
      displayName: name,
      photoURL: null,
      phoneNumber: null,
      creationTime: currentUser.metadata.creationTime,
      userRole: 'user',
    );
    await DatabaseService(uid: currentUser.uid).updateUserProfile(newUser);
    return currentUser.uid;
  }

  // Email and Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final currentUser = result.user;

    return currentUser.uid;
  }

  // Sign Out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Reset password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Create Anonymous User
  Future signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  // Convert anonymous user to permanent user with Email
  Future convertUserWithEmail(
      String email, String password, String name) async {
    final currentUser = await _firebaseAuth.currentUser();
    final credential =
        EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    final newUser = User(
      email: email,
      displayName: name,
      photoURL: null,
      phoneNumber: null,
      creationTime: currentUser.metadata.creationTime,
      userRole: 'user',
    );
    await DatabaseService(uid: currentUser.uid).updateUserProfile(newUser);
    return currentUser.uid;
  }

  // Convert anonymous user to permanent user with Google
  Future convertUserWithGoogle() async {
    final currentUser = await _firebaseAuth.currentUser();
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
    await currentUser.linkWithCredential(credential);
//    await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
  }

  // Google Sign In
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
    final result = await _firebaseAuth.signInWithCredential(credential);
    final currentUser = result.user;

    return currentUser.uid;
  }
}
