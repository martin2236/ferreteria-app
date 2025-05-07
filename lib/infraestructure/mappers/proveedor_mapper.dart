
import 'package:control_app/domain/entities/proveedor_entitie.dart';
import 'package:control_app/infraestructure/models/proveedor_model.dart';

class MapperProveedor{

  static Proveedor proveedorAEntidad(ProveedoresDb ProveedorDb){
    return Proveedor(
      id: ProveedorDb.id,
      nombre: ProveedorDb.nombre,
      imagen: ProveedorDb.imagen, 
      telefono: ProveedorDb.telefono,
      email: ProveedorDb.email,
      color: ProveedorDb.color,
      visita: ProveedorDb.visita,
      updatedAt: ProveedorDb.updatedAt,
      deletedAt: ProveedorDb.deletedAt
    );
  }

}