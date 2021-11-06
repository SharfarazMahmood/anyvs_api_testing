import 'package:anyvas_api_testing/configs/constants.dart';
import 'package:anyvas_api_testing/configs/size_config.dart';
import 'package:anyvas_api_testing/form_validation/error_dialog.dart';
import 'package:anyvas_api_testing/form_validation/form_validators.dart';
import 'package:anyvas_api_testing/models/http_exception.dart';
import 'package:anyvas_api_testing/providers/auth_provider.dart';
import 'package:anyvas_api_testing/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
      // bool loginSuccess = await Provider.of<AuthProvider>(
      //   context,
      //   listen: false,
      // ).login(
      //   email,
      //   password,
      // );
      // if (loginSuccess) {
      //   Navigator.of(context).pop();
      // }
    } on HttpException catch (error) {
      ErrorDialog.showErrorDialog(context, error.toString());
    } catch (error) {
      print(error);
      ErrorDialog.showErrorDialog(
          context, 'Registration Failed. Please try again later.');
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
          firstNameField(),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          lastNameField(),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          emailOrPhoneField(),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          passwordField(),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          confirmPasswordField(),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          phoneNumberField(),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          if (_isLoading)
            CircularProgressIndicator()
          else
            DefaultButton(
              text: "Sign up",
              onPressed: _submit,
            )
        ],
      ),
    );
  }

  //////////////////////////////////////
  //////////// first name field
  TextFormField firstNameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (value) => email = value,
      validator: (value) => FormValidators.nameValidator(value),
      decoration: InputDecoration(
        labelText: "First name",
        hintText: "Enter a first name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  //////////// last name field
  TextFormField lastNameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (value) => email = value,
      validator: (value) => FormValidators.nameValidator(value),
      decoration: InputDecoration(
        labelText: "Last name",
        hintText: "Enter a last name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  ////////////email or phone form field
  TextFormField emailOrPhoneField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => email = value,
      validator: (value) => FormValidators.emailValidator(value),
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter an email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  /////// phone field
  TextFormField phoneNumberField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (value) => password = value,
      validator: (value) => FormValidators.phoneValidator(value),
      decoration: InputDecoration(
        prefix: 
        Container(
          child: Text('+88', style: TextStyle(color: Colors.black)),
        ),
        labelText: "Phone",
        hintText: "Enter a phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

//////////// password form field
  TextFormField passwordField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordController,
      onSaved: (value) => password = value,
      validator: (value) => FormValidators.passwordValidator(value),
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter a password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  /////// confirm password field
  TextFormField confirmPasswordField() {
    return TextFormField(
      obscureText: true,
      onSaved: (value) => password = value,
      validator: (value) => FormValidators.confirmPasswordValidator(value),
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

///
///