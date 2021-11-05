import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anyvas_api_testing/providers/auth_provider.dart';
import 'package:anyvas_api_testing/screens/authentication/auth_screen.dart';

enum FilterOptions {
  Login,
  Favorites,
  All,
}

class DropDownMenu extends StatefulWidget {
  DropDownMenu({Key? key}) : super(key: key);

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String dropdownValue = "not selected";

  @override
  Widget build(BuildContext context) {
    final loggedIn = Provider.of<AuthProvider>(context).loggedIn;
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        setState(() {
          if (selectedValue == FilterOptions.Login) {
            Navigator.of(context).pushNamed(AuthScreen.routeName);
          }
        });
      },
      child: loggedIn
          ? Consumer<AuthProvider>(
              builder: (BuildContext context, user, Widget? child) {
                return Row(
                  children: <Widget>[
                    user.user == null
                        ? Text("  ")
                        : Text("${user.user!.firstName}"),
                    SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(Icons.account_circle),
                    ),
                  ],
                );
              },
              // child:
            )
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: Icon(Icons.more_vert),
            ),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: loggedIn
              ? Row(
                  children: <Widget>[
                    Icon(Icons.login),
                    SizedBox(width: 5),
                    Text("Logout"),
                  ],
                )
              : Row(
                  children: <Widget>[
                    Icon(Icons.login),
                    SizedBox(width: 5),
                    Text("Login"),
                  ],
                ),
          value: FilterOptions.Login,
        ),
      ],
    );
  }
}
