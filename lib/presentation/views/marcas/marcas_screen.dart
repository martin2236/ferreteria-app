import 'dart:io';

import 'package:control_app/domain/entities/categorias_intitie.dart';
import 'package:control_app/domain/entities/marca_entitie.dart';

import 'package:control_app/domain/entities/proveedor_entitie.dart';
import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:control_app/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


class MarcasScreen extends StatefulWidget {
  const MarcasScreen({super.key});

  @override
  State<MarcasScreen> createState() => _MarcaScreenState();
}

class _MarcaScreenState extends State<MarcasScreen> {
  static const _actionTitles = [
    'Crear producto',
    'Editar precios',
    'Hacer algo'
  ];
  List<Marca>? marcas = [];
  List<Categoria>? categorias = [];
  List<Proveedor>? proveedores = [];
  int? categoriaSeleccionada;
  int? proveedorSeleccionado;
  int? marcaSeleccionada;
  @override
  void initState() {
    marcas = context.read<DataCubit>().state.marcas;
    categorias = context.read<DataCubit>().state.categorias;
    proveedores = context.read<DataCubit>().state.proveedores;
    super.initState();
  }

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        int? localCategoriaSeleccionada = categoriaSeleccionada;
        int? localProveedorSeleccionado = proveedorSeleccionado;
        int? localMarcaSeleccionada = marcaSeleccionada;
        double localPorcentaje = 0.0;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(_actionTitles[index]),
              content: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          height: 80,
                          child: SelectCategoria(
                            categorias: categorias,
                            tipoIvaSeleccionado: localCategoriaSeleccionada,
                            onChanged: (int? value) {
                              setDialogState(() {
                                localCategoriaSeleccionada = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          height: 80,
                          child: SelectMarca(
                            marcas: marcas,
                            marcaSeleccionada: localMarcaSeleccionada,
                            onChanged: (int? value) {
                              setDialogState(() {
                                localMarcaSeleccionada = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          height: 80,
                          child: SelectProveedor(
                            proveedores: proveedores,
                            proveedorSeleccionado: localProveedorSeleccionado,
                            onChanged: (int? value) {
                              setDialogState(() {
                                localProveedorSeleccionado = value;
                              });
                            },
                          ),
                        ),
                      ),
                      if (localProveedorSeleccionado != null ||
                          localCategoriaSeleccionada != null ||
                          localMarcaSeleccionada != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            height: 80,
                            child: CustomTextFormField(
                              hint: 'DESCUENTO',
                              keyboardType: TextInputType.number,
                              onChanged: (value) => setDialogState(
                                  () => localPorcentaje = double.parse(value)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
              Row(
                mainAxisAlignment: 
                localProveedorSeleccionado != null ||
                localCategoriaSeleccionada != null ||
                localMarcaSeleccionada != null ?
                MainAxisAlignment.spaceAround
                : MainAxisAlignment.end,

                children: [
                    if(localProveedorSeleccionado != null ||
                localCategoriaSeleccionada != null ||
                localMarcaSeleccionada != null)
                FilledButton(
                  onPressed: () async {
                    localProveedorSeleccionado = null;
                    localMarcaSeleccionada = null;
                    localCategoriaSeleccionada = null;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                localProveedorSeleccionado != null ||
                localCategoriaSeleccionada != null ||
                localMarcaSeleccionada != null ?
                 FilledButton(
                          onPressed: () async {
                            final dataCubit = context.read<DataCubit>();
                            final (success, _) = await dataCubit.updatePrecios(
                              proveedorId: localProveedorSeleccionado,
                              marcaId: localMarcaSeleccionada,
                              categoriaId: localCategoriaSeleccionada,
                              porcentajeAumento: localPorcentaje,
                            );

                            if (success) {
                              dataCubit.traerProductos();
                              setDialogState(() {
                                localProveedorSeleccionado = null;
                                localMarcaSeleccionada = null;

                                localCategoriaSeleccionada = null;
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Aplicar'),
                        )
                :
                TextButton(
                  onPressed: () async {
                    localProveedorSeleccionado = null;
                    localMarcaSeleccionada = null;
                    localCategoriaSeleccionada = null;
                    Navigator.of(context).pop();
                  },
                  child: const Text('CERRAR'),
                ),
                ],
              )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(Icons.sort),
          ),
           ActionButton(
            onPressed: () => context.push('/marcas/crearmarca/'),
            icon: const Icon(Icons.add),
          ),
          // ActionButton(
          //   onPressed: () => _showAction(context, 1),
          //   icon: const Icon(Icons.edit),
          // ),
         
        ],
      ),
      body: Column(children: [
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
                      'Mis marcas',
                      style: GoogleFonts.lobster(
                        textStyle:
                            text.displaySmall!.copyWith(color: Colors.white),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(
            height: size.height * 0.80,
            width: size.width,
            child: Row(
              children: [
                Container(
                  color: Colors.white,
                  height: size.height * 0.80,
                  width: size.width * 0.20,
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {context.replace('/productos');}, child: const Text('Productos')),
                      TextButton(
                          onPressed: () {context.replace('/proveedores');}, child: const Text('Proveedores')),
                           TextButton(
                          onPressed: () {context.replace('/categorias');}, child: const Text('Categorias')),
                      TextButton(
                          onPressed: () {}, child: const Text('Marcas')),
                      TextButton(
                          onPressed: () {
                            context.replace('/pagos');
                          },
                          child: const Text('Pagos')),
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.03,
                  height: size.height * 0.9,
                  color: Colors.purple.shade100,
                ),
                const _ProductosContainer()
              ],
            ))
      ]),
    );
  }
}

class _ProductosContainer extends StatelessWidget {
  const _ProductosContainer();

  @override
  Widget build(BuildContext context) {
    final dataCubit = context.watch<DataCubit>();
    final marcas = dataCubit.state.marcas;
   
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.75,
      width: size.width * 0.75,
      color: Colors.white,
      child: marcas != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Wrap(
                  runSpacing: 10, // Espacio vertical entre tarjetas
                  children: marcas
                      .map((marca) => SizedBox(
                            width: size.width * 0.18, // Ancho de cada tarjeta
                            child: _MarcaListCard(marca: marca),
                          ))
                      .toList(),
                ),
              ),
            )
          : const Text('No hay marcas registrados'),
    );
  }
}

class _MarcaListCard extends StatelessWidget {
  final Marca marca;
  const _MarcaListCard({required this.marca});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final dataCubit = context.watch<DataCubit>();
   
    print('''
${marca.nombre}
${marca.imagen}
''');
    return Card(
      color: Colors.purple.shade50,
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Image(
              image: marca.imagen != "" && marca.imagen != null && File(marca.imagen).existsSync()
                                      ? FileImage(File(marca.imagen)) 
                                      :const AssetImage('assets/images/no_image.jpg') as ImageProvider,
              width: size.width ,
              height: size.width * 0.15,
              fit: BoxFit.cover,
            ),
          ),
    
          //const Icon(Icons.shopping_bag_outlined,size: 30,),
          Text(marca.nombre,
              textAlign: TextAlign.center, style: text.titleMedium!),
         
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(onPressed: (){  context.push('/marcas/editarmarca/${marca.id}');}, child: const Text('Editar')),
    
                FilledButton(onPressed: ()async{
                  final (success,data) = await dataCubit.deleteMarca( marca.id!);
                  marca.imagen != "" ? File(marca.imagen).deleteSync() : null;
                  if(success == true ){
                      dataCubit.traerCategorias();
                  }
                }, child: const Text('Eliminar'))
              ],
            )
        ],
      ),
    );
  }
}
