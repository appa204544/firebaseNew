import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning_project/comman_widgets.dart/dialogs.dart';
import 'package:firebase_learning_project/database/auth_exception_handler.dart';
import 'package:firebase_learning_project/database/auth_result_status.dart';
import 'package:firebase_learning_project/database/database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResultStatus? _status;
  // final FacebookLogin facebookSignIn = FacebookLogin();

  // //-----------------------CREATE USER OBJ BASED ON FIREBASE USER ------------------------
  // CarieUser _userFromFirebaseUser(User user) {
  //   return user != null ? CarieUser(uid: user.uid) : null;
  // }

  // //-----------------------AUTH CHANGE USER STREAM ------------------------
  // Stream<CarieUser> get user {
  //   return _auth
  //       .authStateChanges()
  //       //.map((FirebaseUser user) => _userFromFirebaseUser(user));
  //       .map(_userFromFirebaseUser);
  // }

  //-----------------------SIGN IN ------------------------
  Future<AuthResultStatus?> signInWithEmailAndPassword({
    String? email,
    String? password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      User user = result.user!;
      if (user != null) {
        if (user.emailVerified) {
          _status = AuthResultStatus.successful;
        } else {
          _status = AuthResultStatus.notVerified;
        }
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  //-----------------------FORGET PASSWORD ------------------------
  Future<AuthResultStatus?> resetPassword(String email) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .then((value) => _status = AuthResultStatus.successful);
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  //-----------------------REGISTER WITH EMAIL AND PASSWORD ------------------------
  Future<AuthResultStatus?> registerWithEmailAndPassword(
      String name,
      String email,
      String password,
      String createdOn) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
      if (user != null) {
        _status = AuthResultStatus.successful;
        DataService(uid: user.uid).setUserDetails(
            name: name,
            timestamp: createdOn,
            email: email,
            uid: user.uid);
        await user.sendEmailVerification();
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  // //-----------------------FACEBOOK AUTHENTICATION ------------------------
  // Future signInWithFacebook() async {
  //   print("Signing in with FB");

  //   final result = await facebookSignIn.logIn(['email']);

  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       AuthCredential credential =
  //           FacebookAuthProvider.credential(result.accessToken.token);
  //       final UserCredential authResult =
  //           await _auth.signInWithCredential(credential);
  //       final User? user = authResult.user;
  //       print("DONE DONE DONE: $user");
  //       break;
  //       // return _userFromFirebaseUser(user);
  //     case FacebookLoginStatus.cancelledByUser:
  //       print("Cancelled by user");
  //       break;
  //     case FacebookLoginStatus.error:
  //       print(result.errorMessage);
  //       break;
  //   }
  //   return null;
  // }


  // ----------------------Google Sign in------------------
  Future<AuthResultStatus?> signInWithGoogle(BuildContext context) async {
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          Dialogs().showLoader(context);
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          user = userCredential.user;
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
          DataService(uid: user!.uid).setUserDetails(
            name: user.displayName,
            timestamp: formattedDate,
            email: user.email,
            uid: user.uid);
          _status = AuthResultStatus.successful;
          Navigator.pop(context);
        } on FirebaseAuthException catch (e) {
          print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
        } catch (e) {
          print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
        }
      }
    }
    return _status;
  }

  //-----------------------SIGN OUT ------------------------
  Future signOut() async {
    try {
      // sp.clear();
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
