import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/view/views.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/utils.dart';

class HomeWebView extends StatefulWidget {
  const HomeWebView({super.key});

  @override
  State<HomeWebView> createState() => _HomeWebViewState();
}

class _HomeWebViewState extends State<HomeWebView> {
  String? _dropdownValue = 'all';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //
    double currentDiagonal = sqrt(pow(size.width, 2) + pow(size.height, 2));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: CustomPadding(
              padding: 30,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Titulo de la pagina
                    _buildTitlePage(currentDiagonal, context),

                    gapH(currentDiagonal * .03),

                    // Filtro de los animales
                    _buildFilteredAnimal(currentDiagonal, context),

                    gapH(currentDiagonal * .03),

                    // Cuerpo de la vista de los animales
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size.width > 830 ? 4 : 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final currentIndex = index * Random().nextInt(10);
                        return _buildCard(
                          context,
                          currentDiagonal: currentDiagonal,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                content: SizedBox(
                                  width: size.width * .5,
                                  height: size.width * .3,
                                  child: Row(
                                    children: [
                                      //
                                      Expanded(
                                        child: Container(
                                          width: size.width,
                                          height: size.height,
                                          alignment: Alignment.topLeft,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: const DecorationImage(
                                              image:
                                                  AssetImage(AppAssets.perfil),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              top: 10,
                                              left: 10,
                                            ),
                                            child: IconButton(
                                              onPressed: () => context.pop(),
                                              icon:
                                                  const Icon(Icons.arrow_back),
                                              style: IconButton.styleFrom(
                                                elevation: 10,
                                                shape: const CircleBorder(),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      //
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Titulo
                                              const CustomLabel(
                                                text: 'Toby',
                                                fontSize: 26,
                                              ),

                                              gapH(size.height * .01),

                                              // Fecha de publicacon
                                              CustomLabel(
                                                text:
                                                    'Fecha de publicacion: Ayer',
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),

                                              gapH(size.height * .01),

                                              // Genero
                                              CustomLabel(
                                                text: 'Macho',
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),

                                              gapH(size.height * .01),

                                              // Descripcion
                                              CustomLabel(
                                                text:
                                                    'lorem ipsum dolor sit amet consectetur adipiscing elit suscipit',
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),

                                              // Botom
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const CustomLabel(
                                      text: 'ADOPTAR',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          image:
                              'https://picsum.photos/id/$currentIndex/200/300',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const HomeView();
        }
      },
    );
  }

  // Filtro de los animales
  Row _buildFilteredAnimal(double currentDiagonal, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomLabel(
          text: 'Filtrar por:',
          fontSize: currentDiagonal * .013,
        ),
        gapW(currentDiagonal * .01),
        Container(
          //padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(
              width: .5,
              color: Theme.of(context).colorScheme.secondary,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton(
            value: _dropdownValue,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            dropdownColor: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            underline: Container(),
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue;
              });
            },
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                value: 'all',
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
              DropdownMenuItem<String>(
                value: 'dog',
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
              DropdownMenuItem<String>(
                value: 'cat',
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
        ),
      ],
    );
  }

  // Titulo de la pagina
  Column _buildTitlePage(double currentDiagonal, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomLabel(
          textAlign: TextAlign.center,
          text: 'Cada mascota merece un hogar amoroso.',
          fontSize: currentDiagonal * .03,
          fontWeight: FontWeight.w600,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomLabel(
              text: 'Adopta',
              color: Theme.of(context).colorScheme.primary,
              fontSize: currentDiagonal * .03,
              fontWeight: FontWeight.w600,
            ),
            CustomLabel(
              text: ' una mascota hoy.',
              fontSize: currentDiagonal * .03,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        gapH(currentDiagonal * .01),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: currentDiagonal * .022),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      'Explore nuestros animales disponibles y obtenga más información sobre el proceso de adopción. ',
                  style: GoogleFonts.inter(
                    fontSize: currentDiagonal * .012,
                  ),
                ),
                TextSpan(
                  text:
                      'Juntos, podemos rescatar, \nrehabilitar y realojar a las mascotas necesitadas.',
                  style: GoogleFonts.inter(
                    fontSize: currentDiagonal * .012,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text:
                      'Gracias por apoyar nuestra misión de llevar alegría a las familias a través de la adopción de mascotas.',
                  style: GoogleFonts.inter(
                    fontSize: currentDiagonal * .012,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Card de cada animal
  Widget _buildCard(
    BuildContext context, {
    required double currentDiagonal,
    required String image,
    required void Function()? onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
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
                        image: NetworkImage(image), fit: BoxFit.cover),
                  ),
                ),
              ),

              //  Descripcion
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomLabel(
                        text: 'Macho',
                        fontWeight: FontWeight.w500,
                        fontSize: currentDiagonal * .015,
                      ),
                      CircleAvatar(
                        radius: currentDiagonal * .015,
                        child: Icon(FontAwesomeIcons.mars,
                            size: currentDiagonal * .015),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
