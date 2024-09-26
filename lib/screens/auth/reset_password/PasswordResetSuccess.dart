import 'package:flutter/material.dart';
import 'package:sportdivers/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart'; // Import your AuthProvider

class PasswordResetSuccessScreen extends StatelessWidget {
  static String id = 'reset_success';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            const Text(
              'Mot de passe réinitialisé',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Votre mot de passe a été réinitialisé avec succès',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Text(
              'après avoir modifié votre mot de passe, vous devez maintenant vous reconnecter à l application',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await authProvider.logoutUser(); // Log out the user
                Navigator.pushReplacementNamed(
                    context, LoginScreen.id); // Navigate to the login screen
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
