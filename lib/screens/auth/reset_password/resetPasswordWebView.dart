import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/screens/auth/reset_password/PasswordResetSuccess.dart';

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
      Provider.of<AuthenticationProvider>(context, listen: false).resetMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.grey.withOpacity(0.3),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'changer le mot de passe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/ResetPassword.png',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildPasswordTextField(
                  _oldPasswordController,
                  'Old Password',
                  _isOldPasswordVisible,
                      (value) => setState(() => _isOldPasswordVisible = value),
                ),
                const SizedBox(height: 20),
                _buildPasswordTextField(
                  _newPasswordController,
                  'New Password',
                  _isNewPasswordVisible,
                      (value) => setState(() => _isNewPasswordVisible = value),
                ),
                if (_passwordErrorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      _passwordErrorMessage,
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20),
                _buildPasswordTextField(
                  _confirmPasswordController,
                  'Confirm Password',
                  _isConfirmPasswordVisible,
                      (value) => setState(() => _isConfirmPasswordVisible = value),
                ),
                if (authProvider.resMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      authProvider.resMessage,
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handlePasswordReset,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    elevation: 5,
                  ),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'UPDATE PASSWORD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(
      TextEditingController controller,
      String label,
      bool isPasswordVisible,
      Function(bool) onVisibilityChanged,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue[900]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[100]!),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[900]!),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.blue[900],
            ),
            onPressed: () => onVisibilityChanged(!isPasswordVisible),
          ),
        ),
        style: TextStyle(color: Colors.blue[900]),
      ),
    );
  }

  void _handlePasswordReset() async {
    if (_validatePassword(_newPasswordController.text)) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
        await authProvider.resetPassword(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
          context: context,
        );
        if (!authProvider.isAuthenticated) {
          Navigator.of(context).pushReplacementNamed(PasswordResetSuccessScreen.id);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    } else {
      setState(() {
        _passwordErrorMessage =
        'Password must be at least 6 characters long, include one uppercase letter and one number.';
      });
    }
  }

  bool _validatePassword(String password) {
    final RegExp passwordExp = RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$');
    return passwordExp.hasMatch(password);
  }
}