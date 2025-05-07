

class Proveedor {
    final int? id;
    final String nombre;
    final String imagen;
    final String telefono;
    final String email;
    final List<int>? visita;
    final String color;
    final int updatedAt;
    final dynamic deletedAt;

    Proveedor({
        this.id,
        required this.nombre,
        required this.imagen,
        required this.telefono,
        required this.email,
        this.visita,
        required this.color,
        required this.updatedAt,
        required this.deletedAt,
    });
}