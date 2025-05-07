class Producto {
  int? id;
  final String nombre;
  final String imagen;
  final int categoria;
  final int marca;
  final int medida;
  final int proveedor;
  final String cantidad;
  final String unidad;
  final double precio;
  final int estado;
  final int? updatedAt;  
  final int? deletedAt;

  Producto({
    this.id,
    required this.nombre,
    required this.imagen,
    required this.categoria,
    required this.marca,
    required this.medida,
    required this.proveedor,
    required this.cantidad,
    required this.unidad,
    required this.precio,
    required this.estado,
    required this.updatedAt,  
    this.deletedAt,
  }) ;
}