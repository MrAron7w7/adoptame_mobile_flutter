import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/view/views.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/utils/utils.dart';

class RegisterWebView extends StatelessWidget {
  const RegisterWebView({super.key});

  static const name = 'register_web_view';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          Size size = MediaQuery.of(context).size;
          double currentDiagonal =
              sqrt(pow(size.width, 2) + pow(size.height, 2));
          // Modo web
          return Scaffold(
            body: Center(
              child: Container(
                color: Theme.of(context).colorScheme.inversePrimary,
                child: Row(
                  children: [
                    // Imagen
                    Expanded(
                      child: Image.asset(AppAssets.logo),
                    ),

                    // Campos de imputs
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: const Border(
                            top: BorderSide(width: .5),
                            bottom: BorderSide(width: .5),
                            right: BorderSide(width: .5),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Titulo del login
                            const CustomLabel(
                              textAlign: TextAlign.center,
                              fontSize: 40,
                              text: 'Registrate',
                              fontWeight: FontWeight.bold,
                            ),

                            gapH(currentDiagonal * .03),

                            // Los texto de los inputs

                            CustomTextFieldForm(
                              fontSize: currentDiagonal * .012,
                              prefixIcon: IconlyBold.profile,
                              hintText: 'Pepito@example.com',
                              label: 'Nombre',
                            ),

                            gapH(currentDiagonal * .02),

                            CustomTextFieldForm(
                              prefixIcon: IconlyBold.message,
                              hintText: 'Example@example.com',
                              label: 'Email',
                              fontSize: currentDiagonal * .012,
                            ),

                            gapH(currentDiagonal * .02),

                            CustomTextFieldForm(
                              fontSize: currentDiagonal * .012,
                              prefixIcon: IconlyBold.lock,
                              suffixIcon: const Icon(IconlyBold.show),
                              hintText: '********',
                              label: 'Contraseña',
                            ),

                            gapH(currentDiagonal * .02),

                            CustomTextFieldForm(
                              fontSize: currentDiagonal * .012,
                              prefixIcon: IconlyBold.lock,
                              suffixIcon: const Icon(IconlyBold.show),
                              hintText: '********',
                              label: 'Confirmar contraseña',
                            ),

                            gapH(30),

                            // Botton de login
                            CustomButton(
                              fontSize: currentDiagonal * .013,
                              text: 'Registrate',
                              onPressed: () {},
                              sizeHeight: currentDiagonal * .05,
                            ),

                            gapH(30),
                            // Botton de regisrarse

                            FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomLabel(
                                    text: '¿Ya tienes una cuenta?',
                                    fontSize: currentDiagonal * .012,
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        context.push('/${LoginView.name}'),
                                    child: CustomLabel(
                                      text: 'Iniciar Sesion',
                                      fontWeight: FontWeight.bold,
                                      fontSize: currentDiagonal * .012,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // Modo mobile
          return const RegisterView();
        }
      },
    );
  }
}
