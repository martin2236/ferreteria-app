
import 'dart:convert';

List<CategoriaDb> categoriaDbFromJson(String str) => List<CategoriaDb>.from(json.decode(str).map((x) => CategoriaDb.fromJson(x)));

String categoriaDbToJson(List<CategoriaDb> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriaDb {
    final int id;
    final String imagen;
    final String nombre;
    final int updatedAt;
    final dynamic deletedAt;

    CategoriaDb({
        required this.id,
        required this.imagen,
        required this.nombre,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory CategoriaDb.fromJson(Map<String, dynamic> json) => CategoriaDb(
        id: json["id"],
        imagen: json["imagen"] ?? '',
        nombre: json["nombre"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"] != null ? json["deleted_at"] as int? : null, 
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "imagen": imagen,
        "nombre": nombre,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
    };
}
