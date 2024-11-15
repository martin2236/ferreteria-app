import 'package:control_app/config/config.dart';
import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   DataBase.initializeDatabase();
     final Database db = await openDatabase('control_app.db');
  runApp( MultiBlocProvider(
      providers:[
        BlocProvider<DataCubit>(
          create: (context) => DataCubit(db:db),
        ),
      ],
      child: const MyApp(),
      )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Cuanto rinde',
      theme: AppTheme.getTheme()
      
    );
  }
}


