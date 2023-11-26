import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad_project_ecommerce/Screens/ForgotPasswordRecovery/passrecovery.dart';

import '../BottomnavigationBar/BottomnavigationBar.dart';
import '../Screens/homepage/Homepage.dart';
import '../main.dart';

class AuthSevices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<User?> SignUp(
      String email, String password, String gender, String Username) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("Users").doc(user.uid).set({
          "Username": Username,
          'Email': email,
          "Password": password,
          "Gender": gender,
          "Profile Picture": '',
          'uid': user.uid,
          'Status': 'Online',
          'Last Seen': DateTime.now(),
          'Date Joined': DateTime.now()
        });
        Get.offAll(() => BottomNavigationBarWidget(),
            transition: Transition.cupertino);
        Get.rawSnackbar(
            titleText: const Text(
              'Successfull',
              style: TextStyle(color: Colors.white),
            ),
            messageText: const Text(
              "Registration Successfull",
              style: TextStyle(color: Colors.white),
            ),
            snackStyle: SnackStyle.GROUNDED,
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('', '',
          titleText: const Text(
            'Failed',
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.message.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.GROUNDED);
    }
  }
  Future<User?> googelSignIn() async {
    try {
      GoogleSignInAccount? user = await GoogleSignIn().signIn();
      if (user != null) {
        GoogleSignInAuthentication auth = await user.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: auth.accessToken, idToken: auth.idToken);
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        User? user1 = userCredential.user;
        if (user1 != null) {
          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection("Users")
              .doc(user1.uid)
              .get();
          if (!doc.exists) {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(user1.uid)
                .set({
              "Username": user.displayName,
              'Email': user.email,
              'uid': user1.uid,
              "Password": '',
              "Profile Picture": user.photoUrl,
              'Date Joined': DateTime.now(),
              'Status': 'Online',
              'Last Seen': DateTime.now(),
            });
            Get.off(() => BottomNavigationBarWidget(),
                transition: Transition.cupertino);
            Get.rawSnackbar(
                titleText: const Text(
                  'Successfull',
                  style: TextStyle(color: Colors.white),
                ),
                messageText: const Text(
                  "Registration Successfull",
                  style: TextStyle(color: Colors.white),
                ),
                snackStyle: SnackStyle.GROUNDED,
                duration: const Duration(seconds: 3),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green);
          }
          Get.off(() => BottomNavigationBarWidget(),
              transition: Transition.cupertino);
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('', '',
          titleText: const Text(
            'Failed',
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.message.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.GROUNDED);
    }
  }

  Future<User?> Login(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        Get.off(() => BottomNavigationBarWidget(),
            transition: Transition.cupertino);
        Get.rawSnackbar(
            titleText: const Text(
              'Successfull',
              style: TextStyle(color: Colors.white),
            ),
            messageText: const Text(
              "Login Successfull",
              style: TextStyle(color: Colors.white),
            ),
            snackStyle: SnackStyle.GROUNDED,
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('', '',
          titleText: const Text(
            'Failed',
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.message.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.GROUNDED);
    }
  }

  Future<void> Passwordrecovery(String email) async {
    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Show success message
      Get.snackbar(
        'Success',
        'Password reset email has been sent to $email',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.GROUNDED,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // User not found for the given email address
        Get.snackbar(
          'Account Not Found',
          'There is no account registered with this email address.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          snackStyle: SnackStyle.GROUNDED,
        );
      } else {
        // Handle other FirebaseAuth exceptions
        Get.snackbar(
          'Failed',
          e.message ?? 'An error occurred while processing your request.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          snackStyle: SnackStyle.GROUNDED,
        );
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
      Get.snackbar(
        'Failed',
        'An error occurred while processing your request.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.GROUNDED,
      );
    }
  }

  Future logout() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .update({
        'Status': 'Offline',
        'Last Seen': DateTime.now(),
      });
      await firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      Get.offAll(() => LoginPage());
    }
  }
}
