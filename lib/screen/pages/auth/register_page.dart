import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:orders_app/models/model_tenant.dart';

import '../../../widget/loading.dart';
import '../../../widget/snackbar.dart';
import 'services/firebase_auth.dart';
import '../../../widget/button.dart';
import '../../../widget/form.dart';
import '../../main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final auth = FirebaseAuthService();

  final namaTenantFocusNode = FocusNode();
  final emailTenantFocusNode = FocusNode();
  final phoneTenantFocusNode = FocusNode();
  final passwordTenantFocusNode = FocusNode();
  final createTenantFocusNode = FocusNode();

  bool obscure = false;

  int seconds = 5;

  void registerAuth(int seconds) async {
    showLoading(context);

    User? tenantRegister = await auth.registerTenant(context, seconds);

    if (tenantRegister != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      );

      snackBarCustom(
        context,
        Theme.of(context).colorScheme.secondary,
        'Enter, Created Successfully',
        Colors.white,
        seconds,
      );
    } else {
      hideLoading(context);

      snackBarCustom(
        context,
        Theme.of(context).colorScheme.error,
        'Some error happen',
        Colors.white,
        seconds,
      );
    }
  }

  List<TenantModel> tenantData = [];

  Future<void> addTenant(
    String namaTenant,
    String emailTenant,
    String phoneNumberTenant,
    String passwordTenant,
    int seconds,
  ) async {
    const String imageTenant =
        'https://i.pinimg.com/736x/e3/be/0a/e3be0a7d8b36490242fde2a63f7d0d9a.jpg';

    DateTime datetimeNow = DateTime.now();

    Uri url =
        Uri.parse('https://order-app-a16ec-default-rtdb.asia-southeast1.firebasedatabase.app/');

    try {
      showLoading(context);

      final response = await http.post(
        url,
        body: json.encode(
          {
            'image_tenant': imageTenant,
            'nama_tenant': namaTenant,
            'email_tenant': emailTenant,
            'phoneNumber_tenant': phoneNumberTenant,
            'password_tenant': passwordTenant,
            'timestamp': datetimeNow.toString(),
          },
        ),
      );

      if (response.statusCode == 200) {
        final idTenant = json.decode(response.body)['name'];
        tenantData.add(
          TenantModel(
            idTenant: idTenant,
            imageTenant: imageTenant,
            nameTenant: namaTenant,
            emailTenant: emailTenant,
            phoneNumberTenant: phoneNumberTenant,
            timestamp: datetimeNow as Timestamp,
            menu: [],
            order: [],
          ),
        );

        snackBarCustom(
          context,
          Theme.of(context).colorScheme.secondary,
          'Enter, Created Successfully',
          Colors.white,
          seconds,
        );
      } else {
        hideLoading(context);

        snackBarCustom(
          context,
          Theme.of(context).colorScheme.error,
          'Failed to created tenant.',
          Colors.white,
          seconds,
        );
      }
    } catch (e) {
      snackBarCustom(
        context,
        Theme.of(context).colorScheme.error,
        'Error: $e',
        Colors.white,
        seconds,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: ButtonBack(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's create your account.",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                        height: 1,
                      ),
                    ),
                    const Gap(30),
                    FormFields(
                      prefixIcon: Iconsax.shop_outline,
                      inputType: TextInputType.name,
                      controller: auth.namaTenantController,
                      hintText: 'Nama Tenant',
                      tap: false,
                      maxLineBoolean: false,
                      textInputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                      focusNode: namaTenantFocusNode,
                      onFieldSubmit: (p0) {
                        FocusScope.of(context).requestFocus(emailTenantFocusNode);
                      },
                    ),
                    const Gap(10),
                    FormFields(
                      prefixIcon: Iconsax.sms_outline,
                      inputType: TextInputType.emailAddress,
                      controller: auth.emailTenantController,
                      hintText: 'Email Address',
                      tap: false,
                      maxLineBoolean: false,
                      textInputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                      focusNode: emailTenantFocusNode,
                      onFieldSubmit: (p0) {
                        FocusScope.of(context).requestFocus(phoneTenantFocusNode);
                      },
                    ),
                    const Gap(10),
                    FormFields(
                      prefixIcon: Iconsax.call_calling_outline,
                      inputType: TextInputType.phone,
                      controller: auth.phoneTenantController,
                      hintText: 'Phone Number',
                      tap: false,
                      maxLineBoolean: false,
                      textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                      focusNode: phoneTenantFocusNode,
                      onFieldSubmit: (p0) {
                        FocusScope.of(context).requestFocus(passwordTenantFocusNode);
                      },
                    ),
                    const Gap(10),
                    FormFieldsPassword(
                      prefixIcon: Iconsax.password_check_outline,
                      inputType: TextInputType.visiblePassword,
                      controller: auth.passwordTenantController,
                      hintText: 'Password',
                      tap: false,
                      textInputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                      focusNode: passwordTenantFocusNode,
                      onFieldSubmit: (p0) {
                        FocusScope.of(context).requestFocus(createTenantFocusNode);
                      },
                      obscure: obscure,
                      onTap: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    ButtonCustom(
                      onPressed: () {
                        if (auth.namaTenantController.text.isEmpty ||
                            auth.emailTenantController.text.isEmpty ||
                            auth.phoneTenantController.text.isEmpty ||
                            auth.passwordTenantController.text.isEmpty) {
                          snackBarCustom(
                            context,
                            Colors.redAccent.shade400,
                            'PLEASE, filled in the blank field',
                            Colors.white,
                            seconds,
                          );
                        } else {
                          // addTenant(
                          //   auth.namaTenantController.text,
                          //   auth.emailTenantController.text,
                          //   auth.phoneTenantController.text,
                          //   auth.passwordTenantController.text,
                          // );
                          registerAuth(seconds);
                        }
                      },
                      addBorder: false,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Gap(25),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'By creating an account, you agree to our ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                          ),
                          TextSpan(
                            text: ' and agree to ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy.',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(25),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
