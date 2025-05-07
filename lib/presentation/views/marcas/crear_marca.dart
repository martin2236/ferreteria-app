import 'dart:io';


import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/categorias_intitie.dart';
import '../../../domain/entities/marca_entitie.dart';
import '../../widgets/widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';

int _toSecondsSinceEpoch(dynamic dateTime) {
  return dateTime.millisecondsSinceEpoch ~/ 1000;
}

class CrearMarcaScreen extends StatefulWidget {
  const CrearMarcaScreen({super.key});

  @override
  State<CrearMarcaScreen> createState() => _CrearMarcaScreenState();
}

class _CrearMarcaScreenState extends State<CrearMarcaScreen> {
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
  String pantalla = "categorias";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = Theme.of(context).textTheme;
    final dataCubit = context.watch<DataCubit>();
    final marcas = dataCubit.state.marcas ?? [];

       Future<void> seleccionarImagen() async {
    // Definir el directorio base
    final Directory baseDir = Directory('./images/$pantalla');
    
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
                        'Nueva Categoria',
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     GestureDetector(
                        onTap: () => seleccionarImagen(),
                        child: DottedBorder(
                          dashPattern: const [9, 9, 9, 9],
                          color: Colors.purple,
                          strokeWidth: 2,
                          child: imagepath != null
                              ? Container(
                                  height: size.width * 0.2,
                                  width: size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                  ),
                                  child: Image(
                                    image: FileImage(File(imagepath!)),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  height: size.width * 0.2,
                                  width: size.width * 0.2,
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
                      SizedBox(height: 50),
                       SizedBox(
                                  width: size.width * 0.2,
                                    child: SizedBox(
                                      height: 80,
                                      child: InputSugestion(
                                        sugerencia: TipoSugerencia.producto,
                                        titulo: 'NOMBRE DE LA MARCA',
                                        marcas: marcas,
                                        onValueChanged: (value) => setState(() {
                                          nombre = value;
                                        }),
                                      ),
                                    ),
                                  ),
                                   SizedBox(
                                     width: size.width * 0.2,

                                     child: FilledButton.icon(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                        Colors.purple)),
                                            onPressed: () async {
                                               if (imagepath != null) {
                                              final Directory baseDir = Directory('./images/$pantalla');
                                              final String timestamp = DateTime.now().millisecondsSinceEpoch.toString(); // Obtener timestamp
                                              final String destinationPath = '${baseDir.path}/$timestamp${File(imagepath!).uri.pathSegments.last}';
                                           
                                              // Copiar la imagen al directorio correspondiente
                                              await File(imagepath!).copy(destinationPath);
                                              setState(() {
                                                imagepath = destinationPath;
                                              });
                                            }
                                               final fecha = _toSecondsSinceEpoch(DateTime.now());

                                             final nuevaMarca = Marca(
                                              nombre: nombre ?? '',
                                              imagen: imagepath ?? '',
                                              updatedAt: fecha,
                                              deletedAt: null
                                            );

                                            final (success,data) = await dataCubit.agregarMarca(nuevaMarca);

                                            if(success == true){
                                              await dataCubit.traerMarcas();
                                              context.pop();
                                            }
                                               
                                            },
                                            icon: const Icon(Icons.add_circle),
                                            label: const Text('Agregar Marca')),
                                   ),
                      
                    ],
                  ))),
        ]),
      ),
    );
  }
}





