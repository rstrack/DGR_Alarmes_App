import 'package:DGR_alarmes/utils/normal_text.dart';
import 'package:flutter/material.dart';

showCustomSnackbar({
  required BuildContext context,
  required String text,
  Icon? icon,
  required Color color,
  SnackBarBehavior? behavior,
}) {
  Widget displaySnackBarNormal() {
    return NormalText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      maxLines: 3,
    );
  }

  Widget displaySnackBarWithIcon(Icon icon) {
    return Row(
      children: [
        icon,
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: NormalText(
            text: text,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: icon == null
          ? displaySnackBarNormal()
          : displaySnackBarWithIcon(icon),
      backgroundColor: color,
      behavior: behavior ?? SnackBarBehavior.fixed,
      duration: const Duration(seconds: 3),
      // margin: EdgeInsets.only(
      // bottom: 1.sh - 100.h, right: 8.w, left: 1.sw - 0.25.sw),
    ),
  );
}
