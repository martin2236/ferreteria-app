import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {

    final String? label;
    final String? hint;
    final String? errorMessage;
    final Function(String)? onChanged;
    final String? Function(String?)? validator;
    final bool? obscureText;
    final Widget? icon;
    final String? initialValue;
    final TextInputType? keyboardType;
    final Widget? suffixIcon;
    final TextStyle? hintStyle;
    final TextStyle? labelStyle;
    final Color? fillColor;
    final bool alignText;
    final Function(PointerDownEvent)? onTapOutside;
    final void Function()? onEditingComplete;
    final TextCapitalization? capitalization;
    final TextEditingController? controller;

    const CustomTextFormField({
      super.key, 
      this.label, 
      this.hint, 
      this.errorMessage, 
      this.onChanged, 
      this.validator, 
      this.obscureText, 
      this.icon,
      this.suffixIcon,
      this.initialValue,
      this.keyboardType,
      this.hintStyle,
      this.labelStyle,
      this.fillColor,
      this.onTapOutside,
      this.alignText = false,
      this.onEditingComplete,
      this.capitalization,
      this.controller
      });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {

   bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText ?? false;
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(color: Colors.purple)
    );
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      onTapOutside: widget.onTapOutside ,
      onEditingComplete:widget.onEditingComplete,
      validator: widget.validator,
       initialValue: widget.controller == null ? widget.initialValue : null,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.capitalization ?? TextCapitalization.none,
      textAlign: widget.alignText ? TextAlign.center : TextAlign.start,
      obscureText: _isObscured,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: BorderSide(color: colors.primary)),
        errorBorder: border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        focusedErrorBorder: border,
        filled: true,
        isDense: true,
        fillColor:widget.fillColor ?? Colors.white,
        label: widget.label != null ? Text(widget.label!) : null,
        labelStyle:widget.labelStyle ?? text.labelLarge!.copyWith(color: Colors.black26,),
        floatingLabelStyle: text.labelLarge!.copyWith(color: colors.primary),
        alignLabelWithHint: true,
        suffixIcon: widget.suffixIcon ?? (widget.obscureText == true ? IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility : Icons.visibility_off,
                color: Colors.black26,
              ),
              onPressed: _toggleObscureText,
            ) : null),
        hintText: widget.hint,
        hintStyle:widget.hintStyle ?? const TextStyle(color: Colors.black26),
        errorText: widget.errorMessage,
        focusColor: colors.primary,
        prefixIcon:  widget.icon
      ),
    );
  }
}