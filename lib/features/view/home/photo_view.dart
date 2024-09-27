import 'dart:io';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/viewmodel/providers/camera_gallery_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '/shared/components/components.dart';
import '../../../core/utils/utils.dart';

class PhotoView extends ConsumerStatefulWidget {
  const PhotoView({super.key});

  static const name = 'photo_view';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhotoViewState();
}

class _PhotoViewState extends ConsumerState<PhotoView> {
  final _descriptionController = TextEditingController();
  int _selectedRadio = 1;

  @override
  Widget build(BuildContext context) {
    // Tamaño para tomar de la pantlla
    Size size = MediaQuery.of(context).size;

    final photoPath = ref.watch(cameraGalleryProvider);

    // Eliminar datos de la descripcion, imagen y genero
    void clearData() {
      setState(() {
        // Restablecer la imagen a la imagen por defecto
        ref.read(cameraGalleryProvider.notifier).reset();

        // Limpiar el texto de descripción
        _descriptionController.clear();

        // Restablecer el género a 'Macho'
        _selectedRadio = 1;
      });
    }

    // Obtenemos la imagen con la camara o la galeria
    ClipRRect buildGetImage(Size size, BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CustomCustomPainter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: size.width * .6,
              height: 200,
              child: photoPath != null
                  ? Image(
                      fit: BoxFit.cover,
                      image: FileImage(File(photoPath)),
                    )
                  : Image.asset(AppAssets.noPhoto),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const CustomLabel(
            text: 'Añadir una foto',
            fontWeight: FontWeight.w600,
          ),
        ),
        body: CustomPadding(
          padding: 20,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Foto para escoger de la galeria foto del animalito
                  buildGetImage(size, context),

                  gapH(size.height * .05),
                  // Formularios para el ingreso de datos

                  // Descripcion del animalito
                  CustomTextFieldForm(
                    //textInputAction: TextInputAction.unspecified,
                    prefixIcon: IconlyBold.document,
                    hintText: '',
                    label: 'Descripción',
                    maxLines: 3,
                    controller: _descriptionController,
                  ),

                  gapH(size.height * .05),

                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomLabel(
                      text: 'Género',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  gapH(size.height * .02),

                  RadioListTile(
                    title: const CustomLabel(text: 'Macho'),
                    value: 1,
                    groupValue: _selectedRadio,
                    onChanged: (int? value) {
                      setState(() => _selectedRadio = value!);
                    },
                  ),

                  RadioListTile(
                    title: const CustomLabel(text: 'Hembra'),
                    value: 2,
                    groupValue: _selectedRadio,
                    onChanged: (int? value) {
                      setState(() => _selectedRadio = value!);
                    },
                  ),

                  gapH(size.height * .03),

                  CustomButton(
                    text: 'Publicar',
                    onPressed: () {},
                    fontWeight: FontWeight.w600,
                  ),

                  gapH(size.height * .03),

                  // Cancelar todo, borrar la imagen y los textos y los radio buttons
                  CustomButton(
                    text: 'Cancelar',
                    onPressed: clearData,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
          onLongPress: () =>
              ref.read(cameraGalleryProvider.notifier).takePhoto(context),
          onTap: () => ref.read(cameraGalleryProvider.notifier).selectPhoto(),
          child: Container(
            padding: EdgeInsets.all(size.width * .045),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(IconlyBold.camera),
          ),
        ),
      ),
    );
  }
}
