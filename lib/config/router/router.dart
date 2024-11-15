


import 'package:control_app/presentation/screens/agregar_producto_screen.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/views/views.dart';


final router = GoRouter(
  initialLocation: '/',
  routes:[
    GoRoute(
      path: '/',
      builder: (context, state) =>const LoginScreen(),
      ),

        GoRoute(
        path: '/home/:page',
        builder: (context, state) {
           final page = state.pathParameters['page'] ?? '0';
        final pageIndex = int.tryParse(page) ?? 0;
        return HomeScreen(pageIndex: pageIndex);
          }
        ),
      GoRoute(
        path: '/crear',
        builder: (context, state) => const AgregarProductoScreen(),
      ),

       GoRoute(
        path: '/compra/:nombre',
        builder: (context, state) {  
          final nombre = state.pathParameters['nombre'];
          return  ListaCompra(nombre:nombre!);},
      ),
      
  ]
  
  );