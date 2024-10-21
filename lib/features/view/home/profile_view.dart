import 'dart:io';

import 'package:adoptme/features/viewmodel/providers/theme_provider.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/utils.dart';
import '../../viewmodel/providers/profile_image_provider.dart';
import '../login/login_view.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  static const name = 'ProfileView_view';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  String _username = '';
  String _profileImageUrl = '';
  bool _changeNotification = true;
  bool _isLoading = true;
  bool _isLoadingImage = true;


  @override
  void initState() {
    _isLoading = true;
    _isLoadingImage = true;
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _username = userDoc['username'] ?? 'Unknown User';
            _profileImageUrl = userDoc['profileImageUrl'] ??
                'https://firebasestorage.googleapis.com/v0/b/adoptame-db.appspot.com/o/Default%2FdefaultProfile.jpg?alt=media&token=404d673e-627f-4c6d-bc5f-be02f4005985';
            _isLoading = false;
            _isLoadingImage = false; // Finaliza la carga de la imagen
          });
        } else {
          print("No encontrado");
        }
      } catch (e) {
        print("Error: $e");
      }
    } else {
      print("No hay usuario autenticado");
    }
  }

  Future<void> _changeProfileImage() async {
    setState(() {
      _isLoadingImage = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // llamamos a provider
    await ref.read(profileImageProviderProvider.notifier).selectProfilePhoto();
    final imagePath = ref.read(profileImageProviderProvider);

    if (imagePath != null) {
      // subi la imagen
      final storageRef = FirebaseStorage.instance.ref().child(
          'users/${user.uid}/profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      try {
        await storageRef.putFile(File(imagePath));
        final downloadUrl = await storageRef.getDownloadURL();

        // actualiza la url
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'profileImageUrl': downloadUrl,
        });

        setState(() {
          _profileImageUrl = downloadUrl;
          _isLoadingImage = false;
        });
      } catch (e) {
        print("Error al subir la imagen $e");

        setState(() {
          _isLoadingImage = false;
        });
      }

      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  void _showDialogChangeName() {
    TextEditingController _newNameController = TextEditingController(text: _username);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomLabel(
              text: 'Cambiar nombre',
              fontSize: 24,
            ),
            CustomTextFieldForm(
              controller: _newNameController,
              prefixIcon: IconlyBold.profile,
              hintText: 'Juan',
              label: '',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null && _newNameController.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({
                  'username': _newNameController.text,
                });

                setState(() {
                  _username = _newNameController.text;
                });

                Navigator.of(context).pop();
              }
            },
            child: const CustomLabel(text: 'Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(themeProviderProvider);
    String darkModeText = darkMode ? 'Modo Claro' : 'Modo Oscuro';
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomLabel(
          text: 'Perfil',
          fontWeight: FontWeight.w600,
        ),
      ),
      body: CustomPadding(
        padding: 20,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _isLoadingImage
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: size.width * .5,
                          height: size.width * .5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.grey, // Color de fondo del shimmer
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: _changeProfileImage,
                        child: Container(
                          width: size.width * .5,
                          height: size.width * .5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: NetworkImage(_profileImageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                gapH(10),

                _isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 150,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    : CustomLabel(
                        text: _username,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),

                gapH(50),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomLabel(
                    text: 'Cuenta',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),

                CustomListTile(
                  icon: IconlyBold.profile,
                  trailing: const Icon(IconlyLight.arrow_right_2, size: 16),
                  text: 'Configuracion',
                  onTap: _showDialogChangeName,
                ),

                CustomListTile(
                  text: 'Notificaciones',
                  icon: _changeNotification
                      ? Icons.notifications
                      : Icons.notifications_off,
                  trailing: const Icon(IconlyLight.arrow_right_2, size: 16),
                  onTap: () {
                    setState(() {
                      _changeNotification = !_changeNotification;
                    });
                  },
                ),

                CustomListTile(
                  text: darkModeText,
                  trailing: const Icon(IconlyLight.arrow_right_2, size: 16),
                  icon: darkMode ? Icons.light_mode : Icons.dark_mode,
                  onTap: () =>
                      ref.read(themeProviderProvider.notifier).toggleTheme(),
                ),

                gapH(10),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomLabel(
                    text: 'Más',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),

                // bottom de cerrar session
                CustomListTile(
                  text: 'Cerrar Sesion',
                  icon: IconlyBold.logout,
                  trailing: const Icon(IconlyLight.arrow_right_2, size: 16),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    context.go('/${LoginView.name}');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
