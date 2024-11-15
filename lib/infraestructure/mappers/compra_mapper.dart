



import 'package:control_app/infraestructure/infraestructure.dart';

import '../../domain/entities/compras_entitie.dart';


class MapperCompra{
  static Compra CompraAEntitie( CompraDb compraDb){
    return Compra(
      id: compraDb.id,
      nombre: compraDb.nombre,
      fecha: compraDb.fecha,
      updatedAt: compraDb.updatedAt,
      deletedAt: compraDb.deletedAt
      );
      }
  }