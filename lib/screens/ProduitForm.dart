import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/Produit.dart';
import 'package:http/http.dart' as http;

class ProduitForm extends StatefulWidget {
  const ProduitForm({super.key});

  @override
  State<ProduitForm> createState() => _ProduitFormState();
}

class _ProduitFormState extends State<ProduitForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  String? _selectedType;
  List<String> boissons = ["Bière", "Sucré"];



  // URL de l'API
  final String _apiUrl = 'https://192.168.28.187:8000/api/produits';

  // Méthode pour envoyer les données à l'API
  Future<void> _enregistrerProduit() async {
    const CircularProgressIndicator();
    if (!_formKey.currentState!.validate()) return;

    // Préparer les données
    final produitData = {
      "nom": _nomController.text.trim(),
      "quantite": int.parse(_quantiteController.text.trim()),
      "type": _selectedType,
    };

    try {
      // Effectuer la requête POST
      final response = await http.post(
        Uri.parse(_apiUrl),
        body: jsonEncode(produitData),
      );

      // Vérifier la réponse
      if (response.statusCode == 201) {
        // Réinitialiser le formulaire
        _formKey.currentState!.reset();
        _nomController.clear();
        _quantiteController.clear();
        setState(() {
          _selectedType = null;
        });

        // Message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produit enregistré avec succès !")),
        );
      } else {
        // Gestion des erreurs de l'API
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${responseData['message']}")),
        );
      }
    } catch (error) {
      // Gestion des erreurs réseau
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Une erreur est survenue. Vérifiez votre connexion.")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enregistrer un Produit"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Formulaire d'enregistrement",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              const SizedBox(height: 24),

              const Text(
                "Depot : DouceBoisson",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              const SizedBox(height: 24),
              // Champ pour le nom
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: "Nom du produit",
                  hintText: "Ex : Chocolat",
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un nom de produit.";
                  }
                  if (value.length < 3) {
                    return "Le nom doit contenir au moins 3 caractères.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ pour la quantité
              TextFormField(
                controller: _quantiteController,
                decoration: InputDecoration(
                  labelText: "Quantité",
                  hintText: "Ex : 10",
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer une quantité.";
                  }
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null || parsedValue <= 0) {
                    return "Veuillez entrer une quantité valide (nombre positif).";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ select pour le type
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: "Type de boisson",
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                items: boissons.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Veuillez sélectionner un type de produit.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Bouton d'enregistrement
              SizedBox(
                width: double.infinity, // Largeur complète
                child: ElevatedButton(
                  onPressed:  () async {
                    if (_formKey.currentState!.validate()) {
                      // final produit = Produit(
                      //   nom: _nomController.text.trim(),
                      //   quantite: int.parse(_quantiteController.text.trim()),
                      //   type: _selectedType!,
                      // );
                     await _enregistrerProduit();
                      // Convertir l'objet Produit en JSON
                      //final produitJson = produitToJson(produit);

                      // Afficher les données dans la console (ou enregistrer dans une base de données)
                      //print("Produit enregistré : $produitJson");

                      // Réinitialiser le formulaire
                      _formKey.currentState!.reset();
                      _nomController.clear();
                      _quantiteController.clear();
                      setState(() {
                        _selectedType = null;
                      });

                      // Afficher un message de confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Produit enregistré avec succès !"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18), // Couleur du texte
                    elevation: 5, // Ombre
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Forme rectangulaire
                    ),
                  ),
                  child: const Text("Enregistrer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _quantiteController.dispose();
    super.dispose();
  }
}
