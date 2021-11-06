import 'package:anyvas_api_testing/configs/constants.dart';
import 'package:anyvas_api_testing/configs/size_config.dart';
import 'package:anyvas_api_testing/screens/signup/signup_screen.dart';
import 'package:anyvas_api_testing/widgets/alter_login_signup.dart';
import 'package:anyvas_api_testing/widgets/social_icon.dart';
import 'package:flutter/material.dart';

import 'login_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: proportionateWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Welcome", style: headingStyle),
                Text(
                  "Login with email/phone & password \nor Continue with social account",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                LoginForm(),
                SocialIcon.icons,
                // SizedBox(height: proportionateHeight(20)),
                AlterLoginSignup(
                  text: "Don't have an account?",
                  route: SignupScreen.routeName,
                  routeText: "Sign up",
                ),
                SizedBox(height: proportionateHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
