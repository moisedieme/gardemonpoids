

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:garde_mon_poids/services/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _weightsKey = 'weights';

  Future<void> addWeight(String entry) async {
    List<String> weightEntries = await getWeights();
    weightEntries.add(entry);
    await _storage.write(key: _weightsKey, value: weightEntries.join(';'));
  }

  // Stocker un mot de passe
  Future<void> storePassword(String password) async {
    await _storage.write(key: 'password', value: password);
  }

  // Récupérer un mot de passe
  Future<String?> getPassword() async {
    return await _storage.read(key: 'password');
  }

  // Supprimer un mot de passe
  Future<void> deletePassword() async {
    await _storage.delete(key: 'password');
  }

  // Vérifier si un mot de passe est stocké
  Future<bool> hasPassword() async {
    return await _storage.containsKey(key: 'password');
  }

  // Stocker le poids
  Future<void> storeWeight(String weight) async {
    List<String> weights = await getWeights();
    weights.add(weight);
    await _storage.write(key: 'weights', value: jsonEncode(weights));
  }

  // Récupérer les poids
  Future<List<String>> getWeights() async {
    String? weights = await _storage.read(key: 'weights');
    if (weights == null) {
      return [];
    }
    return List<String>.from(jsonDecode(weights));
  }

}
