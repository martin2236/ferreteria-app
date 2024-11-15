


import '../../domain/entities/producto_entitie.dart';
import '../infraestructure.dart';

class MapperProducto{
  static Producto productoAEntidad( ProductoDb productoDb){
    return Producto(
      id: productoDb.id,
      nombre: productoDb.nombre, 
      imagen: productoDb.imagen, 
      categoria: productoDb.categoria, 
      cantidad: productoDb.cantidad, 
      unidad: productoDb.unidad, 
     precio: productoDb.precio,
      estado: productoDb.estado, 
       updatedAt: productoDb.updatedAt,
      deletedAt:  productoDb.deletedAt,
      );
      }
  }