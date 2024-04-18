import 'package:flutter/material.dart';
import 'package:go_fish_game/controllers/auth_controller.dart';
import 'package:go_fish_game/utils/string_validator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInAccountPageState();
}

class _SignInAccountPageState extends State<SignInPage> {
    final _formKey = GlobalKey<FormState>();

    final _emailController = TextEditingController();
    final _pwController = TextEditingController();
    String _errorMessage = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: validateEmailAddress,
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            TextFormField(
              controller: _pwController,
              validator: validatePassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              child: const Text('Sign In'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var result = AuthController().signIn(
                      email: _emailController.text,
                      password: _pwController.text);
                  result.then((value) {
                    //value returns an error message and null if all is gucci
                    if (value == null){
                      Navigator.of(context).pop();
                    }
                    else {
                      setState(
                        () => _errorMessage = value,
                      );
                    }
                  });
                }
              },
            ),
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
