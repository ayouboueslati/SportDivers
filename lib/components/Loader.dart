import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Menu/MenuPage.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/screens/auth/login_screen.dart';

class CustomLoaderPage extends StatefulWidget {
  //static String id = 'Custom_Loader_Page';
  const CustomLoaderPage({Key? key}) : super(key: key);

  @override
  _CustomLoaderPageState createState() => _CustomLoaderPageState();
}

class _CustomLoaderPageState extends State<CustomLoaderPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 4), () {
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (_) => LoginScreen(onLoginPressed: () {
      //       Navigator.pushReplacementNamed(context, HomePage.id);
      //     }),
      //     )
      // );

      _checkLoginStatus();
    });

  }
  void _checkLoginStatus() async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    bool isLoggedIn = await authProvider.isUserLoggedIn();

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(role: authProvider.accountType, userData: authProvider.userData)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen(onLoginPressed: () {})),
      );
    }
  }
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/loader/loader.gif',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
