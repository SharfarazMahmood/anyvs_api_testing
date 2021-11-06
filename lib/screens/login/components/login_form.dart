import 'package:anyvas_api_testing/configs/constants.dart';
import 'package:anyvas_api_testing/configs/size_config.dart';
import 'package:anyvas_api_testing/form_validation/error_dialog.dart';
import 'package:anyvas_api_testing/form_validation/form_validators.dart';
import 'package:anyvas_api_testing/models/http_exception.dart';
import 'package:anyvas_api_testing/providers/auth_provider.dart';
import 'package:anyvas_api_testing/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? password;
  String? confirmPassword;
  final _passwordController = TextEditingController();
  var _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      bool loginSuccess = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).login(
        email,
        password,
      );
      if (loginSuccess) {
        Navigator.of(context).pop();
      }
    } on HttpException catch (error) {
      ErrorDialog.showErrorDialog(context, error.toString());
    } catch (error) {
      print(error);
      ErrorDialog.showErrorDialog(
          context, 'Login Failed. Please try again later.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          emailOrPhoneField(),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          passwordField(),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          if (_isLoading)
            CircularProgressIndicator()
          else
            DefaultButton(
              text: "Login",
              onPressed: _submit,
            )
        ],
      ),
    );
  }

////////////email or phone form field

  TextFormField emailOrPhoneField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => email = value,
      validator: (value) => FormValidators.emailOrPhoneValidator(value),
      decoration: InputDecoration(
        labelText: "Email/Phone",
        hintText: "Enter your email/phone",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordController,
      onSaved: (value) => password = value,
      validator: (value) => FormValidators.passwordValidator(value),
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
