// import 'package:flutter/material.dart';
// import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:footballproject/bottomNavBar.dart';
// import 'package:footballproject/screens/auth/otp/forgotpassword.dart';
// import 'package:provider/provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key, required this.onLoginPressed}) : super(key: key);

//   static String id = 'login_screen';
//   final VoidCallback onLoginPressed;

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscureText = true;

//   final _formKey = GlobalKey<FormState>(); // Form key for validation

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Consumer<AuthenticationProvider>(
//         builder: (context, authProvider, child) {
//           return LoadingOverlay(
//             isLoading: authProvider.isLoading,
//             child: Stack(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 30),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       colors: [
//                         Colors.blue.shade900,
//                         Colors.blue.shade600,
//                         Colors.blue.shade300,
//                       ],
//                     ),
//                   ),
//                   child: const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 120,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               "Login",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 40),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               "Welcome Back",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 20),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned.fill(
//                   top: MediaQuery.of(context).size.height * 0.35,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(60),
//                         topRight: Radius.circular(60),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(30),
//                       child: SingleChildScrollView(
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             children: <Widget>[
//                               const SizedBox(
//                                 height: 60,
//                               ),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: Color.fromRGBO(225, 95, 27, .3),
//                                       blurRadius: 20,
//                                       offset: Offset(0, 10),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   children: <Widget>[
//                                     Container(
//                                       padding: const EdgeInsets.all(10),
//                                       decoration: const BoxDecoration(
//                                         border: Border(
//                                           bottom:
//                                               BorderSide(color: Colors.grey),
//                                         ),
//                                       ),
//                                       child: TextFormField(
//                                         controller: _emailController,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Please enter your email';
//                                           }
//                                           // Email format validation
//                                           bool isValid = RegExp(
//                                                   r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                                               .hasMatch(value);
//                                           if (!isValid) {
//                                             return 'Enter a valid email address';
//                                           }
//                                           return null;
//                                         },
//                                         decoration: const InputDecoration(
//                                           hintText: "Email",
//                                           hintStyle:
//                                               TextStyle(color: Colors.grey),
//                                           border: InputBorder.none,
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.all(10),
//                                       decoration: const BoxDecoration(
//                                         border: Border(
//                                           bottom:
//                                               BorderSide(color: Colors.grey),
//                                         ),
//                                       ),
//                                       child: TextFormField(
//                                         controller: _passwordController,
//                                         obscureText: _obscureText,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Please enter your password';
//                                           }
//                                           // Add more password validation if needed
//                                           return null;
//                                         },
//                                         decoration: const InputDecoration(
//                                           hintText: "Password",
//                                           hintStyle:
//                                               TextStyle(color: Colors.grey),
//                                           border: InputBorder.none,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 40,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.pushNamed(
//                                       context, ForgotPasswordScreen.id);
//                                 },
//                                 child: const Text(
//                                   "Forgot Password?",
//                                   style: TextStyle(color: Colors.grey),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 40,
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   if (_formKey.currentState!.validate()) {
//                                     // If all fields are valid, proceed with login
//                                     await authProvider.loginUser(
//                                       email: _emailController.text,
//                                       password: _passwordController.text,
//                                     );
//                                     if (authProvider.isAuthenticated) {
//                                       Navigator.pushReplacementNamed(
//                                           context, Bottomnavbar.id);
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         SnackBar(
//                                           content:
//                                               Text(authProvider.resMessage),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                 },
//                                 child: Container(
//                                   height: 50,
//                                   margin: const EdgeInsets.symmetric(
//                                       horizontal: 50),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(50),
//                                     color: Colors.blue,
//                                   ),
//                                   child: const Center(
//                                     child: Text(
//                                       "Login",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:footballproject/bottomNavBar.dart';
import 'package:footballproject/screens/auth/otp/forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.onLoginPressed}) : super(key: key);

  static String id = 'login_screen';
  final VoidCallback onLoginPressed;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email;
  late String _password;
  bool _saving = false;
  bool _obscureText = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents keyboard overflow
      body: LoadingOverlay(
        isLoading: _saving,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade600,
                    Colors.blue.shade300
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 120, // Increased height to push content down
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Welcome Back",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height *
                  0.35, // Adjusted top value
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    _email = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: TextField(
                                  obscureText: _obscureText,
                                  onChanged: (value) {
                                    _password = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ForgotPasswordScreen.id);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              _saving = true;
                            });
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              _saving = false;
                            });
                            Navigator.pushReplacementNamed(
                                context, Bottomnavbar.id);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
