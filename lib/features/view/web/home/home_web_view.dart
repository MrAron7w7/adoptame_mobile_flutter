import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/view/views.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/enum/enums.dart';
import '../../../../core/utils/utils.dart';
import '../../../viewmodel/providers/seleted_dropdown_provider.dart';

class HomeWebView extends ConsumerStatefulWidget {
  const HomeWebView({super.key});

  @override
  ConsumerState<HomeWebView> createState() => _HomeWebViewState();
}

class _HomeWebViewState extends ConsumerState<HomeWebView> {
  String _profileImageUrl = '';
  bool _carga = true;

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
            _profileImageUrl = userDoc['profileImageUrl'] ??
                'https://firebasestorage.googleapis.com/v0/b/adoptame-db.appspot.com/o/Default%2FdefaultProfile.jpg?alt=media&token=404d673e-627f-4c6d-bc5f-be02f4005985';
            _carga = false;
          });
        }
      } catch (e) {
        print("Error: $e");
        setState(() {
          _carga = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final filterAnimal = ref.watch(seletedDropdownProvider);

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
                    _buildFilteredAnimal(
                        currentDiagonal, context, filterAnimal),

                    gapH(currentDiagonal * .03),

                    // Cuerpo de la vista de los animales
                    _buildAnimalGrid(size, currentDiagonal, filterAnimal),
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

  Widget _buildAnimalGrid(
      Size size, double currentDiagonal, FilterAnimal filterAnimal) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<QueryDocumentSnapshot> posts = snapshot.data!.docs;

        if (filterAnimal == FilterAnimal.dog) {
          posts = posts.where((post) => post['animalType'] == 'Perro').toList();
        } else if (filterAnimal == FilterAnimal.cat) {
          posts = posts.where((post) => post['animalType'] == 'Gato').toList();
        }

        if (posts.isEmpty) {
          return const Center(child: Text('No hay publicaciones.'));
        }

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: posts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size.width > 830 ? 4 : 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final post = posts[index];
            final imageUrl = post['imagen'];
            final description = post['description'];
            final gender = post['gender'];
            final animalType = post['animalType'];
            final userId = post['userId'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final username = userSnapshot.data!['username'];

                return _buildCard(
                  context,
                  currentDiagonal: currentDiagonal,
                  onTap: () => _showDialogDetails(
                    context,
                    size,
                    imageUrl,
                    description,
                    gender,
                    animalType,
                    username,
                  ),
                  image: imageUrl,
                  gender: '$animalType - $gender',
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDialogDetails(
    BuildContext context,
    Size size,
    String imageUrl,
    String description,
    String gender,
    String animalType,
    String username,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: SizedBox(
          width: size.width * .5,
          height: size.width * .3,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: size.width,
                  height: size.height,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        elevation: 10,
                        shape: const CircleBorder(),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomLabel(
                        text: username,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      gapH(size.height * .01),
                      CustomLabel(
                        text: 'Tipo: $animalType',
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      gapH(size.height * .01),
                      CustomLabel(
                        text: gender,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      gapH(size.height * .01),
                      CustomLabel(
                        text: description,
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
  }

  // Filtro de los animales
  Row _buildFilteredAnimal(
      double currentDiagonal, BuildContext context, FilterAnimal filterAnimal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomLabel(
          text: 'Filtrar por:',
          fontSize: currentDiagonal * .013,
        ),
        gapW(currentDiagonal * .01),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: .5,
              color: Theme.of(context).colorScheme.secondary,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<FilterAnimal>(
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
                    color: Theme.of(context).colorScheme.secondary,
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
                    color: Theme.of(context).colorScheme.secondary,
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
    required String gender,
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
                        text: gender,
                        fontWeight: FontWeight.w500,
                        fontSize: currentDiagonal * .015,
                      ),
                      CircleAvatar(
                        radius: currentDiagonal * .015,
                        child: Icon(
                          gender == 'Macho'
                              ? FontAwesomeIcons.mars
                              : FontAwesomeIcons.venus,
                          size: currentDiagonal * .015,
                        ),
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
