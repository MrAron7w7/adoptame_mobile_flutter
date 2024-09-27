import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/viewmodel/providers/theme_provider.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../../../core/utils/utils.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});
  static const name = 'ProfileView_view';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
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
                // Peril del usuario
                Container(
                  width: size.width * .5,
                  height: size.width * .5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: const DecorationImage(
                      image: AssetImage(AppAssets.perfil),
                    ),
                  ),
                ),

                gapH(10),

                const CustomLabel(
                  text: 'AronDev',
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
                  onTap: () {},
                ),

                CustomListTile(
                  text: 'Notificaciones',
                  icon: Icons.notifications,
                  trailing: const Icon(IconlyLight.arrow_right_2, size: 16),
                  onTap: () {},
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
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
