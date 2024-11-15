 // Asegúrate de importar la configuración de la base de datos
import 'package:control_app/domain/entities/categorias_intitie.dart';
import 'package:control_app/domain/entities/compras_entitie.dart';
import 'package:control_app/domain/entities/medida_entitite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/producto_entitie.dart';
import '../../../infraestructure/infraestructure.dart'; // Importa Sqflite para manejar la base de datos

part 'data_state.dart';

class DataCubit extends Cubit<DataCubitState> {
  final Database db;
  DataCubit({required this.db}) : super(const DataCubitState());

  Future<void> traerCategorias() async {
    try {
      final List<Map<String, dynamic>> jsonDataList = await db.query('categorias');
      final List<CategoriaDb> categoriaDbList = jsonDataList.map((map) => CategoriaDb.fromJson(map)).toList();
      final List<Categoria> categorias = categoriaDbList.map((clienteDb) => MapperCategoria.categoriaAEntidad(clienteDb)).toList();

      print(categorias);
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

   Future<void> traerProductos() async {
    print('traer productos');
    try {
      final List<Map<String, dynamic>> jsonDataList = await db.query('productos');
      print(jsonDataList);
      final List<ProductoDb> productoDbList = jsonDataList.map((map) => ProductoDb.fromJson(map)).toList();
      final List<Producto> productos = productoDbList.map((compraDb) => MapperProducto.productoAEntidad(compraDb)).toList();

    emit(state.copyWith(productos: productos));
      
    } catch (e) {
      print(e);
    }
  }

    void agregarProducto(Producto producto){
          emit(state.copyWith(
            pedido: [...state.pedido,producto]
          ));
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

  
}
  // Future<List<Producto>> buscarProductosPorNombre(String input) async {
  //   try {
  //     final Database db = await openDatabase('control_app.db');

  //     // Buscar productos cuyo nombre comience con el input
  //     final List<Map<String, dynamic>> jsonDataList = await db.query(
  //       'productos',
  //       where: 'nombre LIKE ?',
  //       whereArgs: ['$input%'],
  //     );

  //     // Mapear los resultados a entidades de Producto
  //     final List<ProductoDb> productoDbList = jsonDataList.map((map) => ProductoDb.fromJson(map)).toList();
  //     final List<Producto> productos = productoDbList.map((productoDb) => MapperProducto.productoAEntidad(productoDb)).toList();

  //     return productos;
      
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  //}

  

