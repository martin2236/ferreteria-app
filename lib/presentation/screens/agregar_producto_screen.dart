


import 'dart:io';

import 'package:control_app/config/config.dart';
import 'package:control_app/domain/entities/categorias_intitie.dart';
import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/medida_entitite.dart';
import '../../domain/entities/producto_entitie.dart';
import '../widgets/imputs/custom_dropdown.dart';
import '../widgets/imputs/input_sugestion.dart';
import '../widgets/widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:currency_textfield/currency_textfield.dart';

int toSecondsSinceEpoch(dynamic dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  String? result;
  String? categoria;
  //datos del producto
  String? nombre;
  int? categoriaSeleccionada;
  int? unidadSeleccionada;
  late String? imagepath = null;
  String? productoName;
  String? cantidad;
  int? fkUnidad;
  String? precio;
   CurrencyTextFieldController _currencyController = CurrencyTextFieldController(
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
    final medidas = dataCubit.state.medidas;
    final productos = dataCubit.state.productos ?? [];

    void _showImageDialog(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            FilledButton.icon(icon:const Icon(Icons.camera_alt_rounded),onPressed: ()async{
              Navigator.pop(context);
             final path =  await CameraPlugin().takePhoto();
              setState(() {
                imagepath = path;
              });
            }, label: const Text('Tomar foto')),
            FilledButton.icon(
              icon: const Icon(Icons.image_search),
              onPressed: (){
                Navigator.pop(context);
                CameraPlugin().selectPhoto();
              }, 
              label: const Text('Abrir galería')
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    ),
  );
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
              ],
            ),
          ),
          Form(
            child: Container(
              height : size.height * 0.80,
              width: size.width * 0.88,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.03),
                  GestureDetector(
                    onTap: () => _showImageDialog(context),
                    child: DottedBorder(
                       dashPattern: const [9, 9, 9, 9],
                       color: Colors.purple,
                       strokeWidth: 2,
                      child:imagepath != null ?  
                      Image(image: FileImage(File(imagepath!)),
                      height: size.width * 0.4,
                      width: size.width * 0.8,
                      ) 
                      :  
                      Container(
                        height: size.width * 0.4,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.image_rounded,size: size.height * 0.05, color: Colors.purple,),
                            Text('Toca para agregar imagen', style:text.titleSmall!.copyWith(color: Colors.purple),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),

                   SizedBox(
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
                      
                  SizedBox(
                          height: 80,
                          child: _SelectCategoria(
                            categorias: categorias,
                            tipoIvaSeleccionado: categoriaSeleccionada,
                            onChanged: (int? value) {
                            // registerCubit.clientIvaChanged(value!);
                              setState(() {
                                categoriaSeleccionada = value;
                              });
                            },
                          ),
                        ),
                    
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 80,
                      width: size.width * 0.43,
                      child: CustomTextFormField(
                        onChanged: (value){  
                          setState(() {
                          cantidad = value.toString();
                        });
                        },
                        hint: 'CANTIDAD',
                        alignText: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                      
                     SizedBox(
                          height: 80,
                          width: size.width * 0.43,
                          child: _SelectMedida(
                            categorias: medidas,
                            tipoIvaSeleccionado: unidadSeleccionada,
                            onChanged: (int? value) {
                              setState(() {
                                unidadSeleccionada = value;
                              });
                            },
                          ),
                        )
                    
                  ],
                 ),
                 
                 SizedBox(
                  height: 80,
                  width: size.width,
                   child: CustomTextFormField(
                    controller: _currencyController,
                    onChanged: (value){
                      setState(() {
                        precio = value;
                      });
                    },
                    hint: 'PRECIO',
                    alignText: true,
                    keyboardType: TextInputType.number,
                   ),
                 ),
                 
                  
                  
                SizedBox(
                  height: 50,
                  width: size.width,
                   child:FilledButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.purple)
                    ) ,
                    onPressed: (){
                      int fecha = toSecondsSinceEpoch(DateTime.now());
                     
                      var nuevoPrecio = precio!.split(' ');
                      var precioFormateado = nuevoPrecio[1].replaceAll(',', '');
                      var precioAdouble = double.parse(precioFormateado);

                      Producto nuevoProducto = Producto(
                        nombre: nombre!, 
                        imagen: imagepath!, 
                        categoria: categoriaSeleccionada!.toString(), 
                        cantidad: cantidad!, 
                        unidad: unidadSeleccionada!.toString(), 
                        precio: precioAdouble, 
                        estado: 1, 
                        updatedAt: fecha, 
                        );
                       
                      dataCubit.agregarProducto(nuevoProducto);
                      router.pop();
                    },
                    icon:const Icon(Icons.add_circle),
                    label: const Text('Agregar Producto')
                    ),
                 ),
                
              ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}



class _SelectMedida extends StatefulWidget {
  final List<Medida>? categorias;
  final int? tipoIvaSeleccionado;
  final void Function(int?)? onChanged;
  const _SelectMedida({
    required this.categorias,
    required this.tipoIvaSeleccionado,
    required this.onChanged,
  });

  @override
  _SelectTiposDeCuit createState() => _SelectTiposDeCuit();
}

class _SelectTiposDeCuit extends State<_SelectMedida> {
  int? selectedOption;
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> dropdownItemsTipolicencia =
        widget.categorias!.map((tipoDeCuit) {
      return DropdownMenuItem<int>(
        value: tipoDeCuit.id,
        child: Text(
          tipoDeCuit.nombre,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }).toList();
    return CustomDropdown(
      label: 'UNIDAD',
      value: selectedOption,
      onChanged: widget.onChanged,
      items: dropdownItemsTipolicencia,
    );
  }
}

class _SelectCategoria extends StatefulWidget {
  final List<Categoria>? categorias;
  final int? tipoIvaSeleccionado;
  final void Function(int?)? onChanged;
  const _SelectCategoria({
    required this.categorias,
    required this.tipoIvaSeleccionado,
    required this.onChanged,
  });

  @override
  _SelectCategorias createState() => _SelectCategorias();
}

class _SelectCategorias extends State<_SelectCategoria> {
  int? selectedOption;
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> dropdownItemsTipolicencia =
        widget.categorias!.map((tipoDeCuit) {
      return DropdownMenuItem<int>(
        value: tipoDeCuit.id,
        child: Text(
          tipoDeCuit.nombre,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }).toList();
    return CustomDropdown(
      label: 'CATEGORIAS',
      value: selectedOption,
      onChanged: widget.onChanged,
      items: dropdownItemsTipolicencia,
    );
  }
}