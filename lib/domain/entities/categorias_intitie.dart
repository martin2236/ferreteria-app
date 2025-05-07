
class Categoria {
    final int? id;
    final String imagen;
    final String nombre;
    final int updatedAt;
    final dynamic deletedAt;

    Categoria({
         this.id,
        required this.nombre,
        required this.imagen,
        required this.updatedAt,
        required this.deletedAt
    });
}