import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<DropdownMenuItem<int>> items;
  final int? value;
  final void Function(int?)? onChanged;
  final String? errorMessage;
  final Widget? prefixIcon;
  final String? Function(int?)? validator;
  final String? initialValue;

  const CustomDropdown({
    super.key,
    this.label,
    this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.errorMessage,
    this.prefixIcon,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(color: Colors.purple),
    );

    return DropdownButtonFormField<int>(
      validator: validator,
      isExpanded: true,
      isDense: true,
      focusColor: Colors.transparent,
      value: value,
      onChanged: onChanged,
      enableFeedback: false, // Desactiva el feedback visual/sonoro
      items: items.map((item) {
        return DropdownMenuItem<int>(
          value: item.value,
          child: Container(
            color: Colors.transparent, // Sin efecto de hover
            child: item.child,
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder:
            border.copyWith(borderSide: BorderSide(color: colors.primary)),
        errorBorder:
            border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        filled: true,
        isDense: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: text.labelLarge!.copyWith(color: Colors.black26),
        floatingLabelStyle: text.labelLarge!.copyWith(color: colors.primary),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: hint,
        hintStyle: text.labelLarge!.copyWith(color: Colors.black26),
        errorText: errorMessage,
        focusColor: colors.primary,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 12.0,
        ),
        prefixIcon: prefixIcon,
      ),
    );
  }
}
