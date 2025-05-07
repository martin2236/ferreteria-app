
import 'dart:convert';

List<MarcaDb> marcaDbFromJson(String str) => List<MarcaDb>.from(json.decode(str).map((x) => MarcaDb.fromJson(x)));

String marcaDbToJson(List<MarcaDb> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarcaDb {
    final int id;
    final dynamic imagen;
    final String nombre;
    final int updatedAt;
    final dynamic deletedAt;

    MarcaDb({
        required this.id,
        required this.imagen,
        required this.nombre,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory MarcaDb.fromJson(Map<String, dynamic> json) => MarcaDb(
        id: json["id"],
        imagen: json["imagen"],
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
