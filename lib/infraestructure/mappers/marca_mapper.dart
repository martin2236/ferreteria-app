
import 'package:control_app/domain/entities/marca_entitie.dart';
import 'package:control_app/infraestructure/models/marca_model.dart';

class MapperMarca {

static Marca marcaAEntidad(MarcaDb marcaDb){
  return Marca(
    id: marcaDb.id,
    nombre: marcaDb.nombre,
    imagen: marcaDb.imagen,
    updatedAt: marcaDb.updatedAt,
    deletedAt: marcaDb.deletedAt
  );
}
}