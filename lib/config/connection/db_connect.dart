import 'package:sqflite/sqflite.dart';


class DataBase {
  
   static Future<void> initializeDatabase() async {
    await openDatabase(
      'control_app.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE categorias (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
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
         CREATE TABLE productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            imagen TEXT NOT NULL,
            fkcategoria INTEGER NOT NULL,
            fkunidad INTEGER NOT NULL,
            estado INTEGER NOT NULL,
            cantidad INTEGER NOT NULL,
            precio REAL NOT NULL,
            updated_at INTEGER DEFAULT (strftime('%s', 'now')),
            deleted_at INTEGER,
            FOREIGN KEY (fkcategoria) REFERENCES categorias(id),
            FOREIGN KEY (fkunidad) REFERENCES medidas(id)
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
        //await insertCategorias(db);
        //await insertMedidas(db);
      },
    );
  }

  static Future<void> insertCategorias(Database db) async {
    await db.execute('''
          INSERT INTO categorias (nombre)
          VALUES 
          ('Auto'),
          ('Comida'),
          ('Bebida'),
          ('Indumentaria'),
          ('Recreacion'),
          ('Servicios');
        ''');
    print('categorias insertadas');
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
}
