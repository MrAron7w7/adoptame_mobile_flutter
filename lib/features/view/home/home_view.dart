import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/core/enum/enums.dart';
import 'package:adoptme/features/viewmodel/providers/seleted_dropdown_provider.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconly/iconly.dart';

import '../../../core/utils/utils.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  static const name = 'home_view';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final filterAnimal = ref.watch(seletedDropdownProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(IconlyBold.category),
        title: const CustomLabel(
          text: 'Adoptame',
          fontWeight: FontWeight.w600,
          fontSize: 26,
        ),
        actions: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(AppAssets.perfil),
          ),
          gapW(10),
        ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            gapH(size.height * .03),

            _buildDropDownButton(context, filterAnimal: filterAnimal),

            gapH(size.height * .03),

            // Vista de todos los animales segun lo escogido
            Expanded(child: _listAnimalView()),
          ],
        ),
      ),
    );
  }

  // DropdownButton para seleccion de tipo
  Widget _buildDropDownButton(
    BuildContext context, {
    required FilterAnimal filterAnimal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomLabel(
            text: 'Filtrar por:',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          DropdownButton<FilterAnimal>(
            value: filterAnimal,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            dropdownColor: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            underline: Container(),
            onChanged: (FilterAnimal? newValue) {
              ref
                  .read(seletedDropdownProvider.notifier)
                  .selecterFilter(newValue!);
            },
            items: const <DropdownMenuItem<FilterAnimal>>[
              DropdownMenuItem<FilterAnimal>(
                value: FilterAnimal.all,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(AppAssets.all),
                      radius: 15,
                    ),
                    SizedBox(width: 10),
                    CustomLabel(text: 'Todos'),
                  ],
                ),
              ),
              DropdownMenuItem<FilterAnimal>(
                value: FilterAnimal.dog,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(AppAssets.dog),
                      radius: 15,
                    ),
                    SizedBox(width: 10),
                    CustomLabel(text: 'Perros'),
                  ],
                ),
              ),
              DropdownMenuItem<FilterAnimal>(
                value: FilterAnimal.cat,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(AppAssets.cat),
                      radius: 15,
                    ),
                    SizedBox(width: 10),
                    CustomLabel(text: 'Gatos'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Cuerpo de la lista
  Widget _listAnimalView() {
    return GridView.builder(
      itemCount: 10,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final currentIndex = index * Random().nextInt(10);
        return _buildCard(currentIndex);
      },
    );
  }

  // Card de cada item
  Widget _buildCard(int index) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          // Imagen
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image:
                      NetworkImage('https://picsum.photos/id/$index/200/300'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          //  Descripcion
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomLabel(
                    text: 'Macho',
                    fontWeight: FontWeight.w500,
                  ),
                  CircleAvatar(
                    radius: 10,
                    child: Icon(FontAwesomeIcons.mars, size: 12),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  SegmentedButton<int> _buildSegmentButton(BuildContext context) {
    return SegmentedButton(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedForegroundColor:
              _selectedValue == _selectedValue ? Colors.white : Colors.black,
          selectedBackgroundColor: Theme.of(context).colorScheme.primary,
        ),
        selected: <int>{_selectedValue},
        segments: const [
          ButtonSegment<int>(
            value: 1,
            label: CustomLabel(text: 'Todos'),
            icon: Icon(FontAwesomeIcons.plus),
          ),
          ButtonSegment<int>(
            value: 2,
            label: CustomLabel(text: 'Perritos'),
            icon: Icon(FontAwesomeIcons.dog),
          ),
          ButtonSegment<int>(
            value: 3,
            label: CustomLabel(text: 'Gatitos'),
            icon: Icon(FontAwesomeIcons.cat),
          ),
        ],
        onSelectionChanged: (Set<int> selected) {
          setState(() => _selectedValue = selected.first);
        });
  }
}
