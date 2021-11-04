class User {
  String? email;
  String? phone;
  String? username;
  String? firstName;
  String? lastName;
  String? _token;

  String? get userToken {
    if (_token != null) {
      return _token;
    }
    return "no token found";
  }

  User({
    this.email,
    this.phone,
    this.username,
    this.firstName,
    this.lastName,
    String? token,
  }) {
    this._token = token;
  }
}
