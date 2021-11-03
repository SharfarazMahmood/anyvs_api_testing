import 'package:anyvas_api_testing/screens/auth_screen.dart';
import 'package:flutter/material.dart';

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
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        setState(() {
          if (selectedValue == FilterOptions.Login) {
            // Navigator.of(context).pushNamed(AuthScreen.routeName);
          }
        });
      },
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Row(
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
