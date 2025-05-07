class Marca {
     int? id;
    final dynamic imagen;
    final String nombre;
    final int updatedAt;
    final dynamic deletedAt;

    Marca({
         this.id,
        required this.imagen,
        required this.nombre,
        required this.updatedAt,
        required this.deletedAt,
    });
}