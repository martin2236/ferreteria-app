import 'package:control_app/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/marca_entitie.dart';
import '../../../domain/entities/producto_entitie.dart';

class SelectMarca extends StatefulWidget {
  final List<Marca>? marcas;
  final Producto? producto;
  final int? marcaSeleccionada;
  final void Function(int?)? onChanged;
  const SelectMarca({
    super.key,
    required this.marcas,
    this.producto,
    required this.marcaSeleccionada,
    required this.onChanged,
  });

  @override
  SelectMarcas createState() => SelectMarcas();
}

class SelectMarcas extends State<SelectMarca> {
  int? selectedOption;
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> dropdownItemsTipolicencia =
        widget.marcas!.map((marca) {
      return DropdownMenuItem<int>(
        value: marca.id,
        child: Text(
          marca.nombre,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }).toList();
    return CustomDropdown(
      label: 'MARCAS',
      value:widget.producto != null ? widget.producto?.marca : selectedOption ,
      onChanged: widget.onChanged,
      items: dropdownItemsTipolicencia,
    );
  }
}
