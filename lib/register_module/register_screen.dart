import 'package:flutter/material.dart';
import 'package:paraleloapp1/data/data_repository.dart';
import 'registerViewModel.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterViewModel viewModel = RegisterViewModel(DataRepository());

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _errorMessage;

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }
    _errorMessage = null;
    await viewModel.register(_usernameController.text, _passwordController.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (viewModel.errorMessage != null) Text(viewModel.errorMessage!, style: TextStyle(color: Colors.red)),
            if (viewModel.successMessage != null) Text(viewModel.successMessage!, style: TextStyle(color: Colors.green)),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: viewModel.isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Register'),
              onPressed: viewModel.isLoading ? null : _register,
            ),
          ],
        ),
      ),
    );
  }
}
