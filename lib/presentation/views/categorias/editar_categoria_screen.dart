import 'dart:io';

import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/categorias_intitie.dart';
import '../../widgets/widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';

int _toSecondsSinceEpoch(dynamic dateTime) {
  return dateTime.millisecondsSinceEpoch ~/ 1000;
}

class EditarCategoriaScreen extends StatefulWidget {
  final String id;
  const EditarCategoriaScreen({super.key, required this.id});

  @override
  State<EditarCategoriaScreen> createState() => _EditarCategoriaScreenState();
}

class _EditarCategoriaScreenState extends State<EditarCategoriaScreen> {
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
  Categoria? categoriaWidget;
  List<Categoria>? categorias;
  final TextEditingController _nombreController = TextEditingController();
  String pantalla = "categorias";
  String imagepathAnterior = '';

  @override
  void initState() {
    super.initState();

    final dataCubit = context.read<DataCubit>();
    categorias = dataCubit.state.categorias ?? [];
    final categoria =
        categorias!.firstWhere((element) => element.id.toString() == widget.id);
    categoriaWidget = categoria;
    categoria.imagen == ''
        ? imagepath =
            "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
        : imagepath = categoria.imagen;
    print(imagepath);
    // Asignar valores a los controladores
    _nombreController.text = categoria.nombre;
    imagepathAnterior = categoria.imagen;
    nombre = categoria.nombre;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = Theme.of(context).textTheme;
    final dataCubit = context.watch<DataCubit>();

    Future<void> seleccionarImagen() async {
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

        // Guardar la ruta de la imagen seleccionada sin copiarla aún
        setState(() {
          imagepath =
              file.path; // Actualiza el path para usar la imagen seleccionada
        });

        debugPrint('Imagen seleccionada: ${file.path}');
      } else {
        debugPrint('No se seleccionó ninguna imagen');
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
                        'Editar Categoria',
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
              child: SizedBox(
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
                              ? imagepath!.startsWith('https://')
                                  ? Container(
                                      height: size.width * 0.2,
                                      width: size.width * 0.2,
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade50,
                                      ),
                                      child: Image.network(
                                        imagepath!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
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
                            sugerencia: TipoSugerencia.categoria,
                            titulo: 'NOMBRE DE LA CATEGORIA',
                            valorInicial: categoriaWidget?.nombre,
                            categorias: categorias,
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
                                    WidgetStateProperty.all(Colors.purple)),
                            onPressed: () async {
                              final Directory baseDir =
                                  Directory('./images/$pantalla');
                              // Verificar si la carpeta existe; si no, crearla
                              if (!await baseDir.exists()) {
                                await baseDir.create(recursive: true);
                              }

                              if (imagepathAnterior == '') {
                                final String timestamp = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(); // Obtener timestamp
                                final String destinationPath =
                                    '${baseDir.path}/$timestamp${File(imagepath!).uri.pathSegments.last}';
                                // Copiar la imagen al directorio correspondiente
                                await File(imagepath!).copy(destinationPath);
                                setState(() {
                                  imagepath = destinationPath;
                                });
                              }

                              if (imagepath != null &&
                                  imagepath != imagepathAnterior &&
                                  imagepath != '') {
                                final String timestamp = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(); // Obtener timestamp
                                final String destinationPath =
                                    '${baseDir.path}/$timestamp${File(imagepath!).uri.pathSegments.last}';
                                // Copiar la imagen al directorio correspondiente
                                await File(imagepath!).copy(destinationPath);
                                setState(() {
                                  imagepath = destinationPath;
                                });
                              }
                              final fecha =
                                  _toSecondsSinceEpoch(DateTime.now());

                              final nuevaCategoria = Categoria(
                                  id: categoriaWidget?.id,
                                  nombre: nombre ?? '',
                                  imagen: imagepath ?? '',
                                  updatedAt: fecha,
                                  deletedAt: null);

                              final (success, _) = await dataCubit
                                  .updateCategoria(nuevaCategoria);

                              if (success == true) {
                                await dataCubit.traerCategorias();
                                if (mounted) {
                                  context
                                      .pop(); // Llama a `pop` solo cuando el widget aún está montado
                                }
                              }
                            },
                            icon: const Icon(Icons.add_circle),
                            label: const Text('Editar Categoria')),
                      ),
                    ],
                  ))),
        ]),
      ),
    );
  }
}
