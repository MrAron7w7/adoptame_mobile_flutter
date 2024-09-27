import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/view/views.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/utils/utils.dart';

class LoginWebView extends StatelessWidget {
  const LoginWebView({super.key});

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
            body: Container(
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
                            text: 'Iniciar Sesion',
                            fontWeight: FontWeight.bold,
                          ),

                          gapH(30),

                          // Los texto de los inputs
                          CustomTextFieldForm(
                            fontSize: currentDiagonal * .012,
                            prefixIcon: IconlyBold.message,
                            hintText: 'Example@example.com',
                            label: 'Email',
                          ),

                          gapH(20),

                          CustomTextFieldForm(
                            fontSize: currentDiagonal * .012,
                            prefixIcon: IconlyBold.lock,
                            suffixIcon: const Icon(IconlyBold.show),
                            hintText: 'Password',
                            label: 'Contraseña',
                          ),

                          gapH(30),

                          // Botton de login
                          CustomButton(
                            fontSize: currentDiagonal * .013,
                            sizeHeight: currentDiagonal * .05,
                            text: 'Iniciar Sesion',
                            onPressed: () =>
                                context.go('/${NavigatorWebView.name}'),
                          ),

                          gapH(30),
                          // Botton de regisrarse

                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomLabel(
                                  text: '¿No tienes cuenta? ',
                                  fontSize: currentDiagonal * .012,
                                ),
                                TextButton(
                                  onPressed: () =>
                                      context.push('/${RegisterWebView.name}'),
                                  child: CustomLabel(
                                    text: 'Registrate',
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
          );
        } else {
          // Modo mobile
          return const LoginView();
        }
      },
    );
  }
}
