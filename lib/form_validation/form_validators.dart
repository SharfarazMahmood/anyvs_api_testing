class FormValidators {
    static String? emailorPhoneValidator(String? value) {
    if (value!.isEmpty) {
      return "Enter a password";
    }
    if (value.isEmpty || value.length < 5) {
      return 'Password is too short!';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "Enter a password";
    }
    if (value.isEmpty || value.length < 5) {
      return 'Password is too short!';
    }
    return null;
  }
}
