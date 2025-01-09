import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({
    super.key,
    required this.onPressed,
  });

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        visualDensity: VisualDensity.compact,
      ),
      onPressed: onPressed,
      iconSize: 30,
      icon: Icon(
        Iconsax.arrow_square_left_bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    super.key,
    required this.onPressed,
    this.addBorder = false,
    required this.backgroundColor,
    this.borderColor = Colors.black26,
    required this.child,
  });

  final Function() onPressed;
  final bool addBorder;
  final Color backgroundColor;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        fixedSize: const WidgetStatePropertyAll(Size.fromWidth(double.maxFinite)),
        elevation: const WidgetStatePropertyAll(3),
        shadowColor: WidgetStatePropertyAll(Theme.of(context).shadowColor),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        side: WidgetStatePropertyAll(
          addBorder
              ? BorderSide(color: borderColor, width: 0.5, style: BorderStyle.solid)
              : null,
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 20),
        ),
      ),
      child: child,
    );
  }
}

class ButtonInfo extends StatelessWidget {
  const ButtonInfo({
    super.key,
    required this.text,
    required this.color,
    required this.borderColor,
    required this.textColor,
    required this.smallText,
    required this.onTap,
  });

  final String text;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final bool smallText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(color),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 15),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              width: 1,
              color: borderColor,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: smallText ? 15 : 18,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonWithIcon extends StatelessWidget {
  const ButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.addBorder,
    required this.backgroundColor,
    required this.icon,
    required this.label,
  });

  final Function() onPressed;
  final bool addBorder;
  final Color backgroundColor;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      iconAlignment: IconAlignment.start,
      icon: icon,
      label: label,
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: const WidgetStatePropertyAll(Size.fromWidth(double.maxFinite)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        elevation: const WidgetStatePropertyAll(3),
        shadowColor: WidgetStatePropertyAll(Theme.of(context).shadowColor),
        side: WidgetStatePropertyAll(
          addBorder
              ? BorderSide(color: backgroundColor, width: 0.5, style: BorderStyle.solid)
              : null,
        ),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }
}
