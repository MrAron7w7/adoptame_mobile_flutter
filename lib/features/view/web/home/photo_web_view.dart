import 'dart:io';
import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/core/enum/enums.dart';
import 'package:adoptme/features/view/views.dart';
import 'package:adoptme/features/viewmodel/providers/camera_gallery_provider.dart';
import 'package:adoptme/features/viewmodel/providers/enums_provider.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/utils/utils.dart';

class PhotoWebView extends ConsumerWidget {
  const PhotoWebView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoPath = ref.watch(cameraGalleryProvider);
    final selectedGender = ref.watch(animalGnderProviderProvider);
    Size size = MediaQuery.of(context).size;

    double currentDiagonal = sqrt(pow(size.width, 2) + pow(size.height, 2));
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: CustomPadding(
              padding: 30,
              child: Row(
                children: [
                  // Imagen para subir
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomCustomPainter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width * .6,
                            height: size.width * .6,
                            child: photoPath != null
                                ? Image(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(photoPath)),
                                  )
                                : Image.asset(AppAssets.noPhoto),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Boton para subir la imagen
                  Expanded(
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: CustomPadding(
                        padding: 30,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Descripcion del animalito
                              CustomLabel(
                                text: 'Descripción del animal',
                                fontSize: currentDiagonal * .013,
                              ),
                              const CustomTextFieldForm(
                                prefixIcon: IconlyBold.message,
                                hintText: '',
                                label: '',
                                maxLines: 2,
                              ),

                              gapH(currentDiagonal * .01),

                              // Tipo de animal
                              CustomLabel(
                                text: 'Tipo de animal',
                                fontSize: currentDiagonal * .013,
                              ),

                              gapH(currentDiagonal * .01),

                              // Radios buttons
                              Column(
                                children: [
                                  RadioListTile<AnimalGender>(
                                    title: CustomLabel(
                                      text: 'Perro',
                                      fontSize: currentDiagonal * .012,
                                    ),
                                    value: AnimalGender.macho,
                                    groupValue: selectedGender,
                                    onChanged: (AnimalGender? value) {
                                      ref
                                          .read(animalGnderProviderProvider
                                              .notifier)
                                          .setGender(animalGender: value!);
                                    },
                                  ),
                                  RadioListTile<AnimalGender>(
                                    title: CustomLabel(
                                      text: 'Gato',
                                      fontSize: currentDiagonal * .012,
                                    ),
                                    value: AnimalGender.hembra,
                                    groupValue: selectedGender,
                                    onChanged: (AnimalGender? value) {
                                      ref
                                          .read(animalGnderProviderProvider
                                              .notifier)
                                          .setGender(animalGender: value!);
                                    },
                                  ),
                                ],
                              ),

                              // Genero
                              CustomLabel(
                                text: 'Genero del animal',
                                fontSize: currentDiagonal * .013,
                              ),

                              gapH(currentDiagonal * .01),

                              // Radios buttons
                              Column(
                                children: [
                                  RadioListTile<AnimalGender>(
                                    title: CustomLabel(
                                      text: 'Macho',
                                      fontSize: currentDiagonal * .012,
                                    ),
                                    value: AnimalGender.macho,
                                    groupValue: selectedGender,
                                    onChanged: (AnimalGender? value) {
                                      ref
                                          .read(animalGnderProviderProvider
                                              .notifier)
                                          .setGender(animalGender: value!);
                                    },
                                  ),
                                  RadioListTile<AnimalGender>(
                                    title: CustomLabel(
                                      text: 'Hembra',
                                      fontSize: currentDiagonal * .012,
                                    ),
                                    value: AnimalGender.hembra,
                                    groupValue: selectedGender,
                                    onChanged: (AnimalGender? value) {
                                      ref
                                          .read(animalGnderProviderProvider
                                              .notifier)
                                          .setGender(animalGender: value!);
                                    },
                                  ),
                                ],
                              ),

                              gapH(currentDiagonal * .01),

                              // Botones de subir imagen
                              SizedBox(
                                width: size.width,
                                child: Wrap(
                                  alignment: WrapAlignment.spaceEvenly,
                                  //runAlignment: WrapAlignment.spaceEvenly,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runSpacing: 15,
                                  children: [
                                    _buildButton(
                                      context,
                                      currentDiagonal,
                                      onPressed: () => ref
                                          .read(cameraGalleryProvider.notifier)
                                          .selectPhoto(),
                                      text: 'Subir imagen',
                                    ),
                                    _buildButton(
                                      context,
                                      currentDiagonal,
                                      onPressed: () {},
                                      text: 'Publicar',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          print('Pasa por aqui?');
          return const PhotoView();
        }
      },
    );
  }

  ElevatedButton _buildButton(
    BuildContext context,
    double currentDiagonal, {
    required void Function()? onPressed,
    required String text,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: EdgeInsets.all(currentDiagonal * .013),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onPressed: onPressed,
      icon: const Icon(IconlyBold.upload),
      label: CustomLabel(
        text: text,
        fontSize: currentDiagonal * .013,
      ),
    );
  }
}
