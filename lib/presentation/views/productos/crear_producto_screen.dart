import 'dart:io';

import 'package:control_app/config/config.dart';
import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/producto_entitie.dart';
import '../../widgets/widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:file_picker/file_picker.dart';

int toSecondsSinceEpoch(dynamic dateTime) {
  return dateTime.millisecondsSinceEpoch ~/ 1000;
}

class CrearProductoScreen extends StatefulWidget {
  const CrearProductoScreen({super.key});

  @override
  State<CrearProductoScreen> createState() => _CrearProductoScreenState();
}

class _CrearProductoScreenState extends State<CrearProductoScreen> {
  String? result;
  String? categoria;
  //datos del producto
  String? nombre;
  int? categoriaSeleccionada;
  int? medidaSeleccionada;
  int? proveedorSeleccionado;
  int? marcaSeleccionada;
  String? imagepath;
  String? productoName;
  String? cantidad;
  int? fkUnidad;
  int? fkProveedor;
  String? precio;
  final CurrencyTextFieldController _currencyController =
      CurrencyTextFieldController(
    currencySymbol: "\$",
    decimalSymbol: ".",
    thousandSymbol: ",",
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = Theme.of(context).textTheme;
    final dataCubit = context.watch<DataCubit>();
    final categorias = dataCubit.state.categorias;
    final proveedores = dataCubit.state.proveedores;
    final marcas = dataCubit.state.marcas;
    final medidas = dataCubit.state.medidas;
    final productos = dataCubit.state.productos ?? [];

   Future<void> seleccionarImagen(String categoria) async {
    // Definir el directorio base
    final Directory baseDir = Directory('./images/$categoria');
    
    // Verificar si la carpeta existe; si no, crearla
    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }

    // Usar file_picker para seleccionar una imagen
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      // Obtener la ruta del archivo seleccionado
      final File file = File(result.files.single.path!);
      print(file);

      // Guardar la ruta de la imagen seleccionada sin copiarla aún
      setState(() {
        imagepath = file.path; // Actualiza el path para usar la imagen seleccionada
      });

      print('Imagen seleccionada: ${file.path}');
    } else {
      print('No se seleccionó ninguna imagen');
    }
  }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
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
                        'Nuevo Producto',
                        style: GoogleFonts.lobster(
                          textStyle:
                              text.displaySmall!.copyWith(color: Colors.white),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Positioned(
                  top: size.height * 0.04,
                  child: IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(
                        Icons.arrow_circle_left_sharp,
                        color: Colors.white,
                        size: size.height * 0.05,
                      )),
                ),
              ],
            ),
          ),
          Form(
              child: Container(
                  height: size.height * 0.8,
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => seleccionarImagen('productos'),
                        child: DottedBorder(
                          dashPattern: const [9, 9, 9, 9],
                          color: Colors.purple,
                          strokeWidth: 2,
                          child: imagepath != null
                              ? Container(
                                  height: size.width * 0.3,
                                  width: size.width * 0.3,
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                  ),
                                  child: Image(
                                    image: FileImage(File(imagepath!)),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  height: size.width * 0.3,
                                  width: size.width * 0.3,
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_rounded,
                                        size: size.height * 0.05,
                                        color: Colors.purple,
                                      ),
                                      Text(
                                        'Toca para agregar imagen',
                                        style: text.titleSmall!
                                            .copyWith(color: Colors.purple),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.68,
                        height: size.width * 0.3,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      height: 80,
                                      child: InputSugestion(
                                        sugerencia: TipoSugerencia.producto,
                                        titulo: 'NOMBRE DEL PRODUCTO',
                                        productos: productos,
                                        onValueChanged: (value) => setState(() {
                                          nombre = value;
                                        }),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                        height: 80,
                                        width: size.width * 0.43,
                                        child: CustomTextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              cantidad = value.toString();
                                            });
                                          },
                                          hint: 'CANTIDAD',
                                          keyboardType: TextInputType.number,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      height: 80,
                                      width: size.width,
                                      child: CustomTextFormField(
                                        controller: _currencyController,
                                        onChanged: (value) {
                                          setState(() {
                                            precio = value;
                                          });
                                        },
                                        hint: 'PRECIO',
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      height: 80,
                                      child: SelectCategoria(
                                        categorias: categorias,
                                        tipoIvaSeleccionado:
                                            categoriaSeleccionada,
                                        onChanged: (int? value) {
                                          // registerCubit.clientIvaChanged(value!);
                                          setState(() {
                                            categoriaSeleccionada = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      height: 80,
                                      child: SelectMedida(
                                        medidas: medidas,
                                        tipoIvaSeleccionado:
                                            categoriaSeleccionada,
                                        onChanged: (int? value) {
                                          // registerCubit.clientIvaChanged(value!);
                                          setState(() {
                                            medidaSeleccionada = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      height: 80,
                                      child: SelectMarca(
                                        marcas: marcas,
                                        marcaSeleccionada: marcaSeleccionada,
                                        onChanged: (int? value) {
                                          // registerCubit.clientIvaChanged(value!);
                                          setState(() {
                                            marcaSeleccionada = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      height: 80,
                                      child: SelectProveedor(
                                        proveedores: proveedores,
                                        proveedorSeleccionado:
                                            proveedorSeleccionado,
                                        onChanged: (int? value) {
                                          // registerCubit.clientIvaChanged(value!);
                                          setState(() {
                                            proveedorSeleccionado = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: SizedBox(
                                      height: 50,
                                      width: size.width,
                                      child: FilledButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      Colors.purple)),
                                          onPressed: () async {

                                                if (imagepath != null) {
                                              final Directory baseDir = Directory('./images/productos');
                                              final String timestamp = DateTime.now().millisecondsSinceEpoch.toString(); // Obtener timestamp
                                              final String destinationPath = '${baseDir.path}/$timestamp${File(imagepath!).uri.pathSegments.last}';
                                           
                                              // Copiar la imagen al directorio correspondiente
                                              await File(imagepath!).copy(destinationPath);
                                              setState(() {
                                                imagepath = destinationPath;
                                              });
                                            }
                                            int fecha = toSecondsSinceEpoch(
                                                DateTime.now());

                                            var nuevoPrecio =
                                                precio!.split(' ');
                                            var precioFormateado =
                                                nuevoPrecio[1]
                                                    .replaceAll(',', '');
                                            var precioAdouble =
                                                double.parse(precioFormateado);

                                            Producto nuevoProducto = Producto(
                                              nombre: nombre!,
                                              imagen: imagepath ?? '',
                                              categoria: categoriaSeleccionada!,
                                              marca: marcaSeleccionada ?? 0,
                                              medida: medidaSeleccionada!,
                                              proveedor: proveedorSeleccionado!,
                                              cantidad: cantidad!,
                                              unidad: medidaSeleccionada!
                                                  .toString(),
                                              precio: precioAdouble,
                                              estado: 1,
                                              updatedAt: fecha,
                                            );

                                            final (
                                              success,
                                              data
                                            ) = await dataCubit
                                                .agregarProducto(nuevoProducto);

                                            if (success == true) {
                                              await dataCubit.traerProductos();
                                              router.pop();
                                            }

                                            // Copiar la imagen al directorio correspondiente solo si se guarda el producto
                                        
                                          },
                                          icon: const Icon(Icons.add_circle),
                                          label:
                                              const Text('Agregar Producto')),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ))),
        ]),
      ),
    );
  }
}
