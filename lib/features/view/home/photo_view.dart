import 'dart:io';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/viewmodel/providers/camera_gallery_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../../../core/utils/toast.dart';
import '../../../firebase/post_animal/firebase_post_services.dart';
import '../../../shared/theme/app_color.dart';
import '../../models/post_animals.dart';
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
  final _formKey = GlobalKey<FormState>();
  int _selectedGender = 1;
  int _selectedAnimalType = 1;
  bool _carga = false;
  final FirebasePostServices _firebasePostServices = FirebasePostServices();

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
        _selectedAnimalType = 1;

        _selectedGender = 1;
      });
    }

    Future<void> _submitPost() async {
      //si el fodmularo no cumploe no continuara
      if (!_formKey.currentState!.validate()) {
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Se tiene que iniciar sesion");
        return;
      }

      final photoPath = ref.watch(cameraGalleryProvider);
      if (photoPath == null) {
        showToast(message: "Debes seleccionar una imagen.");
        return;
      }
      setState(() {
        _carga = true;
      });

      try {
        File imageFile = File(photoPath);
        String imageUrl = await _firebasePostServices.uploadImage(imageFile);

        final post = PostAnimals(
          description: _descriptionController.text,
          imagen: imageUrl,
          gender: _selectedGender == 1 ? 'Macho' : 'Hembra',
          animalType: _selectedAnimalType == 1 ? 'Perro' : 'Gato',
          userId: user.uid,
        );

        await _firebasePostServices.createPost(post);
        clearData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text('Publicado correctamente'),
            backgroundColor: AppColor.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _carga = false;
        });
      }
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
            text: 'Agrega una foto',
            fontWeight: FontWeight.w600,
          ),
        ),
        body: Stack(
          children: [
            CustomPadding(
              padding: 20,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Foto para escoger de la galeria foto del animalito
                        buildGetImage(size, context),

                        gapH(size.height * .035),
                        // Formularios para el ingreso de datos

                        // Descripcion del animalito
                        CustomTextFieldForm(
                          //textInputAction: TextInputAction.unspecified,
                          prefixIcon: IconlyBold.document,
                          hintText: '',
                          label: 'Descripción',
                          maxLines: 2,
                          controller: _descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La descripción es obligatoria';
                            }
                            return null;
                          },
                        ),

                        gapH(size.height * .03),

                        // Tipo del animal
                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: CustomLabel(
                            text: 'Tipo del animalito',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        gapH(size.height * .01),

                        buildRadioListTile(
                          title: 'Perro',
                          value: 1,
                          onChanged: (int? value) {
                            setState(() => _selectedAnimalType = value!);
                          },
                          groupValue: _selectedAnimalType,
                        ),

                        buildRadioListTile(
                          title: 'Gato',
                          value: 2,
                          groupValue: _selectedAnimalType,
                          onChanged: (int? value) {
                            setState(() => _selectedAnimalType = value!);
                          },
                        ),

                        gapH(size.height * .01),

                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: CustomLabel(
                            text: 'Género',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        gapH(size.height * .01),

                        buildRadioListTile(
                          title: 'Macho',
                          value: 1,
                          groupValue: _selectedGender,
                          onChanged: (int? value) {
                            setState(() => _selectedGender = value!);
                          },
                        ),

                        buildRadioListTile(
                          title: 'Hembra',
                          value: 2,
                          groupValue: _selectedGender,
                          onChanged: (int? value) {
                            setState(() => _selectedGender = value!);
                          },
                        ),

                        gapH(size.height * .02),

                        CustomButton(
                          text: 'Publicar',
                          onPressed: _submitPost,
                          fontWeight: FontWeight.w600,
                        ),

                        gapH(size.height * .02),

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
            ),
            if (_carga)
              Container(
                width: size.width,
                height: size.height,
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
        floatingActionButton: Opacity(
          opacity: _carga ? 0.8 : 1.0,
          child: GestureDetector(
            onLongPress: _carga
                ? null
                : () =>
                    ref.read(cameraGalleryProvider.notifier).takePhoto(context),
            onTap: _carga
                ? null
                : () => ref.read(cameraGalleryProvider.notifier).selectPhoto(),
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
      ),
    );
  }

  // Método para construir RadioListTile
  Widget buildRadioListTile({
    required String title,
    required int value,
    required int groupValue,
    required Function(int?) onChanged,
  }) {
    return RadioListTile(
      title: CustomLabel(text: title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.symmetric(vertical: 0),
    );
  }
}
