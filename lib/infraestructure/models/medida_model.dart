// To parse this JSON data, do
//
//     final medidasDb = medidasDbFromJson(jsonString);

import 'dart:convert';

List<MedidaDb> medidasDbFromJson(String str) => List<MedidaDb>.from(json.decode(str).map((x) => MedidaDb.fromJson(x)));

String medidasDbToJson(List<MedidaDb> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MedidaDb {
    final int id;
    final String nombre;
    final int updatedAt;
    final dynamic deletedAt;

    MedidaDb({
        required this.id,
        required this.nombre,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory MedidaDb.fromJson(Map<String, dynamic> json) => MedidaDb(
        id: json["id"],
        nombre: json["nombre"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"] != null ? json["deleted_at"] as int? : null, 
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
    };
}
