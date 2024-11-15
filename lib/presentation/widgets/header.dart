import 'package:flutter/material.dart';

class HeaderWaves extends StatelessWidget {
  const HeaderWaves({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      //color: Colors.purple,
      child: CustomPaint(
        painter: _HeaderWavesPainter(),
      ),
    );
  }
}

class _HeaderWavesPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    final lapiz = Paint();

    //propiedades

    lapiz.color = Colors.purple;
    //lapiz.style = PaintingStyle.stroke; //.stroke //.fill
    lapiz.style = PaintingStyle.fill; //.stroke //.fill
    lapiz.strokeWidth = 20;

    final path = Path();

    //dibujar con el path y el lapiz (moveTo lineTo)

    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.25, size.height + 20, size.width * 0.5 , size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.75 , size.height * 0.70, size.width, size.height * 0.90);
    path.lineTo(size.width , 0);
    //path.lineTo(size.width , size.height * 0.25);


    canvas.drawPath(path, lapiz);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}