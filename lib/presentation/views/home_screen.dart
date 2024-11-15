
import 'package:control_app/presentation/views/crear_screen.dart';
import 'package:control_app/presentation/views/productos_screen.dart';
import 'package:control_app/presentation/views/views.dart';
import 'package:control_app/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  final int pageIndex;
   const HomeScreen({super.key, required this.pageIndex});

   final viewRoutes = const<Widget> [
    ProductosScreen(),
    CrearScreen(),
    ComprasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final validPageIndex = (pageIndex >= 0 && pageIndex < viewRoutes.length) ? pageIndex : 0;
   return Scaffold(
      body: Stack(
        children: [
          // Pantalla principal que cambia según el índice seleccionado
          Positioned.fill(
            child: IndexedStack(
              index: validPageIndex,
              children: viewRoutes,
            ),
          ),
          // Barra de navegación posicionada en la parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: CustomBottomNavigationBar(currentIndex: pageIndex),
          ),
        ],
      ),
    );
  }
}