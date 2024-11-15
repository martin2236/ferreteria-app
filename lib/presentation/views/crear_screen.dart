import 'package:control_app/config/config.dart';
import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/producto_entitie.dart';
import '../widgets/imputs/input_sugestion.dart';
import '../widgets/widget.dart';


class CrearScreen extends StatefulWidget {
  const CrearScreen({super.key});

  @override
  State<CrearScreen> createState() => _CrearScreenState();
}

class _CrearScreenState extends State<CrearScreen> {
  String compra = '';

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final dataCubit = context.watch<DataCubit>();

    return Scaffold(
      body: BlocBuilder<DataCubit, DataCubitState>(
        builder: (context, state) {
          final compras = state.compras;

          if (compras == null) {
            dataCubit.traerCompras();
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.20,
                  width: size.width,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: size.height,
                        child: const HeaderWaves(),
                      ),
                      Positioned(
                        top: size.height * 0.06,
                        child: SizedBox(
                          width: size.width,
                          child: Text(
                            'Nueva Compra',
                            style: GoogleFonts.lobster(
                              textStyle: text.displaySmall!.copyWith(color: Colors.white),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  height: size.height * 0.20,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                        width: size.width * 0.9,
                        child: InputSugestion(
                          sugerencia: TipoSugerencia.compra,
                          titulo: 'NOMBRE DE LA COMPRA',
                          compras: compras,
                          onValueChanged: (value) => setState(() {
                            compra = value;
                          }),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: FilledButton.icon(
                            icon: const Icon(Icons.playlist_add_rounded),
                            label: const Text('Agregar Compra'),
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.purple),
                            ),
                            onPressed: () async {
                              if (compra != '') {
                                router.push('/compra/$compra');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.9,
                  child: Text(
                    'Últimas compras',
                    style: text.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: size.height * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: compras.length,
                      itemBuilder: (context, index) =>
                          _CompraCard(nombre: compras[index].nombre),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final Producto producto;
  const _ProductoCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 30,),
          Text(producto.nombre, textAlign: TextAlign.center,),
          Text('\$${producto.precio.toStringAsFixed(3)}'),
        ],
      ),
    );
  }
}

class _CompraCard extends StatelessWidget {
  final String nombre;
  const _CompraCard({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 40,
          color: Colors.purple.shade100,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(nombre)
            ]
            ),
        ),
      ),
    );
  }
}