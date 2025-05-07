import 'package:control_app/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/medida_entitite.dart';
import '../../../domain/entities/producto_entitie.dart';

class SelectMedida extends StatefulWidget {
  final List<Medida>? medidas;
  final Producto? producto;
  final int? tipoIvaSeleccionado;
  final void Function(int?)? onChanged;
  const SelectMedida({
    super.key,
    required this.medidas,
    this.producto,
    required this.tipoIvaSeleccionado,
    required this.onChanged,
  });

  @override
  SelectTiposDeMedida createState() => SelectTiposDeMedida();
}

class SelectTiposDeMedida extends State<SelectMedida> {
  int? selectedOption;
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> dropdownItemsTipolicencia =
        widget.medidas!.map((tipoDeCuit) {
      return DropdownMenuItem<int>(
        value: tipoDeCuit.id,
        child: Text(
          tipoDeCuit.nombre,
          style: const TextStyle(fontSize: 14, backgroundColor: Colors.transparent,),
        ),
      );
    }).toList();
    return CustomDropdown(
      label: 'UNIDAD',
      value:widget.producto != null ? widget.producto?.medida : selectedOption ,
      onChanged: widget.onChanged,
      items: dropdownItemsTipolicencia,
    );
  }
}