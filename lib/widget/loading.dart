import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    useSafeArea: true,
    barrierDismissible: false,
    barrierColor: Theme.of(context).shadowColor,
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
    builder: (context) {
      return Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 135),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.fallingDot(
                color: Theme.of(context).primaryColor,
                size: 75,
              ),
              const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context); // Menutup dialog loading
  }
}
