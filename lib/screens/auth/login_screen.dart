import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sportdivers/Menu/MenuPage.dart';
import 'package:sportdivers/Menu/MenuPageCoach.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/screens/auth/reset_password/forgotpassword.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLoginPressed});

  static String id = 'login_screen';
  final VoidCallback onLoginPressed;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    //_checkAuthState();
  }

  Future<void> _loadSavedCredentials() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final credentials = await authProvider.loadUserCredentials();
    if (credentials['email'] != null && credentials['password'] != null) {
      _emailController.text = credentials['email']!;
      _passwordController.text = credentials['password']!;
      setState(() {
        _rememberMe = true;
      });
    }
  }

  Future<void> _checkAuthState() async {
    final authProvider =
    Provider.of<AuthenticationProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            role: authProvider.accountType,
            userData: authProvider.userData,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _navigateBasedOnRole(BuildContext context, String role) {
    if (role.toLowerCase() == 'STUDENT') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(role: role)),
      );
    } else if (role.toLowerCase() == 'TEACHER') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageCoach(role: role)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unknown user role: $role')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          return LoadingOverlay(
            isLoading: authProvider.isLoading,
            child: GestureDetector(
              onTap: _dismissKeyboard,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width / 36, vertical: height / 36),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height / 8),
                      Center(
                        child: Image.asset(
                          'assets/images/SportDivers.png',
                          height: height / 3.5,
                        ),
                      ),
                      //SizedBox(height: height/16),
                      //Text("Login", style: hsSemiBold.copyWith(fontSize: 36, color: DailozColor.appcolor)),
                      SizedBox(height: height / 16),
                      TextField(
                        controller: _emailController,
                        style: hsMedium.copyWith(
                            fontSize: 16, color: DailozColor.textgray),
                        decoration: InputDecoration(
                            hintStyle: hsMedium.copyWith(
                                fontSize: 16, color: DailozColor.textgray),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(DailozSvgimage.icemail,
                                  height: height / 36,
                                  colorFilter: const ColorFilter.mode(
                                      DailozColor.textgray, BlendMode.srcIn)),
                            ),
                            hintText: "CIN",
                            border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: DailozColor.greyy))),
                      ),
                      SizedBox(height: height / 30),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        style: hsMedium.copyWith(
                            fontSize: 16, color: DailozColor.textgray),
                        decoration: InputDecoration(
                            hintStyle: hsMedium.copyWith(
                                fontSize: 16, color: DailozColor.textgray),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(DailozSvgimage.iclock,
                                  height: height / 36,
                                  colorFilter: const ColorFilter.mode(
                                      DailozColor.textgray, BlendMode.srcIn)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureText = !_obscureText),
                              color: DailozColor.textgray,
                            ),
                            hintText: "Mot de passe",
                            border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: DailozColor.greyy))),
                      ),
                      SizedBox(height: height / 45),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) =>
                                    setState(() => _rememberMe = value!),
                                activeColor: DailozColor.appcolor,
                              ),
                              Text("Se souvenir de moi",
                                  style: hsRegular.copyWith(
                                      fontSize: 12,
                                      color: DailozColor.textgray)),
                            ],
                          ),
                          InkWell(
                            splashColor: DailozColor.transparent,
                            highlightColor: DailozColor.transparent,
                            onTap: () => Navigator.pushNamed(
                                context, ForgotPasswordScreen.id),
                            child: Text("Mot de passe oublié ?",
                                style: hsRegular.copyWith(
                                    fontSize: 14, color: Colors.blue[800])),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 20),
                      InkWell(
                        splashColor: DailozColor.transparent,
                        highlightColor: DailozColor.transparent,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await authProvider.loginUser(
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context,
                              rememberMe: _rememberMe,
                            );
                            if (authProvider.isAuthenticated) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    role: authProvider.accountType,
                                    userData: authProvider.userData,
                                  ),
                                ),
                              );
                            } else {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text(authProvider.resMessage)),
                              // );
                              Fluttertoast.showToast(
                                msg:
                                    "La connexion a échoué !\n E-mail ou mot de passe incorrect.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red[400],
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }
                        },
                        child: Container(
                          width: width / 1,
                          height: height / 15,
                          decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(14)),
                          child: Center(
                              child: Text("CONNEXION",
                                  style: hsSemiBold.copyWith(
                                      fontSize: 16, color: DailozColor.white))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
