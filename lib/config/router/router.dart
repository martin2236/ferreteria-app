


import 'package:control_app/presentation/views/productos/crear_producto_screen.dart';
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
        path: '/home',
        builder: (context, state) =>const HomeScreen()
          
        ),
        GoRoute(
        path: '/productos',
        builder: (context, state) =>const ProductosScreen(),
        routes: [
            GoRoute(
              path: 'crearproducto',
              builder: (context, state) => const CrearProductoScreen(),
            ),

            GoRoute(
              path: 'editarproducto/:id',
              builder: (context, state) {
                 final id = state.pathParameters['id']; 
                return EditarProductoScreen(id: id!);
              },
            ),
        ]
          
        ),
        GoRoute(
        path: '/categorias',
        builder: (context, state) =>const CategoriasScreen(),
         routes: [
            GoRoute(
              path: 'crearcategoria',
              builder: (context, state) => const CrearCategoriaScreen(),
            ),

            GoRoute(
              path: 'editarcategoria/:id',
              builder: (context, state) {
                 final id = state.pathParameters['id']; 
                return EditarCategoriaScreen(id: id!);
              },
            ),
        ]
          
        ),
         GoRoute(
        path: '/marcas',
        builder: (context, state) =>const MarcasScreen(),
         routes: [
            GoRoute(
              path: 'crearmarca',
              builder: (context, state) => const CrearMarcaScreen(),
            ),

            GoRoute(
              path: 'editarmarca/:id',
              builder: (context, state) {
                 final id = state.pathParameters['id']; 
                return EditarMarcaScreen(id: id!);
              },
            ),
        ]
          
        ),
        GoRoute(
        path: '/proveedores',
        builder: (context, state) =>const ProveedoresScreen(),
        routes: [
            GoRoute(
              path: 'crearproveedor',
              builder: (context, state) => const CrearProveedorScreen(),
            ),

            GoRoute(
              path: 'editarproveedor/:id',
              builder: (context, state) {
                 final id = state.pathParameters['id']; 
                return EditarProveedorScreen(id: id!);
              },
            ),
        ]
          
        ),
        GoRoute(
        path: '/pagos',
        builder: (context, state) =>const PagosScreen()
          
        ),
    

       GoRoute(
        path: '/compra/:nombre',
        builder: (context, state) {  
          final nombre = state.pathParameters['nombre'];
          return  ListaCompra(nombre:nombre!);},
      ),
      
  ]
  
  );