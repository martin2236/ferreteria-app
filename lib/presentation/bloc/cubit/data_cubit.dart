 // Asegúrate de importar la configuración de la base de datos
import 'package:control_app/domain/entities/categorias_intitie.dart';
import 'package:control_app/domain/entities/compras_entitie.dart';
import 'package:control_app/domain/entities/marca_entitie.dart';
import 'package:control_app/domain/entities/medida_entitite.dart';
import 'package:control_app/domain/entities/proveedor_entitie.dart';
import 'package:control_app/domain/entities/dia_entitie.dart';
import 'package:control_app/infraestructure/mappers/proveedor_mapper.dart';
import 'package:control_app/infraestructure/models/marca_model.dart';
import 'package:control_app/infraestructure/models/proveedor_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/producto_entitie.dart';
import '../../../infraestructure/infraestructure.dart';
import '../../../infraestructure/mappers/marca_mapper.dart'; // Importa Sqflite para manejar la base de datos

part 'data_state.dart';

class DataCubit extends Cubit<DataCubitState> {
  final Database db;
  DataCubit({required this.db}) : super(const DataCubitState());

  Future<void> traerCategorias() async {
    try {
      final List<Map<String, dynamic>> jsonDataList = await db.query(
      'categorias',
      where: 'deleted_at IS NULL', // Filtrar productos donde deleted_at sea NULL
    );
      final List<CategoriaDb> categoriaDbList = jsonDataList.map((map) => CategoriaDb.fromJson(map)).toList();
      final List<Categoria> categorias = categoriaDbList.map((clienteDb) => MapperCategoria.categoriaAEntidad(clienteDb)).toList();
      emit(state.copyWith(categorias: categorias));
      
    } catch (e) {
      print(e);
    }
  }

  Future<void> traerMedidas() async {
    try {
      final List<Map<String, dynamic>> jsonDataList = await db.query('medidas');
      final List<MedidaDb> categoriaDbList = jsonDataList.map((map) => MedidaDb.fromJson(map)).toList();
      final List<Medida> medidas = categoriaDbList.map((clienteDb) => MapperMedida.medidaAEntidad(clienteDb)).toList();

      emit(state.copyWith(medidas: medidas));
      
    } catch (e) {
      print(e);
    }
  }

 

  Future<void> traerMarcas() async {
    try {
      final List<Map<String, dynamic>> jsonDataList = await db.query('marcas',where: 'deleted_at IS NULL',);
      final List<MarcaDb> marcasDbList = jsonDataList.map((map) => MarcaDb.fromJson(map)).toList();
      final List<Marca> marcas = marcasDbList.map((clienteDb) => MapperMarca.marcaAEntidad(clienteDb)).toList();

      emit(state.copyWith(marcas: marcas));
      
    } catch (e) {
      print(e);
    }
  }

   Future<void> traerCompras() async {
    try {
      final List<Map<String, dynamic>> jsonDataList = await db.query('compras');
      final List<CompraDb> comrpaDbList = jsonDataList.map((map) => CompraDb.fromJson(map)).toList();
      final List<Compra> compras = comrpaDbList.map((compraDb) => MapperCompra.CompraAEntitie(compraDb)).toList();

    emit(state.copyWith(compras: compras));
      
    } catch (e) {
      print(e);
    }
  }

  void finalizarCompra(){
    emit(state.copyWith(
            nombreCompra: null,
            pedido: []
          ));
  }


Future<(bool, String, Map<String, dynamic>)> crearCompra(String nombre) async {
  final db = await openDatabase('control_app.db');
  try {
    // Insertar la nueva compra
    await db.execute(
      'INSERT INTO compras (nombre, fecha) VALUES (?, ?)', 
      [nombre, DateTime.now().millisecondsSinceEpoch]
    );
    
    // Obtener el último ID insertado
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT last_insert_rowid() as id');
    final int lastInsertId = result.first['id'] as int;
    
    return (true, 'Compra creada con éxito', {'data': lastInsertId});
  } catch (e) {
    print(e);
    return (false, 'Error al crear compra', {'data': null});
  }
}

Future<(bool,String)> insertarCompraProducto(String nombre) async {
  final db = await openDatabase('control_app.db');
  
  final (success, mensaje, data) = await crearCompra(nombre);
  if (!success) {
    print(mensaje);
    return(false,'Error al crear la compra');
  }

  final int compraId = data['data'];
  final listaDeProductos = state.pedido;

  try {
    await db.transaction((txn) async {
      for (var producto in listaDeProductos) {
        // Verificar si el producto ya existe
        final List<Map<String, dynamic>> productQuery = await txn.query(
          'productos',
          where: 'nombre = ? AND deleted_at IS NULL',
          whereArgs: [producto.nombre],
        );

        int productId;
        if (productQuery.isNotEmpty) {
          // El producto ya existe; obtener el ID
          productId = productQuery.first['id'] as int;

          // Actualizar la fecha de `updated_at` y el estado
          await txn.update(
            'productos',
            {
              'updated_at': DateTime.now().millisecondsSinceEpoch,
              'estado': 1,  // Ajustar este valor según tu lógica
            },
            where: 'id = ?',
            whereArgs: [productId],
          );
        } else {
          // El producto no existe; crear uno nuevo
          productId = await txn.insert('productos', {
            'nombre': producto.nombre,
            'imagen': producto.imagen,
            'fkcategoria': producto.categoria,
            'fkunidad': producto.unidad,
            'precio': producto.precio,
            'estado': 1,
            'cantidad': producto.cantidad,
            'updated_at': DateTime.now().millisecondsSinceEpoch,
          });
        }

        // Insertar en la tabla de relación `detalle_compras`
        await txn.insert('detalle_compras', {
          'fkcompra': compraId,
          'fkproducto': productId,
          'cantidad': producto.cantidad,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });

    return(true,'Compra creada con Éxito');
  } catch (e) {
    print('Error al insertar compra y productos: $e');
    return(false,'Error al insertar los productos');
  }
}




Future<(bool, String)> updatePrecios({
  int? proveedorId,
  int? marcaId,
  int? categoriaId,
  double porcentajeAumento = 0.0,
}) async {
  // Base de la consulta
  String query = 'UPDATE productos SET precio = precio * ? WHERE 1=1';
  List<dynamic> params = [1 + porcentajeAumento / 100];

  // Agregar condiciones dinámicas
  if (proveedorId != null) {
    query += ' AND fkproveedor = ?';
    params.add(proveedorId);
  }
  if (marcaId != null) {
    query += ' AND fkmarca = ?';
    params.add(marcaId);
  }
  if (categoriaId != null) {
    query += ' AND fkcategoria = ?';
    params.add(categoriaId);
  }

  // Ejecutar la consulta
  final db = await openDatabase('control_app.db');
  try {
    final rowsAffected = await db.rawUpdate(query, params);
    print('$rowsAffected productos actualizados');
    return (true, 'Precios actualizados con éxito');
  } catch (e) {
    print('Error al actualizar los precios: $e');
    return (false, 'Error al actualizar los precios');
  }
}
//! LOGICA PRODUCTOS
 Future<void> traerProductos() async {
  try {
    // Ejecutar consulta filtrando productos no eliminados
    final List<Map<String, dynamic>> jsonDataList = await db.query(
      'productos',
      where: 'deleted_at IS NULL', // Filtrar productos donde deleted_at sea NULL
    );

    // Mapear los resultados a la lista de entidades
    final List<ProductoDb> productoDbList =
        jsonDataList.map((map) => ProductoDb.fromJson(map)).toList();

    final List<Producto> productos =
        productoDbList.map((productoDb) => MapperProducto.productoAEntidad(productoDb)).toList();

    // Actualizar el estado con los productos filtrados
    emit(state.copyWith(productos: productos));
  } catch (e) {
    print('Error al traer productos: $e');
  }
}

Future<(bool, String)> agregarProducto(Producto producto) async {
  final db = await openDatabase('control_app.db');

  try {
    await db.rawInsert(
      '''
      INSERT INTO productos (
        nombre, 
        imagen, 
        fkcategoria, 
        fkmarca, 
        fkmedida, 
        fkproveedor, 
        estado, 
        stock, 
        precio, 
        updated_at
      ) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        producto.nombre,
        producto.imagen,
        producto.categoria,
        producto.marca,
        producto.medida,
        producto.proveedor,
        producto.estado,
        producto.cantidad,
        producto.precio,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );

    return (true, 'Producto creado con éxito');
  } catch (e) {
    print('Error al insertar producto: $e');
    return (false, 'Error al insertar el producto');
  }
}
//! LOGICA MARCAS
Future<(bool, String)> agregarMarca(Marca categoria) async {
  final db = await openDatabase('control_app.db');

  try {
    await db.rawInsert(
      '''
      INSERT INTO marcas (
        nombre, 
        imagen, 
        updated_at
      ) 
      VALUES (?, ?, ?)
      ''',
      [
        categoria.nombre,
        categoria.imagen,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );

    return (true, 'Marca creado con éxito');
  } catch (e) {
    print('Error al insertar marca: $e');
    return (false, 'Error al insertar la marca');
  }
}

Future<(bool, String)> updateMarca(Marca categoria) async {

  final db = await openDatabase('control_app.db');
  
  try {
    // Ejecutar la consulta UPDATE
    await db.rawUpdate(
      '''
      UPDATE marcas
      SET 
        nombre = ?, 
        imagen = ?, 
        updated_at = ?
      WHERE id = ?;
      ''',
      [
        categoria.nombre,
        categoria.imagen,
        DateTime.now().millisecondsSinceEpoch,
        categoria.id, // Asegúrate de incluir el id en los parámetros
      ],
    );

    return (true, 'Marca actualizada con éxito');
  } catch (e) {
    return (false, 'Error al actualizar la marca');
  }
}

Future<(bool, String)> deleteMarca(int id) async {
  final db = await openDatabase('control_app.db');

  // Obtener la fecha actual en segundos desde la época Unix
  int toSecondsSinceEpoch(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  int fecha = toSecondsSinceEpoch(DateTime.now());

  try {
    // Ejecutar la consulta UPDATE para marcar el producto como eliminado
    await db.rawUpdate(
      '''
        UPDATE marcas
        SET 
          deleted_at = ?, 
          updated_at = ?
        WHERE id = ?;
      ''',
      [fecha, fecha, id], // `fecha` se asigna a `deleted_at` y `updated_at`
    );
    return (true, 'Marca eliminado con éxito');
  } catch (e) {
    print('Error al eliminar la marca: $e');
    return (false, 'Error al eliminar la marca');
  }
}
//! LOGICA CATEGORIAS

Future<(bool, String)> agregarCategoria(Categoria categoria) async {
  final db = await openDatabase('control_app.db');

  try {
    await db.rawInsert(
      '''
      INSERT INTO categorias (
        nombre, 
        imagen, 
        updated_at
      ) 
      VALUES (?, ?, ?)
      ''',
      [
        categoria.nombre,
        categoria.imagen,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );

    return (true, 'Categoria creado con éxito');
  } catch (e) {
    print('Error al insertar producto: $e');
    return (false, 'Error al insertar la categoria');
  }
}
Future<(bool, String)> updateCategoria(Categoria categoria) async {

  final db = await openDatabase('control_app.db');
  
  try {
    // Ejecutar la consulta UPDATE
    await db.rawUpdate(
      '''
      UPDATE categorias
      SET 
        nombre = ?, 
        imagen = ?, 
        updated_at = ?
      WHERE id = ?;
      ''',
      [
        categoria.nombre,
        categoria.imagen,
        DateTime.now().millisecondsSinceEpoch,
        categoria.id, // Asegúrate de incluir el id en los parámetros
      ],
    );

    return (true, 'Producto actualizado con éxito');
  } catch (e) {
    return (false, 'Error al actualizar el producto');
  }
}

Future<(bool, String)> deleteCategoria(int id) async {
  final db = await openDatabase('control_app.db');

  // Obtener la fecha actual en segundos desde la época Unix
  int toSecondsSinceEpoch(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  int fecha = toSecondsSinceEpoch(DateTime.now());

  try {
    // Ejecutar la consulta UPDATE para marcar el producto como eliminado
    await db.rawUpdate(
      '''
        UPDATE categorias
        SET 
          deleted_at = ?, 
          updated_at = ?
        WHERE id = ?;
      ''',
      [fecha, fecha, id], // `fecha` se asigna a `deleted_at` y `updated_at`
    );
    return (true, 'Categoria eliminado con éxito');
  } catch (e) {
    print('Error al eliminar el categoria: $e');
    return (false, 'Error al eliminar el categoria');
  }
}

//! LOGICA PROVEEDORES
Future<void> traerProveedores() async {
  try {
    final List<Map<String, dynamic>> jsonDataList = await db.rawQuery('''
      SELECT p.*, GROUP_CONCAT(v.id) AS visitas
      FROM proveedores p 
      LEFT JOIN detalle_visitas dv ON p.id = dv.fkproveedor 
      LEFT JOIN visitas v ON dv.fkvisita = v.id 
      WHERE p.deleted_at IS NULL
      GROUP BY p.id
    ''');

    // Crear la lista de proveedores
    final List<ProveedoresDb> proveedoresDbList = jsonDataList.map((map) {
      // Obtener los IDs de los días de la cadena concatenada
      
      String? visitasString = map['visitas'] as String?;
      
      
      List<int>? visitas = visitasString != null 
          ? visitasString.split(',').map((id) => int.parse(id)).toList() 
          : null; // Asignar null si visitasString es null
    print('VISITAS: ${visitas}');
      return ProveedoresDb(
        id: map['id'] ?? 0,
        nombre: map['nombre'] ?? '',
        imagen: map['imagen'] ?? '',
        color: map['color'] ?? '',
        telefono: map['telefono'] ?? '',
        email: map['email'] ?? '',
        updatedAt: map['updated_at'],
        deletedAt: map['deleted_at'],
        visita: visitas, // Asignar la lista de visitas
      );
    }).toList();
    final List<Proveedor> proveedores = proveedoresDbList.map((proveedorDb) => MapperProveedor.proveedorAEntidad(proveedorDb)).toList();
      
    emit(state.copyWith(proveedores: proveedores));
    
  } catch (e) {
    print(e);
  }
}

Future<(bool, String)> updateProducto(Producto producto) async {

  final db = await openDatabase('control_app.db');
  
  try {
    // Ejecutar la consulta UPDATE
    await db.rawUpdate(
      '''
      UPDATE productos
      SET 
        nombre = ?, 
        imagen = ?, 
        fkcategoria = ?, 
        fkmarca = ?, 
        fkmedida = ?, 
        fkproveedor = ?, 
        estado = ?, 
        stock = ?, 
        precio = ?, 
        updated_at = ?
      WHERE id = ?;
      ''',
      [
        producto.nombre,
        producto.imagen,
        producto.categoria,
        producto.marca,
        producto.medida,
        producto.proveedor,
        producto.estado,
        producto.cantidad,
        producto.precio,
        DateTime.now().millisecondsSinceEpoch,
        producto.id, // Asegúrate de incluir el id en los parámetros
      ],
    );

    return (true, 'Producto actualizado con éxito');
  } catch (e) {
    return (false, 'Error al actualizar el producto');
  }
}

Future<(bool, String)> deleteProduct(int id) async {
  final db = await openDatabase('control_app.db');

  // Obtener la fecha actual en segundos desde la época Unix
  int toSecondsSinceEpoch(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  int fecha = toSecondsSinceEpoch(DateTime.now());

  try {
    // Ejecutar la consulta UPDATE para marcar el producto como eliminado
    await db.rawUpdate(
      '''
        UPDATE productos
        SET 
          deleted_at = ?, 
          updated_at = ?
        WHERE id = ?;
      ''',
      [fecha, fecha, id], // `fecha` se asigna a `deleted_at` y `updated_at`
    );
    return (true, 'Producto eliminado con éxito');
  } catch (e) {
    print('Error al eliminar el producto: $e');
    return (false, 'Error al eliminar el producto');
  }
}

Future<(bool, String)> agregarProveedor(Proveedor proveedor) async {
  final db = await openDatabase('control_app.db');

  try {
    // Insertar el proveedor en la tabla de proveedores
    await db.rawInsert(
      '''
      INSERT INTO proveedores (
        nombre, 
        imagen, 
        telefono, 
        email, 
        color, 
        updated_at
      ) 
      VALUES (?, ?, ?, ?, ?, ?)
      ''',
      [
       proveedor.nombre,
       proveedor.imagen,
       proveedor.telefono,
       proveedor.email,
       proveedor.color,
       DateTime.now().millisecondsSinceEpoch,
      ],
    );

    // Obtener el último ID insertado
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT last_insert_rowid() as id');
    final int proveedorId = result.first['id'] as int;

    // Insertar las visitas en la tabla detalle_visitas
    for (var dia in proveedor.visita!) {
      await db.rawInsert(
        '''
        INSERT INTO detalle_visitas (fkvisita, fkproveedor) 
        VALUES (?, ?)
        ''',
        [
          dia, // Asegúrate de que 'dia' tenga un campo 'id'
          proveedorId,
        ],
      );
    }

    return (true, 'Proveedor creado con éxito');
  } catch (e) {
    print('Error al insertar proveedor: $e');
    return (false, 'Error al insertar el proveedor');
  }
}
 
Future<(bool, String)> updateProveedor(Proveedor proveedor) async {
  final db = await openDatabase('control_app.db');
  try {
    // Actualizar el proveedor en la tabla de proveedores
    await db.rawUpdate(
      '''
      UPDATE proveedores 
      SET nombre = ?, imagen = ?, telefono = ?, email = ?, color = ?, updated_at = ?
      WHERE id = ?
      ''',
      [
        proveedor.nombre,
        proveedor.imagen,
        proveedor.telefono,
        proveedor.email,
        proveedor.color,
        DateTime.now().millisecondsSinceEpoch,
        proveedor.id,
      ],
    );

    // Eliminar las visitas actuales del proveedor
    await db.rawDelete(
      '''
      DELETE FROM detalle_visitas 
      WHERE fkproveedor = ?
      ''',
      [proveedor.id],
    );

    // Insertar las nuevas visitas del proveedor
    for (var dia in proveedor.visita!) {
      await db.rawInsert(
        '''
        INSERT INTO detalle_visitas (fkvisita, fkproveedor) 
        VALUES (?, ?)
        ''',
        [
          dia, // Asegúrate de que 'dia' tenga un campo 'id'
          proveedor.id,
        ],
      );
    }

    return (true, 'Proveedor actualizado con éxito');
  } catch (e) {
    print('Error al actualizar proveedor: $e');
    return (false, 'Error al actualizar el proveedor');
  }
}

Future<(bool, String)> deleteProveedor(int id) async {
  final db = await openDatabase('control_app.db');

  // Obtener la fecha actual en segundos desde la época Unix
  int toSecondsSinceEpoch(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  int fecha = toSecondsSinceEpoch(DateTime.now());

  try {
    // Ejecutar la consulta UPDATE para marcar el producto como eliminado
    await db.rawUpdate(
      '''
        UPDATE proveedores
        SET 
          deleted_at = ?, 
          updated_at = ?
        WHERE id = ?;
      ''',
      [fecha, fecha, id], // `fecha` se asigna a `deleted_at` y `updated_at`
    );
    return (true, 'Proveedor eliminado con éxito');
  } catch (e) {
    print('Error al eliminar el proveedor: $e');
    return (false, 'Error al eliminar el proveedor');
  }
}
  
}


  

 

  

