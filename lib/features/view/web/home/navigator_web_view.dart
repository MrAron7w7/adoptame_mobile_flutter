import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/view/views.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/utils/utils.dart';

class NavigatorWebView extends StatefulWidget {
  const NavigatorWebView({super.key});

  static const name = 'navigator_web_view';

  @override
  State<NavigatorWebView> createState() => _NavigatorWebViewState();
}

class _NavigatorWebViewState extends State<NavigatorWebView> {
  int _selectedIndex = 0;
  String profileImageUrl = 'https://firebasestorage.googleapis.com/v0/b/adoptame-db.appspot.com/o/Default%2FdefaultProfile.jpg?alt=media&token=404d673e-627f-4c6d-bc5f-be02f4005985';
  String userName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            profileImageUrl = userDoc['profileImageUrl'] ??
                'https://firebasestorage.googleapis.com/v0/b/adoptame-db.appspot.com/o/Default%2FdefaultProfile.jpg?alt=media&token=404d673e-627f-4c6d-bc5f-be02f4005985';
            userName = userDoc['name'] ?? 'Usuario';
            isLoading = false;
          });
        }
      } catch (e) {
        print("Error loading user profile: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double currentDiagonal = sqrt(pow(size.width, 2) + pow(size.height, 2));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          Widget? page;
          switch (_selectedIndex) {
            case 0:
              page = const HomeWebView();
              break;
            case 1:
              page = const PhotoWebView();
              break;
            case 2:
              page = const ProfileWebView();
            default:
              throw UnimplementedError('no widget for $_selectedIndex');
          }
          // Modo web
          return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: currentDiagonal * .02,
                    left: 30,
                    right: 30,
                  ),
                  child: Row(
                    children: [
                      // Foto del logo
                      Row(
                        children: [
                          const CustomCircularAvatar(
                            image: AppAssets.logo,
                            size: 70,
                          ),
                          gapW(currentDiagonal * .005),
                          CustomLabel(
                            text: 'Adoptame',
                            fontSize: currentDiagonal * .015,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Navegacion
                      Row(
                        children: [
                          _buildBottomNavigator(
                            currentDiagonal,
                            text: 'I N I C I O',
                            color: _selectedIndex == 0
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            onTap: () => setState(() => _selectedIndex = 0),
                          ),
                          gapW(currentDiagonal * .05),
                          _buildBottomNavigator(
                            currentDiagonal,
                            color: _selectedIndex == 1
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            text: 'S O S',
                            onTap: () => setState(() => _selectedIndex = 1),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Perfil
                      PopupMenuButton(
                        tooltip: 'Perfil',
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: const CustomListTile(
                                icon: IconlyBold.setting,
                                text: 'Configuración',
                              ),
                              onTap: () {
                                setState(() => _selectedIndex = 2);
                              },
                            ),
                            PopupMenuItem(
                              child: const CustomListTile(
                                icon: IconlyBold.logout,
                                text: 'Salir',
                              ),
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                context.go('/${LoginView.name}');
                              },
                            ),
                          ];
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 0.5,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: currentDiagonal * .012,
                                backgroundImage: NetworkImage(profileImageUrl),
                              ),
                              gapW(currentDiagonal * .01),
                              CustomLabel(
                                text: userName,
                                fontSize: currentDiagonal * .012,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: page,
                ),
              ],
            ),
          );
        } else {
          // Modo mobile
          return const BottomNavbar();
        }
      },
    );
  }

  InkWell _buildBottomNavigator(
      double currentDiagonal, {
        required String text,
        required void Function()? onTap,
        Color? color,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(8.0),
        child: CustomLabel(
          text: text,
          fontSize: currentDiagonal * .013,
          fontWeight: FontWeight.w600,
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}