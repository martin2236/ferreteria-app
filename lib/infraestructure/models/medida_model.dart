// To parse this JSON data, do
//
//     final categoriasBack = categoriasBackFromJson(jsonString);

import 'dart:convert';

List<MedidaDb> medidaDbFromJson(String str) => List<MedidaDb>.from(json.decode(str).map((x) => MedidaDb.fromJson(x)));

String medidaDbToJson(List<MedidaDb> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MedidaDb {
    final int id;
    final String nombre;

    MedidaDb({
        required this.id,
        required this.nombre,
    });

    factory MedidaDb.fromJson(Map<String, dynamic> json) => MedidaDb(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}
