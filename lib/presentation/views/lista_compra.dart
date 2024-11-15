import 'dart:io';

import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/router/router.dart';
import '../../domain/entities/producto_entitie.dart';
import '../widgets/header.dart';

class ListaCompra extends StatelessWidget {
  final String nombre;
  const ListaCompra({super.key,required this.nombre});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final dataCubit = context.watch<DataCubit>();
    final listaDeProductos = dataCubit.state.pedido;
    return Scaffold(
      body: Column(
        children: [
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
                          height: 80,
                          width: size.width,
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(nombre,
                              style: GoogleFonts.lobster(
                                  textStyle: text.displaySmall!.copyWith(color: Colors.white),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                        ),
                    ],
              ),
            ),
            SizedBox(height: size.height * 0.02,),
            SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FilledButton.icon(
                     icon: const Icon(Icons.shopping_cart),
                     label:const Text('Agregar Producto'),
                     style: ButtonStyle(
                       backgroundColor: WidgetStateProperty.all(Colors.purple)
                     ),
                     onPressed: (){
                      router.push('/crear');
                      }
                    ),
                  ),
                ),

                const Text('Mi compra'),
                Container(
                  height: size.height * 0.6,
                  width: size.width,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        mainAxisSpacing: 10.0, 
                        crossAxisSpacing: 10.0, 
                      ),
                    itemCount: listaDeProductos.length,
                    itemBuilder: (context, index) => _ProductoListCard(producto: listaDeProductos[index]),),
                ),
                const Spacer(),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    FilledButton.icon(
                     icon: const Icon(Icons.cancel),
                     label:const Text('Cancelar'),
                     style: ButtonStyle(
                       backgroundColor: WidgetStateProperty.all(Colors.purple)
                     ),
                     onPressed: (){
                      router.push('/crear');
                      }
                    ),
                     FilledButton.icon(
                     icon: const Icon(Icons.check_circle),
                     label:const Text('Finalizar'),
                     style: ButtonStyle(
                       backgroundColor: WidgetStateProperty.all(Colors.purple)
                     ),
                     onPressed: () async{
                     final (success,mensaje) = await dataCubit.insertarCompraProducto(nombre);
                     if(success){
                      dataCubit.traerCompras();
                      dataCubit.finalizarCompra();
                      router.pop();
                     }
                      }
                    ),
                ],
               )
        ],
      ),
    );
  }
}

class _ProductoListCard extends StatelessWidget {
  final Producto producto;
  const _ProductoListCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Card(
      color: Colors.purple.shade50,
      child: Stack(
        children: [
           Image(image: FileImage(File(producto.imagen)),width: size.width,fit: BoxFit.cover,),
          //const Icon(Icons.shopping_bag_outlined,size: 30,),
          FittedBox(child: Text(producto.nombre, textAlign: TextAlign.center,style: text.bodyMedium!.copyWith(color: Colors.white),)),
          Positioned(
            bottom: 0,
            child: FittedBox(
              child: Text('\$${producto.precio.toStringAsFixed(2)}', style: text.bodyMedium!.copyWith(color: Colors.white),))
            ),
        ],
      ),
    );
  }
}