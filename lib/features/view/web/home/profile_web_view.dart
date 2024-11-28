import 'dart:io';
import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/viewmodel/providers/camera_gallery_provider.dart';
import 'package:adoptme/features/viewmodel/providers/profile_image_provider.dart';
import 'package:adoptme/features/viewmodel/providers/theme_provider.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:adoptme/shared/theme/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/utils.dart';
import '../../../../shared/components/Custom_textform_field2.dart';
import '../login/login_web_view.dart';

class ProfileWebView extends ConsumerStatefulWidget {
  const ProfileWebView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWebViewState();
}

class _ProfileWebViewState extends ConsumerState<ProfileWebView> {
  String _username = '';
  String _email = '';
  String _profileImageUrl = '';
  bool _isLoading = true;
  bool _isLoadingImage = true;

  @override
  void initState() {
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
            _email = user.email ?? '';
            _profileImageUrl = userDoc['profileImageUrl'] ??
                'https://firebasestorage.googleapis.com/v0/b/adoptame-db.appspot.com/o/Default%2FdefaultProfile.jpg?alt=media&token=404d673e-627f-4c6d-bc5f-be02f4005985';
            _isLoading = false;
            _isLoadingImage = false;
          });
        }
      } catch (e) {
        print("Error loading user profile: $e");
        setState(() {
          _isLoading = false;
          _isLoadingImage = false;
        });
      }
    }
  }

  Future<void> _changeProfileImage() async {
    setState(() {
      _isLoadingImage = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Call profile image provider
    await ref.read(profileImageProviderProvider.notifier).selectProfilePhoto();
    final imagePath = ref.read(profileImageProviderProvider);

    if (imagePath != null) {
      // Upload image
      final storageRef = FirebaseStorage.instance.ref().child(
          'users/${user.uid}/profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      try {
        await storageRef.putFile(File(imagePath));
        final downloadUrl = await storageRef.getDownloadURL();

        // Update Firestore
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
        print("Error uploading image: $e");
        setState(() {
          _isLoadingImage = false;
        });
      }
    }
  }

  void _showEditProfileDialog() {
    TextEditingController _newNameController = TextEditingController(text: _username);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomLabel(
              text: 'Editar Perfil',
              fontSize: 24,
            ),
            CustomTextFieldForm(
              controller: _newNameController,
              prefixIcon: IconlyBold.profile,
              hintText: 'Nuevo nombre',
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
    final isDarkMode = ref.watch(themeProviderProvider);
    Size size = MediaQuery.of(context).size;
    double currentDiagonal = sqrt(pow(size.width, 2) + pow(size.height, 2));

    return Scaffold(
      body: Row(
        children: [
          // Profile Photo Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Image
                  _isLoadingImage
                      ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CircleAvatar(
                      radius: currentDiagonal * .07,
                      backgroundColor: Colors.grey,
                    ),
                  )
                      : GestureDetector(
                    onTap: _changeProfileImage,
                    child: CircleAvatar(
                      radius: currentDiagonal * .07,
                      backgroundColor: AppColor.transparent,
                      backgroundImage: NetworkImage(_profileImageUrl),
                    ),
                  ),

                  gapH(currentDiagonal * .02),

                  // Username
                  _isLoading
                      ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 150,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                  )
                      : CustomLabel(
                    text: _username,
                    fontSize: currentDiagonal * .013,
                  ),

                  // Email
                  _isLoading
                      ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 200,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                  )
                      : CustomLabel(
                    text: _email,
                    fontSize: currentDiagonal * .014,
                    fontWeight: FontWeight.w500,
                  ),

                  gapH(currentDiagonal * .02),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: currentDiagonal * .032),
                    child: CustomButton(
                      onPressed: _changeProfileImage,
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

          // Edit Profile Section
          Expanded(
            child: CustomPadding(
              padding: currentDiagonal * .02,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Save Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLabel(
                          text: 'Editar perfil',
                          fontSize: currentDiagonal * .02,
                        ),
                        MaterialButton(
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: _showEditProfileDialog,
                          child: CustomLabel(
                            text: 'Editar',
                            fontSize: currentDiagonal * .013,
                          ),
                        ),
                      ],
                    ),

                    gapH(currentDiagonal * .03),
                    // Name Input
                    CustomLabel(
                      text: 'Nombre',
                      fontSize: currentDiagonal * .014,
                      fontWeight: FontWeight.w600,
                    ),



                    gapH(currentDiagonal * .03),

                    // Theme Toggle
                    CustomListTile(
                      icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      text: isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
                      onTap: () => ref
                          .read(themeProviderProvider.notifier)
                          .toggleTheme(),
                    ),

                    // Logout
                    CustomListTile(
                      icon: IconlyBold.logout,
                      text: 'Cerrar Sesión',
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        context.go('/${LoginWebView.name}');
                      },
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