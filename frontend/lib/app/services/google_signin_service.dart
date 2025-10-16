import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleSignInService {
  // Lazy initialization to avoid Firebase access before it's initialized
  FirebaseAuth? _auth;
  FirebaseAuth get auth {
    if (_auth == null) {
      try {
        _auth = FirebaseAuth.instance;
      } catch (e) {
        debugPrint('⚠️ Firebase not initialized: $e');
        rethrow;
      }
    }
    return _auth!;
  }
  
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Sign in with Google
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Check if Firebase is initialized
      if (_auth == null) {
        try {
          _auth = FirebaseAuth.instance;
        } catch (e) {
          debugPrint('❌ Firebase not initialized. Cannot use Google Sign-In.');
          return {
            'success': false,
            'error': 'Firebase not initialized. Please configure Firebase first.',
          };
        }
      }
      
      // Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        debugPrint("❌ Google Sign-in cancelled by user.");
        return null;
      }

      debugPrint("✅ Google User: ${googleUser.displayName}");

      // Obtain the auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential = 
          await _auth!.signInWithCredential(credential);
      
      final User? firebaseUser = userCredential.user;
      
      if (firebaseUser != null) {
        print("✅ Firebase User: ${firebaseUser.displayName}");
        
        // Return user data
        return {
          'success': true,
          'uid': firebaseUser.uid,
          'email': firebaseUser.email ?? '',
          'name': firebaseUser.displayName ?? '',
          'photoUrl': firebaseUser.photoURL ?? '',
          'token': await firebaseUser.getIdToken() ?? '',
        };
      }

      return null;
    } catch (error) {
      debugPrint("❌ Google Sign-in error: $error");
      return {
        'success': false,
        'error': error.toString(),
      };
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth?.signOut();
      debugPrint("✅ User signed out successfully");
    } catch (error) {
      debugPrint("❌ Sign-out error: $error");
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth?.currentUser;
  }

  /// Check if user is signed in
  bool isSignedIn() {
    return _auth?.currentUser != null;
  }
}
