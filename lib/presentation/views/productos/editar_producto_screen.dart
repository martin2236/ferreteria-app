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

int _toSecondsSinceEpoch(dynamic dateTime) {
  return dateTime.millisecondsSinceEpoch ~/ 1000;
}

class EditarProductoScreen extends StatefulWidget {
  final String id;
  const EditarProductoScreen({super.key, required this.id});

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  String? result;
  String? categoria;
  //datos del producto
  String? nombre;
  int? categoriaSeleccionada;
  int? medidaSeleccionada;
  int? proveedorSeleccionado;
  int? marcaSeleccionada;
  String? imagepath;
  String? imagepathAnterior;
  String? productoName;
  String? cantidad;
  int? fkUnidad;
  int? fkProveedor;
  String? precio;
  bool imagenEditable = false;
  Producto? productoWidget;
  final TextEditingController _cantidadController = TextEditingController();
  final CurrencyTextFieldController _precioController =
      CurrencyTextFieldController(
    currencySymbol: "\$",
    decimalSymbol: ".",
    thousandSymbol: ",",
  );

  @override
  void initState() {
    super.initState();

    final dataCubit = context.read<DataCubit>();
    final productos = dataCubit.state.productos ?? [];
    final producto =
        productos.firstWhere((element) => element.id.toString() == widget.id);
    productoWidget = producto;

    // Asignar valores a los controladores
    _cantidadController.text = producto.cantidad.toString();
    _precioController.text = producto.precio.toStringAsFixed(2);

    // Asignar valores a las variables
    categoriaSeleccionada = producto.categoria;
    medidaSeleccionada = producto.medida;
    proveedorSeleccionado = producto.proveedor;
    nombre = producto.nombre;
    precio = producto.precio.toString();
    cantidad = producto.cantidad.toString();
    marcaSeleccionada = producto.marca;
   producto.imagen == '' ? imagepath = "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg" :imagepath = producto.imagen;
    imagepathAnterior = producto.imagen;
    producto.imagen == '' ? imagenEditable = false : imagenEditable = true;
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
                              ? imagepath!.startsWith('https://')
                                  ? Container(
                                      height: size.width * 0.3,
                                      width: size.width * 0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade50,
                                      ),
                                      child: Image.network(
                                        imagepath!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
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
                                        valorInicial: productoWidget?.nombre,
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
                                          controller: _cantidadController,
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
                                        controller: _precioController,
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
                                        producto: productoWidget,
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
                                        producto: productoWidget,
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
                                        producto: productoWidget,
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
                                        producto: productoWidget,
                                        onChanged: (int? value) {
                                          // registerCubit.clientIvaChanged(value!);
                                          setState(() {
                                            proveedorSeleccionado = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
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
                               

                                              final Directory baseDir =
                                                Directory('./images/productos');
                                            // Verificar si la carpeta existe; si no, crearla
                                            if (!await baseDir.exists()) {
                                              await baseDir.create(
                                                  recursive: true);
                                            }

                                          if(imagepathAnterior == ''){
                                            final String timestamp = DateTime
                                                    .now()
                                                .millisecondsSinceEpoch
                                                .toString(); // Obtener timestamp
                                            final String destinationPath =
                                                '${baseDir.path}/$timestamp${File(imagepath!).uri.pathSegments.last}';
                                            // Copiar la imagen al directorio correspondiente
                                            await File(imagepath!)
                                                .copy(destinationPath);
                                            setState(() {
                                              imagepath = destinationPath;
                                            });
                                          }

                                          if (imagepath != null &&
                                              imagepath != imagepathAnterior &&
                                              imagenEditable == true) {
                                            final File previousFile =
                                                File(imagepathAnterior ?? '');

                                            if (await previousFile.exists()) {
                                              try {
                                                await previousFile.delete();
                                                debugPrint(
                                                    'Imagen anterior eliminada: $imagepathAnterior');
                                              } catch (e) {
                                                debugPrint(
                                                    'Error al eliminar la imagen anterior: $e');
                                              }
                                            }

                                            final String timestamp = DateTime
                                                    .now()
                                                .millisecondsSinceEpoch
                                                .toString(); // Obtener timestamp
                                            final String destinationPath =
                                                '${baseDir.path}/$timestamp${File(imagepath!).uri.pathSegments.last}';
                                            // Copiar la imagen al directorio correspondiente
                                            await File(imagepath!)
                                                .copy(destinationPath);
                                            setState(() {
                                              imagepath = destinationPath;
                                            });
                                          }

                                            int fecha = _toSecondsSinceEpoch(
                                                DateTime.now());
                                            double precioBack;
                                            if(precio != null && precio!.isNotEmpty && precio!.contains('\$')){
                                              var nuevoPrecio =
                                                precio!.split(' ');
                                            var precioFormateado =
                                                nuevoPrecio[1]
                                                    .replaceAll(',', '');
                                             precioBack =
                                                double.parse(precioFormateado);
                                            }
                                            else {
                                              precioBack = double.parse(precio!);

                                            }


                                            Producto nuevoProducto = Producto(
                                              id: int.parse(widget.id),
                                              nombre: nombre?? '',
                                              imagen: imagepath!,
                                              categoria: categoriaSeleccionada!,
                                              marca: marcaSeleccionada ?? 0,
                                              medida: medidaSeleccionada!,
                                              proveedor: proveedorSeleccionado!,
                                              cantidad: cantidad!,
                                              unidad: medidaSeleccionada!
                                                  .toString(),
                                              precio: precioBack,
                                              estado: 1,
                                              updatedAt: fecha,
                                            );

                                            final (
                                              success,
                                              data
                                            ) = await dataCubit
                                                .updateProducto(nuevoProducto);
                                            if (success == true) {
                                              await dataCubit.traerProductos();
                                              router.pop();
                                            }
                                          
                                          },
                                          icon: const Icon(Icons.add_circle),
                                          label: const Text('Editar Producto')),
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
