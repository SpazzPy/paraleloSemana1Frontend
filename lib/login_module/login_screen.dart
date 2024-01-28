import 'package:flutter/material.dart';
import 'package:paraleloapp1/goal_model/goal_screen.dart';
import 'package:paraleloapp1/register_module/register_screen.dart';
import 'loginViewModel.dart';
import 'package:paraleloapp1/data/data_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel viewModel = LoginViewModel(DataRepository());

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    bool loginSuccess = await viewModel.login(_usernameController.text, _passwordController.text);
    if (loginSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GoalsScreen()),
      );
    } else {
      // Handle login failure (e.g., show an error message)
      setState(() {}); // To update the UI with the error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (viewModel.errorMessage != null) Text(viewModel.errorMessage!, style: TextStyle(color: Colors.red)),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: viewModel.isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Login'),
              onPressed: viewModel.isLoading ? null : _login,
            ),
            ElevatedButton(
              child: Text("Don't have an account? Register"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
