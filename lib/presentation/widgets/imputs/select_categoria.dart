// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:control_app/domain/entities/producto_entitie.dart';
import 'package:control_app/presentation/widgets/imputs/custom_dropdown.dart';
import 'package:flutter/material.dart';

import 'package:control_app/domain/entities/categorias_intitie.dart';

class SelectCategoria extends StatefulWidget {
  final List<Categoria>? categorias;
  final Producto? producto;
  final int? initialValue;
  final int? tipoIvaSeleccionado;
  final void Function(int?)? onChanged;
  const SelectCategoria({
    super.key,
    required this.categorias,
    this.producto,
    this.initialValue,
    required this.tipoIvaSeleccionado,
    required this.onChanged,
  });

  @override
  SelectCategorias createState() => SelectCategorias();
}

class SelectCategorias extends State<SelectCategoria> {
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
      value:widget.producto != null ? widget.producto?.categoria : selectedOption ,
      onChanged: widget.onChanged,
      items: dropdownItemsTipolicencia,
    );
  }
}
