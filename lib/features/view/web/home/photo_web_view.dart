import 'dart:io';
import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/core/enum/enums.dart';
import 'package:adoptme/features/view/views.dart';
import 'package:adoptme/features/viewmodel/providers/camera_gallery_provider.dart';
import 'package:adoptme/features/viewmodel/providers/enums_provider.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/utils/toast.dart';
import '../../../../core/utils/utils.dart';
import '../../../../firebase/post_animal/firebase_post_services.dart';
import '../../../../shared/theme/app_color.dart';
import '../../../models/post_animals.dart';

class PhotoWebView extends ConsumerStatefulWidget {
  const PhotoWebView({super.key});

  @override
  ConsumerState<PhotoWebView> createState() => _PhotoWebViewState();
}

class _PhotoWebViewState extends ConsumerState<PhotoWebView> {
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FirebasePostServices _firebasePostServices = FirebasePostServices();

  void _clearData() {
    setState(() {
      // Reset image
      ref.read(cameraGalleryProvider.notifier).reset();

      // Clear description
      _descriptionController.clear();

      // Reset animal type and gender
      ref.read(animalGnderProviderProvider.notifier).setGender(
        animalGender: AnimalGender.macho,
      );
    });
  }

  Future<void> _submitPost() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check user authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showToast(message: "Debes iniciar sesión");
      return;
    }

    // Check if photo is selected
    final photoPath = ref.watch(cameraGalleryProvider);
    if (photoPath == null) {
      showToast(message: "Debes seleccionar una imagen");
      return;
    }

    // Get selected gender and animal type
    final selectedGender = ref.read(animalGnderProviderProvider);

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload image to Firebase
      File imageFile = File(photoPath);
      String imageUrl = await _firebasePostServices.uploadImage(imageFile);

      // Create post
      final post = PostAnimals(
        description: _descriptionController.text,
        imagen: imageUrl,
        gender: selectedGender == AnimalGender.macho ? 'Macho' : 'Hembra',
        animalType: selectedGender == AnimalGender.macho ? 'Perro' : 'Gato',
        userId: user.uid,
      );

      // Save post to Firebase
      await _firebasePostServices.createPost(post);

      // Clear data and show success message
      _clearData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Publicado correctamente'),
          backgroundColor: AppColor.primary,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoPath = ref.watch(cameraGalleryProvider);
    final selectedGender = ref.watch(animalGnderProviderProvider);
    Size size = MediaQuery.of(context).size;

    double currentDiagonal = sqrt(pow(size.width, 2) + pow(size.height, 2));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: Stack(
              children: [
                CustomPadding(
                  padding: 30,
                  child: Row(
                    children: [
                      // Image selection
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

                      // Form section
                      Expanded(
                        child: SizedBox(
                          width: size.width,
                          height: size.height,
                          child: CustomPadding(
                            padding: 30,
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Description
                                    CustomLabel(
                                      text: 'Descripción del animal',
                                      fontSize: currentDiagonal * .013,
                                    ),
                                    CustomTextFieldForm(
                                      controller: _descriptionController,
                                      prefixIcon: IconlyBold.message,
                                      hintText: '',
                                      label: 'Descripción',
                                      maxLines: 2,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'La descripción es obligatoria';
                                        }
                                        return null;
                                      },
                                    ),

                                    gapH(currentDiagonal * .01),

                                    // Animal Type
                                    CustomLabel(
                                      text: 'Tipo de animal',
                                      fontSize: currentDiagonal * .013,
                                    ),

                                    gapH(currentDiagonal * .01),

                                    // Animal Type Radio Buttons
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

                                    // Gender
                                    CustomLabel(
                                      text: 'Género del animal',
                                      fontSize: currentDiagonal * .013,
                                    ),

                                    gapH(currentDiagonal * .01),

                                    // Gender Radio Buttons
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

                                    // Buttons
                                    SizedBox(
                                      width: size.width,
                                      child: Wrap(
                                        alignment: WrapAlignment.spaceEvenly,
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
                                            onPressed: _submitPost,
                                            text: 'Publicar',
                                          ),
                                          _buildButton(
                                            context,
                                            currentDiagonal,
                                            onPressed: _clearData,
                                            text: 'Cancelar',
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
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
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
          );
        } else {
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