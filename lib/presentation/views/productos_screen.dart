import 'dart:io';

import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/producto_entitie.dart';
import '../widgets/header.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = Theme.of(context).textTheme;
    return Scaffold(
        body: Column(
          children:[
            SizedBox(
              height: size.height * 0.20,
              width: size.width,
              child: Stack(
                    children: [
                      SizedBox(
                        height: size.height,
                        child:const HeaderWaves(),
                      ),
                       Positioned(
            top: size.height * 0.06,
            child: SizedBox(
              width: size.width,
              child: Text('Mis Productos',
              style: GoogleFonts.lobster(
                  textStyle: text.displaySmall!.copyWith(color: Colors.white),
                ),
                textAlign: TextAlign.center,
              ),
            )
            ),
                    ],
              ),
            ),
              SizedBox(
              height: size.height * 0.70,
              width:size.width,
              child: const Column(children: [
               _ProductosContainer()
              ],
              )
            )
            ]
        ),
    );
  }
}




class _ProductosContainer extends StatelessWidget {
  const _ProductosContainer({super.key});
  
  @override
  Widget build(BuildContext context) {
    final dataCubit = context.watch<DataCubit>();
    final productos = dataCubit.state.productos;
     if(productos == null){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DataCubit>().traerProductos();
      });
    }
    final size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.height * 0.70,
        width: size.width,
        child: productos != null ?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
          itemCount: productos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            mainAxisSpacing: 10.0, 
            crossAxisSpacing: 10.0, 
          ),
          itemBuilder: (context, index) => _ProductoListCard(producto: productos[index]),
                ),
        )
        :
        const Text('No hay productos registrados'),
    );
    
  }
}

class _ProductoListCard extends StatelessWidget {
  final Producto producto;
  const _ProductoListCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    print('nombre: ${producto.nombre}');
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Card(
      color: Colors.purple.shade50,
      child: Stack(
        children: [
           Image(image: FileImage(File(producto.imagen)),width: size.width,fit: BoxFit.cover,),
          //const Icon(Icons.shopping_bag_outlined,size: 30,),
          Text(producto.nombre, textAlign: TextAlign.center,style: text.bodyMedium!.copyWith(color: Colors.white),),
        
        ],
      ),
    );
  }
  }