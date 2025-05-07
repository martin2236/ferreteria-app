import 'dart:io';

import 'package:control_app/domain/entities/proveedor_entitie.dart';
import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'package:multiselect_field/multiselect_field.dart';
import '../../widgets/widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';

final _dias = [
  "lunes",
  "martes",
  "miercoles",
  "jueves",
  "viernes",
  "sabado",
  "domingo"
];

int _toSecondsSinceEpoch(dynamic dateTime) {
  return dateTime.millisecondsSinceEpoch ~/ 1000;
}

class EditarProveedorScreen extends StatefulWidget {
  final String id;
  const EditarProveedorScreen({super.key, required this.id});

  @override
  State<EditarProveedorScreen> createState() => _EditarProveedorScreenState();
}

class _EditarProveedorScreenState extends State<EditarProveedorScreen> {
  String? result;
  String? categoria;
  //datos del producto
  String? nombre;
  int? diaSeleccionado;
  int? medidaSeleccionada;
  String? imagepath;
  String? proveedorName;
  List<Choice<String>> diasSeleccionados = [];
  Proveedor? proveedorWidget;
  String? telefono;
  String? email;
  Color colorPickerColor = Colors.purple;
  final controller = MultiSelectController<int>();
  String imagepathAnterior = '';
  String pantalla = 'proveedores';
  bool imagenEditable = false;

  @override
  void initState() {
    super.initState();
    final dataCubit = context.read<DataCubit>();
    final proveedores = dataCubit.state.proveedores ?? [];
    final proveedor =
        proveedores.firstWhere((element) => element.id.toString() == widget.id);
    proveedorWidget = proveedor;

    imagepath = proveedor.imagen;
    telefono = proveedor.telefono;
    nombre = proveedor.nombre;
    email = proveedor.email;
    imagepathAnterior = proveedor.imagen;
    colorPickerColor = parseColorFromString(proveedor.color);
    final diasBackend = proveedor.visita ?? [];
    if (diasBackend.isNotEmpty) {
      diasSeleccionados = diasBackend
          .map((e) => Choice<String>(_dias[e - 1], _dias[e - 1]))
          .toList();
    } else {
      diasSeleccionados = [];
    }
    proveedor.imagen == '' ? imagenEditable = false : imagenEditable = true;
    proveedor.imagen == ''
        ? imagepath =
            "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
        : imagepath = proveedor.imagen;
  }

  Color parseColorFromString(String colorString) {
    try {
      final match = RegExp(r'0x[a-fA-F0-9]{8}').firstMatch(colorString);
      if (match != null) {
        final hexColor = match.group(0);
        return Color(int.parse(hexColor!));
      }
    } catch (e) {
      debugPrint("Error parsing color: $e");
    }
    return Colors.purple; // Devuelve null si no es un formato válido.
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = Theme.of(context).textTheme;
    final dataCubit = context.watch<DataCubit>();
    final proveedores = dataCubit.state.proveedores ?? [];

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
                        'Editar Proveedor',
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      SizedBox(
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
                                        label: 'Nombre del proveedor',
                                        titulo: 'NOMBRE DEL PROVEEDOR',
                                        valorInicial: proveedorWidget?.nombre,
                                        proveedores: proveedores,
                                        onValueChanged: (value) {
                                          setState(() {
                                            nombre = value;
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
                                        width: size.width * 0.43,
                                        child: CustomTextFormField(
                                          initialValue: telefono,
                                          onChanged: (value) {
                                            setState(() {
                                              telefono = value.toString();
                                            });
                                          },
                                          label: 'Telefono',
                                          hint: 'TELEFONO',
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
                                        onChanged: (value) {
                                          setState(() {
                                            telefono = value;
                                          });
                                        },
                                        initialValue: email,
                                        label: 'Email',
                                        hint: 'EMAIL',
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
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: MultiSelectField<String>(
                                        data: () => _dias
                                            .map((e) => Choice<String>(e, e))
                                            .toList(),
                                        defaultData:
                                            diasSeleccionados, // Valores seleccionados por defecto
                                        onSelect:
                                            (selectedItems, isFromDefaultData) {
                                          setState(() {
                                            diasSeleccionados = selectedItems;
                                          });
                                        },
                                        title: (isEmpty) => Text(isEmpty
                                            ? 'Seleccione una opción'
                                            : 'Opciones seleccionadas'),
                                        singleSelection:
                                            false, // Permitir selección múltiple
                                        useTextFilter:
                                            true, // Habilitar búsqueda
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.purple),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        multiSelectWidget: (item) => Chip(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor:
                                              Colors.purple.shade50,
                                          label: Text(item.value),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _MaterialColorPickerExample(
                                        pickerColor: colorPickerColor,
                                        onColorChanged: (color) {
                                          setState(() {
                                            colorPickerColor = color;
                                          });
                                        }),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.2,
                                    child: FilledButton.icon(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.purple)),
                                        onPressed: () async {

                                           final Directory baseDir =
                                                Directory('./images/$pantalla');
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
                                                File(imagepathAnterior);

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

                                          final fecha = _toSecondsSinceEpoch(
                                              DateTime.now());

                                          final nuevoProveedor = Proveedor(
                                            id: proveedorWidget?.id,
                                            nombre: nombre ?? '',
                                            imagen: imagepath ?? '',
                                            telefono: telefono ?? '',
                                            email: email ?? '',
                                            color: colorPickerColor.toString(),
                                            visita: diasSeleccionados
                                                .map((e) =>
                                                    _dias.indexOf(e.value) + 1)
                                                .toList(),
                                            updatedAt: fecha,
                                            deletedAt: null,
                                          );

                                          final (success, _) = await dataCubit
                                              .updateProveedor(nuevoProveedor);

                                          if (success == true) {
                                            await dataCubit
                                                .traerProveedores(); // Completa todas las operaciones relacionadas con el estado aquí
                                            if (mounted) {
                                              context
                                                  .pop(); // Llama a `pop` solo cuando el widget aún está montado
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.add_circle),
                                        label: const Text('Editar Proveedor')),
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

class _MaterialColorPickerExample extends StatefulWidget {
  const _MaterialColorPickerExample({
    required this.pickerColor,
    required this.onColorChanged,
  });

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  @override
  State<_MaterialColorPickerExample> createState() =>
      __MaterialColorPickerExampleState();
}

class __MaterialColorPickerExampleState
    extends State<_MaterialColorPickerExample> {
  final bool _enableLabel = true;
  final bool _portraitOnly = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: widget.pickerColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0),
                      contentPadding: const EdgeInsets.all(0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: widget.pickerColor,
                          onColorChanged: (color) {
                            debugPrint('Color: $color');
                            widget.onColorChanged(color);
                            Navigator.pop(
                                context); // Cierra el modal al seleccionar un color
                          },
                          enableLabel: _enableLabel,
                          portraitOnly: _portraitOnly,
                        ),
                      ),
                    );
                  },
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Editar color de identificación',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
