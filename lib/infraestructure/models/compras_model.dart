
import 'dart:convert';

CompraDb compraDbFromJson(String str) => CompraDb.fromJson(json.decode(str));

String compraDbToJson(CompraDb data) => json.encode(data.toJson());

class CompraDb {
    final int id;
    final String nombre;
    final int fecha;
    final DateTime updatedAt;
    final dynamic deletedAt;

    CompraDb({
        required this.id,
        required this.nombre,
        required this.fecha,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory CompraDb.fromJson(Map<String, dynamic> json) => CompraDb(
        id: json["id"],
        nombre: json["nombre"],
        fecha: json["fecha"],
        updatedAt: DateTime.fromMillisecondsSinceEpoch(json["updated_at"] * 1000), 
        deletedAt: json["deleted_at"] != null
            ? DateTime.fromMillisecondsSinceEpoch(json["deleted_at"] * 1000)
            : DateTime.now(), 
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "fecha": fecha,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
    };
}
