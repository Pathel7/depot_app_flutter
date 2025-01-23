import 'dart:convert';

Produit produitFromJson(String str) => Produit.fromJson(json.decode(str));

String produitToJson(Produit data) => json.encode(data.toJson());

class Produit {
  String nom;
  int quantite;
  String type;

  Produit({
    required this.nom,
    required this.quantite,
    required this.type,
  });

  factory Produit.fromJson(Map<String, dynamic> json) => Produit(
    nom: json["nom"],
    quantite: json["quantite"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "nom": nom,
    "quantite": quantite,
    "type": type,
  };
}
