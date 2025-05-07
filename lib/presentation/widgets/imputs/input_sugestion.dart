import 'package:control_app/domain/entities/marca_entitie.dart';
import 'package:flutter/material.dart';
import 'package:field_suggestion/field_suggestion.dart';

import '../../../domain/entities/categorias_intitie.dart';
import '../../../domain/entities/compras_entitie.dart';
import '../../../domain/entities/producto_entitie.dart';
import '../../../domain/entities/proveedor_entitie.dart';

enum TipoSugerencia {compra, producto, proveedor,categoria,marca}

class InputSugestion extends StatefulWidget {
  final String? titulo;
  final String? label;
  final TipoSugerencia sugerencia;
  final List<Compra>? compras;
  final List<Categoria>? categorias;
  final List<Proveedor>? proveedores;
  final List<Producto>? productos;
  final List<Marca>? marcas;
  final Function? onValueChanged;
  final String? valorInicial; // Nuevo parámetro para el valor inicial

  const InputSugestion({
    super.key,
    this.titulo,
    this.label,
    this.onValueChanged,
    required this.sugerencia,
    this.compras,
    this.productos,
    this.categorias,
    this.proveedores,
    this.marcas,
    this.valorInicial, // Aceptar valor inicial
  });

  @override
  InputSugestionState createState() => InputSugestionState();
}

class InputSugestionState extends State<InputSugestion> {
  var strSuggestions;

  final boxController = BoxController();
  final boxControllerNetwork = BoxController();
  late final TextEditingController textControllerNetwork; // Marcado como late

  @override
  void initState() {
    super.initState();

    // Inicializar sugerencias dependiendo del tipo
    if (widget.sugerencia == TipoSugerencia.compra) {
      strSuggestions = widget.compras;
    } else if(widget.sugerencia == TipoSugerencia.categoria){
      strSuggestions = widget.categorias;
    }else if(widget.sugerencia == TipoSugerencia.proveedor){
      strSuggestions = widget.proveedores;
    }else if(widget.sugerencia == TipoSugerencia.marca){
      strSuggestions = widget.marcas;
    }else {
      strSuggestions = widget.productos;
    }

    // Inicializar el controlador con el valor inicial
    textControllerNetwork = TextEditingController(
      text: widget.valorInicial ?? '', // Usar valor inicial si se proporciona
    );
  }

  Future<List<Map<String, dynamic>>> future(String input) async {
    try {
      if (strSuggestions == null || strSuggestions.isEmpty) {
        return [];
      }

      return Future<List<Map<String, dynamic>>>.delayed(
        const Duration(seconds: 1),
        () {
          if (widget.sugerencia == TipoSugerencia.compra) {
            return (strSuggestions as List<Compra>)
                .where((s) => s.nombre.toLowerCase().contains(input.toLowerCase()))
                .map((s) => {'id': s.id, 'nombre': s.nombre})
                .toList();
          }else if (widget.sugerencia == TipoSugerencia.categoria) {
            return (strSuggestions as List<Categoria>)
                .where((s) => s.nombre.toLowerCase().contains(input.toLowerCase()))
                .map((s) => {'id': s.id, 'nombre': s.nombre})
                .toList();
          }else if (widget.sugerencia == TipoSugerencia.proveedor) {
            return (strSuggestions as List<Proveedor>)
                .where((s) => s.nombre.toLowerCase().contains(input.toLowerCase()))
                .map((s) => {'id': s.id, 'nombre': s.nombre})
                .toList();
          } else if (widget.sugerencia == TipoSugerencia.producto) {
            return (strSuggestions as List<Producto>)
                .where((s) => s.nombre.toLowerCase().contains(input.toLowerCase()))
                .map((s) => {'id': s.id, 'nombre': s.nombre})
                .toList();
          } else if (widget.sugerencia == TipoSugerencia.marca) {
            return (strSuggestions as List<Marca>)
                .where((s) => s.nombre.toLowerCase().contains(input.toLowerCase()))
                .map((s) => {'id': s.id, 'nombre': s.nombre})
                .toList();
          } else {
            return [];
          }
        },
      );
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(color: Colors.purple),
    );

    return GestureDetector(
      onTap: () {
        boxController.close?.call();
        boxControllerNetwork.close?.call();
      },
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(left: 5.0),child: Text(widget.label ?? '', style: text.labelLarge!.copyWith(fontWeight: FontWeight.normal),)),
            FieldSuggestion<Map<String, dynamic>>.network(
              future: (input) {
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(input);
                }
                return future(input);
              },
              boxController: boxControllerNetwork,
              textController: textControllerNetwork,
              inputDecoration: InputDecoration(
                hintText: widget.titulo ?? '',
                hintStyle: text.bodyMedium!.copyWith(color: Colors.grey),
              
                enabledBorder: border,
                border: border,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print("Error en el snapshot: ${snapshot.error}");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  final result = snapshot.data ?? [];
                  if (result.isEmpty) {
                    return const Center(child: Text("No hay sugerencias"));
                  }

                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      final suggestion = result[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() => textControllerNetwork.text = suggestion['nombre']);
                          textControllerNetwork.selection = TextSelection.fromPosition(
                            TextPosition(offset: textControllerNetwork.text.length),
                          );
                          boxControllerNetwork.close?.call();
                        },
                        child: Card(
                          child: ListTile(title: Text(suggestion['nombre'])),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("Error al cargar sugerencias"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
