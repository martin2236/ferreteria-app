import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DataBase {
  
   static Future<void> initializeDatabase() async {
    await openDatabase(
      'control_app.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE categorias (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagen TEXT,
            nombre TEXT NOT NULL,
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE marcas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagen TEXT,
            nombre TEXT NOT NULL,
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER
          );
        ''');

         await db.execute('''
          CREATE TABLE medidas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE proveedores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            imagen TEXT,
            color TEXT,
            telefono TEXT,
            email TEXT,
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER
          );
        ''');

         await db.execute('''
          CREATE TABLE pagos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            monto TEXT NOT NULL,
            imagen TEXT,
            proveedor TEXT NOT NULL,
            fecha INTEGER NOT NULL,
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE visitas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dia TEXT NOT NULL,
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE detalle_visitas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fkvisita INTEGER NOT NULL,
            fkproveedor INTEGER NOT NULL,
            FOREIGN KEY (fkvisita) REFERENCES visitas(id),
            FOREIGN KEY (fkproveedor) REFERENCES proveedores(id)
          );
        ''');

        await db.execute('''
         CREATE TABLE productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            imagen TEXT NOT NULL,
            fkcategoria INTEGER NOT NULL,
            fkmarca INTEGER,
            fkmedida INTEGER NOT NULL,
            fkproveedor INTEGER NOT NULL,
            estado INTEGER NOT NULL,
            stock INTEGER NOT NULL,
            precio REAL NOT NULL,
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER,
            FOREIGN KEY (fkcategoria) REFERENCES categorias(id),
            FOREIGN KEY (fkproveedor) REFERENCES proveedor(id)
            FOREIGN KEY (fkmarca) REFERENCES marcas(id)
            FOREIGN KEY (fkmedida) REFERENCES medidas(id)
         
          );
        ''');

        await db.execute('''
          CREATE TABLE compras (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            fecha INTEGER DEFAULT (strftime('%s', 'now')),
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE detalle_compras (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fkcompra INTEGER NOT NULL,
            fkproducto INTEGER NOT NULL,
            cantidad REAL NOT NULL,
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER,
            FOREIGN KEY (fkcompra) REFERENCES compras(id),
            FOREIGN KEY (fkproducto) REFERENCES productos(id)
          );
        ''');

        print('Tablas creadas');
      },
      onOpen: (Database db) async {
        print('Base de datos abierta');
        //  await insertCategorias(db);
        //  await insertProveedores(db);
        //  await insertMarcas(db);
        //  await insertMedidas(db);
        //  await insertVisitas(db);

      },
    );
  }

  static Future<void> insertCategorias(Database db) async {
    await db.execute('''
          INSERT INTO categorias (nombre)
          VALUES 
          ('Tornillos'),
          ('Bulones'),
          ('Clavos'),
          ('Alambres'),
          ('PVC'),
          ('Termofuión'),
          ('Singueria')
        ''');
    print('categorias insertadas');
  }

  static Future<void> insertMarcas(Database db) async {
    await db.execute('''
          INSERT INTO marcas (nombre)
          VALUES 
          ('Acindar'),
          ('Crecchio'),
          ('tacsa'),
          ('bremen'),
          ('bahco'),
          ('skil'),
          ('duke')
        ''');
    print('marcas insertadas');
  }

    static Future<void> insertMedidas(Database db) async {
    await db.execute('''
          INSERT INTO medidas (nombre)
          VALUES 
          ('Unidad'),
          ('Gramos'),
          ('Kilos'),
          ('Mililitros'),
          ('Litros'),
          ('Centimetros'),
          ('Metros');
        ''');
    print('medidas insertadas');
  }

  static Future<void> insertProveedores(Database db) async {
    await db.execute('''
          INSERT INTO proveedores (nombre)
          VALUES 
          ('IMP'),
          ('Antolu'),
          ('Cesar'),
          ('Tony'),
          ('Javier')
        ''');
        print('proveedores insertadas');
  }

  static Future<void> insertVisitas(Database db) async {
    await db.execute('''
          INSERT INTO visitas (dia)
          VALUES 
          ('Lunes'),
          ('Martes'),
          ('Miercoles'),
          ('Jueves'),
          ('Viernes'),
          ('Sabado'),
          ('Domingo')
        ''');
        print('visitas insertadas');
  }
}
