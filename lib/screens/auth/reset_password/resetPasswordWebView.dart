import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/screens/auth/reset_password/PasswordResetSuccess.dart';
import 'package:get/get.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

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
      Provider.of<AuthenticationProvider>(context, listen: false)
          .resetMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            splashColor: DailozColor.transparent,
            highlightColor: DailozColor.transparent,
            onTap: () => Navigator.pop(context),
            child: Container(
              height: height / 20,
              width: height / 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DailozColor.white,
                boxShadow: const [
                   BoxShadow(color: DailozColor.textgray, blurRadius: 5)
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: width / 56),
                child:const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: DailozColor.black,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Changer votre mot de passe'.tr,
          style: hsSemiBold.copyWith(fontSize: 18),
        ),
        backgroundColor: DailozColor.white,
        elevation: 0,
      ),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: height / 36),
                Center(
                  child: Image.asset(
                    'assets/images/ResetPassword.png',
                    height: height / 5,
                  ),
                ),
                SizedBox(height: height / 36),
                Text(
                  'Réinitialiser le mot de passe'.tr,
                  style: hsSemiBold.copyWith(
                    fontSize: 28,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height / 36),
                _buildPasswordTextField(
                  _oldPasswordController,
                  'Ancien mot de passe'.tr,
                  _isOldPasswordVisible,
                      (value) => setState(() => _isOldPasswordVisible = value),
                ),
                SizedBox(height: height / 36),
                _buildPasswordTextField(
                  _newPasswordController,
                  'Nouveau mot de passe'.tr,
                  _isNewPasswordVisible,
                      (value) => setState(() => _isNewPasswordVisible = value),
                ),
                if (_passwordErrorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      _passwordErrorMessage,
                      style: hsRegular.copyWith(color: DailozColor.lightred, fontSize: 12),
                    ),
                  ),
                SizedBox(height: height / 36),
                _buildPasswordTextField(
                  _confirmPasswordController,
                  'Confirmer le mot de passe'.tr,
                  _isConfirmPasswordVisible,
                      (value) => setState(() => _isConfirmPasswordVisible = value),
                ),
                if (authProvider.resMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      authProvider.resMessage,
                      style: hsRegular.copyWith(color: DailozColor.lightred, fontSize: 12),
                    ),
                  ),
                SizedBox(height: height / 26),
                ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handlePasswordReset,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    elevation: 5,
                  ),
                  child: authProvider.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'METTRE À JOUR LE MOT DE PASSE'.tr,
                    style: hsSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 16,
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
        style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: hsMedium.copyWith(color: DailozColor.textgray),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DailozColor.bgpurple),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DailozColor.appcolor),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.blue[800]
            ),
            onPressed: () => onVisibilityChanged(!isPasswordVisible),
          ),
        ),
      ),
    );
  }

  void _handlePasswordReset() async {
    if (_validatePassword(_newPasswordController.text)) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
        await authProvider.resetPassword(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
          context: context,
        );
        if (!authProvider.isAuthenticated) {
          Navigator.of(context)
              .pushReplacementNamed(PasswordResetSuccessScreen.id);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Les mots de passe ne correspondent pas'.tr),
            backgroundColor: DailozColor.lightred,
          ),
        );
      }
    } else {
      setState(() {
        _passwordErrorMessage =
            'Le mot de passe doit comporter au moins 6 caractères, inclure une lettre majuscule et un chiffre.'.tr;
      });
    }
  }

  bool _validatePassword(String password) {
    final RegExp passwordExp = RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$');
    return passwordExp.hasMatch(password);
  }
}