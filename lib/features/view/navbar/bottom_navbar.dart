import 'package:adoptme/features/view/views.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:adoptme/shared/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  static const name = 'navbar_view';

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  final List<Widget> _pages = [
    const HomeView(),
    const PhotoView(),
    const ProfileView(),
  ];

  void _selectedItemMenu(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: _bottomAppBar(),
    );
  }

  Widget _bottomItemMenu({
    required int selectedIndex,
    required int page,
    required String label,
    required IconData defaultIcon,
    required IconData filledIcon,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColor.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono
            Icon(
              selectedIndex == page ? filledIcon : defaultIcon,
              color: selectedIndex == page
                  ? Theme.of(context).colorScheme.primary
                  : AppColor.secondary,
              size: 26,
            ),

            const SizedBox(height: 3),

            // Label
            CustomLabel(
              text: label,
              color: selectedIndex == page
                  ? Theme.of(context).colorScheme.primary
                  : AppColor.secondary,
              fontSize: 13,
              fontWeight:
                  selectedIndex == page ? FontWeight.w600 : FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  // Bottom nav bar
  BottomAppBar _bottomAppBar() {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          _bottomItemMenu(
            onTap: () => _selectedItemMenu(0),
            page: 0,
            label: 'Inicio',
            defaultIcon: IconlyLight.home,
            filledIcon: IconlyBold.home,
            selectedIndex: _selectedIndex,
          ),
          _bottomItemMenu(
            onTap: () => _selectedItemMenu(1),
            page: 1,
            label: 'Sos',
            defaultIcon: IconlyLight.camera,
            filledIcon: IconlyBold.camera,
            selectedIndex: _selectedIndex,
          ),
          _bottomItemMenu(
            onTap: () => _selectedItemMenu(2),
            page: 2,
            label: 'Perfil',
            defaultIcon: IconlyLight.profile,
            filledIcon: IconlyBold.profile,
            selectedIndex: _selectedIndex,
          ),
        ],
      ),
    );
  }
}
