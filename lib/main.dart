import 'package:control_app/config/config.dart';
import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Importa sqflite_common_ffi solo si estás en un entorno de escritorio

import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Detecta si estás en Windows, macOS o Linux
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Inicializa el databaseFactory con sqflite_common_ffi para entornos de escritorio
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Inicializa la base de datos
  await DataBase.initializeDatabase();
  final Database db = await openDatabase('control_app.db');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<DataCubit>(
        create: (context) => DataCubit(db: db),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Cuanto rinde',
      theme: AppTheme.getTheme(),
    );
  }
}
