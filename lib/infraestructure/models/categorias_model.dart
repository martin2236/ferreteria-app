// To parse this JSON data, do
//
//     final categoriasBack = categoriasBackFromJson(jsonString);

import 'dart:convert';

List<CategoriaDb> categoriaDbFromJson(String str) => List<CategoriaDb>.from(json.decode(str).map((x) => CategoriaDb.fromJson(x)));

String categoriaDbToJson(List<CategoriaDb> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriaDb {
    final int id;
    final String nombre;

    CategoriaDb({
        required this.id,
        required this.nombre,
    });

    factory CategoriaDb.fromJson(Map<String, dynamic> json) => CategoriaDb(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}
