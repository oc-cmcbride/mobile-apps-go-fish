import 'package:flutter/material.dart';
import 'package:todo_app/pages/create_account_page.dart';
import 'package:todo_app/pages/sign_in_account_page.dart';

class OpeningPage extends StatelessWidget {
  const OpeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const CreateAccountPage()),
              );
            },
            child: const Text('Create Account'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const SignInAccountPage()),
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
