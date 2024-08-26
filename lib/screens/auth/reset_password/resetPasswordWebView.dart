import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/screens/auth/reset_password/PasswordResetSuccess.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String id = 'reset_pass';
  final String token;

  const ResetPasswordScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String _passwordErrorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      authProvider.resetMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Image.asset(
                'assets/images/password.png',
                height: 120,
              ),
            ),
            const SizedBox(height: 30),
            _buildPasswordTextField(
                _oldPasswordController, 'Old Password', _isOldPasswordVisible,
                (value) {
              setState(() {
                _isOldPasswordVisible = value;
              });
            }),
            const SizedBox(height: 20),
            _buildPasswordTextField(
                _newPasswordController, 'New Password', _isNewPasswordVisible,
                (value) {
              setState(() {
                _isNewPasswordVisible = value;
              });
            }),
            if (_passwordErrorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _passwordErrorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            _buildPasswordTextField(_confirmPasswordController,
                'Confirm Password', _isConfirmPasswordVisible, (value) {
              setState(() {
                _isConfirmPasswordVisible = value;
              });
            }),
            if (authProvider.resMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  authProvider.resMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      if (_validatePassword(_newPasswordController.text)) {
                        if (_newPasswordController.text ==
                            _confirmPasswordController.text) {
                          await authProvider.resetPassword(
                            oldPassword: _oldPasswordController.text,
                            newPassword: _newPasswordController.text,
                            context: context,
                          );
                          if (!authProvider.isAuthenticated) {
                            Navigator.of(context).pushReplacementNamed(
                                PasswordResetSuccessScreen.id);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Passwords do not match')),
                          );
                        }
                      } else {
                        setState(() {
                          _passwordErrorMessage =
                              'Password must be at least 6 characters long, include one uppercase letter and one number.';
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: authProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('UPDATE PASSWORD',
                      style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(TextEditingController controller, String label,
      bool isPasswordVisible, Function(bool) onVisibilityChanged) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            onVisibilityChanged(!isPasswordVisible);
          },
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  bool _validatePassword(String password) {
    final RegExp passwordExp = RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$');
    return passwordExp.hasMatch(password);
  }
}
