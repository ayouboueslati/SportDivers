import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_icons.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = 'forgot_password_screen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _requestPasswordReset() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final authProvider =
      Provider.of<AuthenticationProvider>(context, listen: false);

      try {
        final message = await authProvider.requestPasswordReset(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de l\'envoi du lien de réinitialisation : $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width/36, vertical: height/36),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height/12),
              Text(
                "Forgot_password".tr,
                style: hsSemiBold.copyWith(fontSize: 36, color: DailozColor.appcolor),
              ),
              SizedBox(height: height/16),
              TextFormField(
                controller: _emailController,
                style: hsMedium.copyWith(fontSize: 16, color: DailozColor.textgray),
                decoration: InputDecoration(
                    hintStyle: hsMedium.copyWith(fontSize: 16, color: DailozColor.textgray),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        DailozSvgimage.icemail,
                        height: height/36,
                        colorFilter: const ColorFilter.mode(DailozColor.textgray, BlendMode.srcIn),
                      ),
                    ),
                    hintText: "Email ID or Username",
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: DailozColor.greyy)
                    )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre e-mail';
                  }
                  bool isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value);
                  if (!isValid) {
                    return 'Entrez une adresse e-mail valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: height/20),
              InkWell(
                splashColor: DailozColor.transparent,
                highlightColor: DailozColor.transparent,
                onTap: _requestPasswordReset,
                child: Container(
                  width: width/1,
                  height: height/15,
                  decoration: BoxDecoration(
                      color: DailozColor.appcolor,
                      borderRadius: BorderRadius.circular(14)
                  ),
                  child: Center(
                    child: Text(
                      "Send".tr,
                      style: hsSemiBold.copyWith(fontSize: 16, color: DailozColor.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height/20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Retour à la connexion',
                    style: hsMedium.copyWith(
                      color: DailozColor.appcolor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}