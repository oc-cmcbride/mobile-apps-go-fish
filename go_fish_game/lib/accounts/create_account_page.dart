import 'package:flutter/material.dart';
import 'package:go_fish_game/controllers/auth_controller.dart';
import 'package:go_fish_game/utils/string_validator.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  String _errorMessage = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
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
              child: const Text('Create Account'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var result = AuthController().createAccount(email: _emailController.text, password: _pwController.text);
                  result.then((value) {
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

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }
}
