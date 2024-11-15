import 'package:control_app/infraestructure/models/medida_model.dart';

import '../../domain/entities/medida_entitite.dart';

class MapperMedida{
  static Medida medidaAEntidad( MedidaDb medidaDb){
    return Medida(
      id: medidaDb.id, 
      nombre: medidaDb.nombre
      );
      }
  }