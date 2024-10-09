import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showReusableToast({
  required BuildContext context,
  required String message,
  Color backgroundColor = Colors.greenAccent,
  Color textColor = Colors.white,
  IconData icon = Icons.check_circle,
  Duration duration = const Duration(seconds: 3),
}) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: backgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: textColor),
        SizedBox(width: 12.0),
        Flexible(
          child: Text(
            message,
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: duration,
  );
}
// showReusableToast(
// context: context,
// message: 'Rapport soumis avec succès',
// duration: Duration(seconds: 5),
// );