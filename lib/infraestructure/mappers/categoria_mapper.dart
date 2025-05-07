

import 'package:control_app/domain/entities/categorias_intitie.dart';
import 'package:control_app/infraestructure/models/categorias_model.dart';

class MapperCategoria{
  static Categoria categoriaAEntidad( CategoriaDb categoriaDb){
    return Categoria(
      id: categoriaDb.id, 
      nombre: categoriaDb.nombre,
      imagen: categoriaDb.imagen,
      updatedAt: categoriaDb.updatedAt,
      deletedAt: categoriaDb.deletedAt
      );
      }
  }