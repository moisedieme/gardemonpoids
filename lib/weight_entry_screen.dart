// lib/weight_entry_screen.dart

import 'package:flutter/material.dart';
import 'package:garde_mon_poids/page_accueil.dart';
import 'package:garde_mon_poids/services/secure_storage.dart';
//import 'package:garde_mon_poids/services/secure_storage.dart';
//import 'package:garde_mon_poids/page_accueil.dart';

class WeightEntryScreen extends StatefulWidget {
  @override
  _WeightEntryScreenState createState() => _WeightEntryScreenState();
}

class _WeightEntryScreenState extends State<WeightEntryScreen> {
  final TextEditingController _weightController = TextEditingController();
  final SecureStorage _secureStorage = SecureStorage();
  String _message = '';

  void _saveWeight() async {
    String weight = _weightController.text;
    if (weight.isNotEmpty) {
      DateTime now = DateTime.now();
      String weightEntry = '${now.toIso8601String()}|$weight';
      await _secureStorage.storeWeight(weightEntry);
      setState(() {
        _message = 'Poids enregistré: $weight kg';
      });
      _weightController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        _message = 'Veuillez entrer un poids valide';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrée du Poids'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Poids (kg)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 5.0,
                  ),
                ),


                errorText: _message.isNotEmpty ? _message : null,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveWeight,
              child: Text('Enregistrer le Poids'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
