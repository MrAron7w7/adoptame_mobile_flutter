import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/viewmodel/providers/camera_gallery_provider.dart';
import 'package:adoptme/features/viewmodel/providers/theme_provider.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:adoptme/shared/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/utils/utils.dart';

class ProfileWebView extends ConsumerStatefulWidget {
  const ProfileWebView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileWebView> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProviderProvider);
    final photo = ref.watch(cameraGalleryProvider);
    Size size = MediaQuery.of(context).size;
    double currentDiagonal = sqrt(pow(size.width, 2) + pow(size.height, 2));
    return Scaffold(
      body: Row(
        children: [
          // Mostrar foto perfil
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Imagen de perfil
                  CircleAvatar(
                    radius: currentDiagonal * .07,
                    backgroundColor: AppColor.transparent,
                    backgroundImage: const AssetImage(AppAssets.perfil),
                  ),

                  gapH(currentDiagonal * .02),

                  // Nombre de usuario
                  CustomLabel(
                    text: 'AronDev',
                    fontSize: currentDiagonal * .013,
                  ),

                  // Correo de usuario
                  CustomLabel(
                    text: 'aron@gmail.com',
                    fontSize: currentDiagonal * .014,
                    fontWeight: FontWeight.w500,
                  ),

                  gapH(currentDiagonal * .02),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: currentDiagonal * .032),
                    child: CustomButton(
                      onPressed: () {},
                      text: 'Subir nuevo avatar',
                      fontWeight: FontWeight.w700,
                      sizeHeight: currentDiagonal * .045,
                    ),
                  ),
                ],
              ),
            ),
          ),

          VerticalDivider(
            thickness: 1,
            color: Theme.of(context).colorScheme.secondary.withOpacity(.4),
          ),

          // Editar perfil y mostrar datos
          Expanded(
            child: CustomPadding(
              padding: currentDiagonal * .02,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titulo y guardado de datos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLabel(
                          text: 'Editar perfil',
                          fontSize: currentDiagonal * .02,
                        ),
                        MaterialButton(
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () {},
                          child: CustomLabel(
                            text: 'Guardar',
                            fontSize: currentDiagonal * .013,
                          ),
                        ),
                      ],
                    ),

                    gapH(currentDiagonal * .03),
                    // Inputs para la obtencion de datos
                    CustomLabel(
                      text: 'Nombre',
                      fontSize: currentDiagonal * .014,
                      fontWeight: FontWeight.w600,
                    ),

                    const CustomTextFieldForm(
                      prefixIcon: IconlyBold.profile,
                      hintText: 'Escribe tu nuevo nombre',
                      label: '',
                    ),

                    gapH(currentDiagonal * .03),

                    CustomListTile(
                      icon: Icons.dark_mode,
                      text: 'Cambiar de tema',
                      onTap: () => ref
                          .read(themeProviderProvider.notifier)
                          .toggleTheme(),
                    ),
                    CustomListTile(
                      icon: IconlyBold.notification,
                      text: 'Notificaciones',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
