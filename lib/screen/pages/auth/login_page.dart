import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../widget/snackbar.dart';
import '../../../widget/loading.dart';
import 'services/firebase_auth.dart';
import '../../../widget/button.dart';
import '../../../widget/form.dart';
import '../../main_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = FirebaseAuthService();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final loginFocusNode = FocusNode();

  bool obscure = false;

  int seconds = 5;

  void loginAuth(int seconds) async {
    showLoading(context);

    User? tenantLogin = await auth.loginTenant(context, seconds);

    if (tenantLogin != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      );

      snackBarCustom(
        context,
        Theme.of(context).colorScheme.secondary,
        'Enter, Successfully',
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/Take Away-bro.svg',
                        height: 200,
                      ),
                      const Gap(10),
                      Text(
                        "Let's! Login to find out.",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                FormFields(
                  prefixIcon: Iconsax.sms_outline,
                  inputType: TextInputType.emailAddress,
                  controller: auth.emailTenantController,
                  hintText: 'Email Address',
                  tap: false,
                  maxLineBoolean: false,
                  textInputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                  focusNode: emailFocusNode,
                  onFieldSubmit: (p0) {
                    FocusScope.of(context).requestFocus(passwordFocusNode);
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
                  focusNode: passwordFocusNode,
                  onFieldSubmit: (p0) {
                    FocusScope.of(context).requestFocus(loginFocusNode);
                  },
                  obscure: obscure,
                  onTap: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                ),
                const Gap(20),
                ButtonCustom(
                  onPressed: () {
                    if (auth.emailTenantController.text.isEmpty &&
                        auth.passwordTenantController.text.isEmpty) {
                      snackBarCustom(
                        context,
                        Colors.redAccent.shade400,
                        'Email Address and Password are NOT filled in',
                        Colors.white,
                        seconds,
                      );
                    } else if (auth.emailTenantController.text.isEmpty) {
                      snackBarCustom(
                        context,
                        Colors.redAccent.shade400,
                        'Email Address are NOT filled in',
                        Colors.white,
                        seconds,
                      );
                    } else if (auth.passwordTenantController.text.isEmpty) {
                      snackBarCustom(
                        context,
                        Colors.redAccent.shade400,
                        'Password are NOT filled in',
                        Colors.white,
                        seconds,
                      );
                    } else {
                      loginAuth(seconds);
                    }
                  },
                  addBorder: false,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Gap(10),
                ButtonCustom(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  addBorder: true,
                  backgroundColor: Colors.grey.shade50,
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
