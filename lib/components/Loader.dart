import 'package:flutter/material.dart';

class CustomLoaderPage extends StatelessWidget {
  const CustomLoaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset( 'assets/loader/loader.gif',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}