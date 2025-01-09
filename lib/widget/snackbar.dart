import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void snackBarCustom(
  BuildContext context,
  Color backgroundColor,
  String? message,
  Color? messageColor,
  int seconds,
) async {
  await Flushbar(
    duration: Duration(seconds: seconds),
    animationDuration: const Duration(milliseconds: 400),
    backgroundColor: backgroundColor,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.GROUNDED,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    message: message,
    messageColor: messageColor,
    messageSize: 16,
  ).show(context);
}


