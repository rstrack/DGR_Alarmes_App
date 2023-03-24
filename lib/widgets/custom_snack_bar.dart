import 'package:flutter/material.dart';

showCustomSnackbar({
  required BuildContext context,
  required String text,
  Icon? icon,
  Color? backgroundColor,
  Color? textColor,
  SnackBarBehavior? behavior,
}) {
  Widget displayDefaultSnackBar() {
    return Text(
      text,
      maxLines: 3,
      softWrap: false,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget displaySnackBarWithIcon(Icon icon) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 3,
            softWrap: false,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: icon == null
          ? displayDefaultSnackBar()
          : displaySnackBarWithIcon(icon),
      backgroundColor: backgroundColor,
      behavior: behavior ?? SnackBarBehavior.fixed,
      duration: const Duration(seconds: 3),
      // margin: EdgeInsets.only(
      // bottom: 1.sh - 100.h, right: 8.w, left: 1.sw - 0.25.sw),
    ),
  );
}
