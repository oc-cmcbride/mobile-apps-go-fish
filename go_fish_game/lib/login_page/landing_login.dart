import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_fish_game/accounts/create_account_page.dart';
import 'package:go_fish_game/login_page/sign_in_page.dart';
import 'package:go_fish_game/main_menu/main_menu_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../style/palette.dart';



class LandingLogin extends StatelessWidget {
  const LandingLogin({Key? key});

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {

      if (googleUser != null) {
        // ignore: use_build_context_synchronously
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

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Go Fish!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 55,
                  height: 1,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => signInWithGoogle(context),
              child: const Text('Sign In with Google'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const CreateAccountPage()),
            //     );
            //   },
            //   child: const Text('Create Account'),
            // ),
            // //might change this to have the two fields here
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const SignInPage()),
            //     );
            //   },
            //   child: const Text('Sign In'),
            // ),
          ],
        ),
      ),
    );
  }
}