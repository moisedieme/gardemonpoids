// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:garde_mon_poids/Graphique.dart';
import 'package:garde_mon_poids/weight_entry_screen.dart';
//import 'package:garde_mon_poids/weight_entry_screen.dart';
//import 'package:garde_mon_poids/weight_chart.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Évolution du poids', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
            SizedBox(height: 20),
            Expanded(
              child: WeightChart(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeightEntryScreen()),
                );
              },
              child: Text('Entrer le Poids'),
            ),
          ],
        ),
      ),
    );
  }
}
