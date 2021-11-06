import 'package:anyvas_api_testing/configs/constants.dart';
import 'package:anyvas_api_testing/configs/size_config.dart';
import 'package:flutter/material.dart';

class AlterLoginSignup extends StatelessWidget {
  final String? text;
  final String? route;
  final String? routeText;
  const AlterLoginSignup({
    Key? key,
    this.text,
    this.route,
    this.routeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$text ",
          style: TextStyle(fontSize: proportionateWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, route!),
          child: Text(
            "$routeText",
            style: TextStyle(
                fontSize: proportionateWidth(16), color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
