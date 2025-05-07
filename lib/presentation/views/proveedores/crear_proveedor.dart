import 'dart:io';


import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_field/core/multi_select.dart';
import '../../../domain/entities/proveedor_entitie.dart';
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


class CrearProveedorScreen extends StatefulWidget {
  const CrearProveedorScreen({super.key});

  @override
  State<CrearProveedorScreen> createState() => _CrearProveedorScreenState();
}

class _CrearProveedorScreenState extends State<CrearProveedorScreen> {
  String? result;
  String? categoria;
  //datos del producto
  String? nombre;
  int? diaSeleccionado;
  int? medidaSeleccionada;
  String? imagepath;
  String? proveedorName;
  List<Choice<String>> diasSeleccionados = [];
   String? telefono;
   String? email;
   Color colorPickerColor = Colors.purple;
   String pantalla = "proveedores";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = Theme.of(context).textTheme;
    final dataCubit = context.watch<DataCubit>();
    final proveedores = dataCubit.state.proveedores ?? [];

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
                        'Nuevo Proveedor',
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
                                        label: 'Nombre del proveedor',
                                        titulo: 'NOMBRE DEL PROVEEDOR',
                                        proveedores: proveedores,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                   
                                       Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: MultiSelectField<String>(
                                        data: () => _dias.map((e) => Choice<String>(e, e)).toList(),
                                        defaultData: diasSeleccionados, // Valores seleccionados por defecto
                                        onSelect: (selectedItems, isFromDefaultData) {
                                         
                                          setState(() {
                                            diasSeleccionados = selectedItems;
                                          });
                                        },
                                        title: (isEmpty) =>
                                            Text(isEmpty ? 'Seleccione una opción' : 'Opciones seleccionadas'),
                                        singleSelection: false, // Permitir selección múltiple
                                        useTextFilter: true, // Habilitar búsqueda
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.purple),
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        multiSelectWidget: (item) => Chip(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.purple.shade50,
                                          label: Text(item.value),
                                        ),
                                      ),
                                    ),
                                  ),
                               
                                Expanded(
                                  child: _MaterialColorPickerExample(pickerColor: colorPickerColor, onColorChanged: (color) {
                                    
                                    setState(() {
                                      colorPickerColor = color;
                                    });
                                  }),
                                ),
                               
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                              final Directory baseDir = Directory('./images/$pantalla');
                                              final String timestamp = DateTime.now().millisecondsSinceEpoch.toString(); // Obtener timestamp
                                              final String destinationPath = '${baseDir.path}/$timestamp${File(imagepath!).uri.pathSegments.last}';
                                           
                                              // Copiar la imagen al directorio correspondiente
                                              await File(imagepath!).copy(destinationPath);
                                              setState(() {
                                                imagepath = destinationPath;
                                              });
                                            }
                                           
                                            final nuevoProveedor = Proveedor(
                                              nombre: nombre!, 
                                              telefono: telefono ?? '', 
                                              email: email ?? '', 
                                              visita: diasSeleccionados.map((e) => _dias.indexOf(e.value) + 1).toList(),
                                              color: colorPickerColor.toString(),
                                              imagen: imagepath?? '',
                                              updatedAt: _toSecondsSinceEpoch(DateTime.now()),
                                              deletedAt: null
                                              );
                                         final (success, data) = await dataCubit.agregarProveedor(nuevoProveedor);
                                            if(success == true){
                                              await dataCubit.traerProveedores();
                                              context.pop();
                                            }
                                          },
                                          icon: const Icon(Icons.add_circle),
                                          label: const Text('Agregar Proveedor')),
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



class _MaterialColorPickerExample extends StatefulWidget {
  const _MaterialColorPickerExample({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  @override
  State<_MaterialColorPickerExample> createState() => __MaterialColorPickerExampleState();
}

class __MaterialColorPickerExampleState extends State<_MaterialColorPickerExample> {
  bool _enableLabel = true;
  bool _portraitOnly = true;

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
                            widget.onColorChanged(color);
                            Navigator.pop(context); // Cierra el modal al seleccionar un color
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
                child:const Text(
                'Seleccionar color de identificación',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}