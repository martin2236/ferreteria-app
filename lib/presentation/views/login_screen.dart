import 'package:control_app/config/config.dart';
import 'package:control_app/presentation/bloc/cubit/data_cubit.dart';
import 'package:control_app/presentation/widgets/header.dart';
import 'package:control_app/presentation/widgets/imputs/custom_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = Theme.of(context).textTheme;
    final dataCubit = context.watch<DataCubit>();
    final categorias = dataCubit.state.categorias;
    final medidas = dataCubit.state.medidas;
    if(categorias == null){
       dataCubit.traerCategorias();
    }
    if(medidas == null){
       dataCubit.traerMedidas();
    }
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
              child: Text('Cuanto Rinde?',
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
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.15),
                child: SizedBox(
                height: size.height * 0.50,
                width:size.width,
                child:  Column(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                        Text('Iniciar Sesión',
                       style: GoogleFonts.lobster(
                       textStyle: text.headlineLarge,
                     ),
                       ),
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20),
                         child: CustomTextFormField(
                           hint: 'Usuario',
                           icon:const Icon(Icons.person),
                         )
                         ),
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20),
                         child: CustomTextFormField(
                           hint: 'Contraseña',
                           icon:const Icon(Icons.password_outlined),
                         ),
                       ),
                       SizedBox(
                         width: size.width,
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 20),
                           child: FilledButton(
                             onPressed: (){
                               router.go('/home/1');
                             }, 
                            style: ButtonStyle(
                                 backgroundColor: WidgetStateProperty.all(Colors.purple)
                               ),
                             child: Text('Ingresar',
                              style: GoogleFonts.lobster(
                               textStyle: text.titleLarge!.copyWith(color: Colors.white),
                             ),
                             ),
                             ),
                         ),
                       )
                    ],
                  ),
                            ),
              )
            ]
        ),
    );
  }
}

