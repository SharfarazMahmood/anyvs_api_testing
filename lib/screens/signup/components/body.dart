import 'package:anyvas_api_testing/screens/login/login_screen.dart';
import 'package:anyvas_api_testing/screens/signup/components/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:anyvas_api_testing/configs/size_config.dart';
import 'package:anyvas_api_testing/widgets/alter_login_signup.dart';
import '../../../widgets/social_icon.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: proportionateHeight(20),
            vertical: proportionateWidth(5),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Text(
                  "Registration",
                  style: TextStyle(
                    color: Color(0xff001a41),
                    fontSize: proportionateWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Text(
                  "Fill up the form \nor continue with social accounts.",
                  style: TextStyle(
                    color: Color(0xff001a41),
                    fontSize: proportionateWidth(15),
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                SocialIcon.icons,
                SizedBox(height: proportionateHeight(20)),
                AlterLoginSignup(
                  text: "Alredy a Member?",
                  route: LoginScreen.routeName,
                  routeText: "Login",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
