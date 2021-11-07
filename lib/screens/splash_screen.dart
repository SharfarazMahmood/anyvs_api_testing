import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../configs/size_config.dart';
import '../providers/auth_provider.dart';
import '../screens/products_overview_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    // _navigateToHome();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var auth = Provider.of<AuthProvider>(context, listen: false);
    auth.autoLogin();
    if (auth.loggedIn) {
    } else if (!auth.loggedIn) {}
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProductsOverviewScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const <Widget>[
        Expanded(
          child: Image(
            image: AssetImage('assets/images/logo/anyvas-icon-Logo.png'),
          ),
        ),
        Text(
          "Anyvas",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xffe99800),
          ),
        ),
      ],
    );
  }
}
