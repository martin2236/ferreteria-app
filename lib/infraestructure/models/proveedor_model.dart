// To parse this JSON data, do
//
//     final proveedoresDb = proveedoresDbFromJson(jsonString);


import 'dart:convert';

List<ProveedoresDb> proveedoresDbFromJson(String str) => List<ProveedoresDb>.from(json.decode(str).map((x) => ProveedoresDb.fromJson(x)));

String proveedoresDbToJson(List<ProveedoresDb> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProveedoresDb {
    final int id;
    final String nombre;
    final String imagen;
    final String telefono;
    final List<int>? visita;
    final String color;
    final String email;
    final int updatedAt;
    final dynamic deletedAt;

    ProveedoresDb({
        required this.id,
        required this.nombre,
        required this.imagen,
        required this.telefono,
        this.visita,
        required this.color,
        required this.email,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory ProveedoresDb.fromJson(Map<String, dynamic> json) => ProveedoresDb(
        id: json["id"],
        nombre: json["nombre"],
        imagen: json["imagen"] ?? '',
        telefono: json["telefono"] ?? '',
        visita: json["visita"] != null ? [json["visita"]] : [],
        color: json["color"] ?? '',
        email: json["email"] ?? '',
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "imagen": imagen,
        "telefono": telefono,
        "visita": visita,
        "color": color,
        "email": email,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
    };
}
