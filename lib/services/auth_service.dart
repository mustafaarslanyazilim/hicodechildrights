import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signup(String email, String password,
      String confirmPassword, BuildContext context) async {
    if (password != confirmPassword) {
      _showErrorMessage(context, "Şifreler uyuşmuyor. Lütfen kontrol edin.");
      return null;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Bir hata oluştu. Lütfen tekrar deneyin.";
      if (e.code == 'weak-password') {
        errorMessage = "Şifreniz çok zayıf. Güçlü bir şifre kullanın.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Bu email zaten kullanımda.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Geçersiz email adresi.";
      }
      _showErrorMessage(context, errorMessage);
      return null;
    }
  }

    Future<UserCredential?> signin(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Bir hata oluştu. Lütfen tekrar deneyin.";
      if (e.code == 'user-not-found') {
        errorMessage = "Bu email ile kayıtlı bir kullanıcı bulunamadı.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Hatalı şifre girdiniz. Lütfen tekrar deneyin.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Geçersiz email adresi.";
      }
      _showErrorMessage(context, errorMessage);
      return null;
    }
  }

    Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      _showErrorMessage(context, "Google ile giriş yapılamadı: $e");
      return null;
    }
  }

  Future<UserCredential?> signInWithApple(BuildContext context) async {
    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthProvider oAuthProvider = OAuthProvider("apple.com");
      final AuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      _showErrorMessage(context, "Apple ile giriş yapılamadı: $e");
      return null;
    }
  }


  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
