import 'package:flutter/material.dart';
import 'package:go_fish_game/accounts/create_account_page.dart';
import 'package:go_fish_game/login_page/sign_in_page.dart';
import 'package:go_fish_game/main_menu/main_menu_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LandingLogin extends StatelessWidget {
  const LandingLogin({Key? key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      //need to handle signing in and directing the user to the main application
      if (googleUser != null) {
        // TODO: Perform additional authentication steps or handle the signed-in user.
        // For example, you can pass the user data to another page and display user information.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainMenuScreen()),
        );
      } else {
        // User canceled the Google sign-in flow.
        // You can show an error message or perform any desired action.
      }
    } catch (error) {
      // Handle sign-in errors.
      // You can show an error message or perform any desired action.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _handleGoogleSignIn(context),
              child: const Text('Sign In with Google'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                );
              },
              child: const Text('Create Account'),
            ),
            //might change this to have the two fields here
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}