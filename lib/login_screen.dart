//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:garde_mon_poids/services/secure_storage.dart';
import 'package:garde_mon_poids/page_accueil.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  String? _storedPassword;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPassword();
  }

  Future<void> _loadPassword() async {
    String? password = await _storage.read(key: 'password');
    setState(() {
      _storedPassword = password;
    });
  }

  void _login() {
    if (_storedPassword == null) {
      _storage.write(key: 'password', value: _passwordController.text);
      setState(() {
        _errorMessage = 'Mot de passe enregistré. Connectez-vous à nouveau.';
      });
    } else if (_storedPassword == _passwordController.text) {
      // Password is correct, proceed to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Mot de passe incorrect. Réessayez.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                hintText: 'Entrer le mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 5.0,
                  ),
                ),
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Connexion'),
            ),
          ],
        ),
      ),
    );
  }
}


