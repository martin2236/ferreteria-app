import 'package:control_app/presentation/widgets/imputs/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/producto_entitie.dart';
import '../../../domain/entities/proveedor_entitie.dart';

class SelectProveedor extends StatefulWidget {
  final List<Proveedor>? proveedores;
  final Producto? producto;
  final int? proveedorSeleccionado;
  final void Function(int?)? onChanged;
  const SelectProveedor({
    super.key,
    required this.proveedores,
    this.producto,
    required this.proveedorSeleccionado,
    required this.onChanged,
  });

  @override
  SelectProveedores createState() => SelectProveedores();
}

class SelectProveedores extends State<SelectProveedor> {
  int? selectedOption;
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> dropdownItemsTipolicencia =
        widget.proveedores!.map((proveedor) {
      return DropdownMenuItem<int>(
        value: proveedor.id,
        child: Text(
          proveedor.nombre,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }).toList();
    return CustomDropdown(
      label: 'PROVEEDORES',
      value:widget.producto != null ? widget.producto?.proveedor : selectedOption ,
      onChanged: widget.onChanged,
      items: dropdownItemsTipolicencia,
    );
  }
}

