// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../widget/snackbar.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final String image = 'https://i.pinimg.com/736x/e3/be/0a/e3be0a7d8b36490242fde2a63f7d0d9a.jpg';

  final namaTenantController = TextEditingController();
  final emailTenantController = TextEditingController();
  final phoneTenantController = TextEditingController();
  final passwordTenantController = TextEditingController();

  Future<User?> registerTenant(BuildContext context, int seconds) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: emailTenantController.text.trim(),
        password: passwordTenantController.text.trim(),
      );

      User? user = credential.user;

      await FirebaseFirestore.instance.collection('tenants').doc(user!.uid).set({
        'id_tenant': credential.user!.uid,
        'image_tenant': image,
        'nama_tenant': namaTenantController.text.trim(),
        'email_tenant': emailTenantController.text.trim(),
        'phoneNumber_tenant': phoneTenantController.text.trim(),
        'pwd_tenant': passwordTenantController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        snackBarCustom(
          context,
          Colors.redAccent.shade400,
          'Email address is already in use',
          Colors.white,
          seconds,
        );
      } else {
        snackBarCustom(
          context,
          Colors.redAccent.shade400,
          'An error occurred: ${e.code}',
          Colors.white,
          seconds,
        );
      }
    }
    return null;
  }

  Future<User?> loginTenant(BuildContext context, int seconds) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: emailTenantController.text.trim(),
        password: passwordTenantController.text.trim(),
      );

      User? user = credential.user;

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' && e.code == 'wrong-password') {
        snackBarCustom(
          context,
          Colors.redAccent.shade400,
          'Invalid email or password',
          Colors.white,
          seconds,
        );
      } else {
        snackBarCustom(
          context,
          Colors.redAccent.shade400,
          'An error occurred: ${e.code}',
          Colors.white,
          seconds,
        );
      }
    }
    return null;
  }
}
