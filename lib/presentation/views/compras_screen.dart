// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:control_app/presentation/widgets/header.dart';

class ComprasScreen extends StatelessWidget {
  const ComprasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = Theme.of(context).textTheme;
    return Scaffold(
        body: Column(
          children:[
            SizedBox(
              height: size.height * 0.20,
              width: size.width,
              child: Stack(
                    children: [
                      SizedBox(
                        height: size.height,
                        child:const HeaderWaves(),
                      ),
                       Positioned(
            top: size.height * 0.06,
            child: SizedBox(
              width: size.width,
              child: Text('Mis Compras',
              style: GoogleFonts.lobster(
                  textStyle: text.displaySmall!.copyWith(color: Colors.white),
                ),
                textAlign: TextAlign.center,
              ),
            )
            ),
                    ],
              ),
            ),
              Container(
              height: size.height * 0.70,
              width:size.width,
              child: const Column(children: [
                  _Calendar(),
                  _ComprasContainer()
              ],
              )
            )
            ]
        ),
    );
  }
}

class _Calendar extends StatefulWidget {
  const _Calendar({super.key});

  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
 DateTime? _focusDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    const Color fillColor = Colors.purple;

    return EasyInfiniteDateTimeLine(
      selectionMode: const SelectionMode.autoCenter(),
      firstDate: DateTime(2024),
      focusDate: _focusDate,
      locale: 'es',
      lastDate: DateTime(2050, 12, 31),
      onDateChange: (selectedDate) {
        setState(() {
          _focusDate = selectedDate;
        });
      },
      
      dayProps: const EasyDayProps(
        // You must specify the width in this case.
        width: 64.0,
        // The height is not required in this case.
        height: 64.0,
      ),
      itemBuilder: (
        BuildContext context,
        DateTime date,
        bool isSelected,
        VoidCallback onTap,
      ) {
        return InkResponse(
          // You can use `InkResponse` to make your widget clickable.
          // The `onTap` callback responsible for triggering the `onDateChange`
          // callback and animating to the selected date if the `selectionMode` is
          // SelectionMode.autoCenter() or SelectionMode.alwaysFirst().
          onTap: onTap,
          child: CircleAvatar(
            // use `isSelected` to specify whether the widget is selected or not.
            backgroundColor:
                isSelected ? fillColor : fillColor.withOpacity(0.1),
            radius: 32.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    EasyDateFormatter.shortDayName(date, "es"),
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Compra {
final String titulo;
final String fecha;
final double monto;
final IconData icono;

  Compra({
    required this.titulo,
    required this.fecha,
    required this.monto,
    required this.icono
  });
}

final List<Compra> compras = [
  Compra(titulo: 'coto', fecha: '10/04/2024',monto:23.500, icono: Icons.shopping_bag),
   Compra(titulo: 'ypf',fecha: '10/04/2024',monto:6.000, icono: Icons.shopping_bag),
    Compra(titulo: 'supermercado Mayo',fecha: '10/04/2024',monto:12.000, icono: Icons.shopping_bag),
     Compra(titulo: 'Supermercado Las Chicas',fecha: '10/04/2024',monto:3.000, icono: Icons.shopping_bag),
     Compra(titulo: 'Supermercado Molina',fecha: '10/04/2024',monto:8.315, icono: Icons.shopping_bag),
];

class _ComprasContainer extends StatelessWidget {
  const _ComprasContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.height * 0.55,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
          itemCount: compras.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            mainAxisSpacing: 10.0, 
            crossAxisSpacing: 10.0, 
          ),
          itemBuilder: (context, index) => _CompraCard(compra: compras[index]),
                ),
        ),
    );
    
  }
}

class _CompraCard extends StatelessWidget {
  final Compra compra;
  const _CompraCard({required this.compra});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(compra.icono,size: 30,),
          Text(compra.titulo, textAlign: TextAlign.center,),
          Text('\$${compra.monto.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}