  import 'package:adoptme/core/constants/app_assets.dart';
  import 'package:adoptme/core/enum/enums.dart';
  import 'package:adoptme/features/viewmodel/providers/seleted_dropdown_provider.dart';
  import 'package:adoptme/shared/components/components.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  import 'package:go_router/go_router.dart';
  import 'package:iconly/iconly.dart';
  
  import '../../../core/utils/utils.dart';
  import '../navbar/bottom_navbar.dart';
  
  class HomeView extends ConsumerStatefulWidget {
    const HomeView({super.key});
  
    static const name = 'home_view';
  
    @override
    ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
  }
  
  class _HomeViewState extends ConsumerState<HomeView> {
    String _profileImageUrl = '';
    bool _carga = true;
  
    @override
    void initState() {
      super.initState();
      _loadUserProfile();
    }
  
  //para obtener la foto de perfil
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
      Size size = MediaQuery
          .of(context)
          .size;
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
            _carga
                ? const CircularProgressIndicator()
                : GestureDetector(
              onTap: () {
                context.go('/${BottomNavbar
                    .name}'); //aqui ocupo ayuda para que se vaya a profile_image
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(_profileImageUrl),
              ),
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
  
    // Cuerpo de la lista
    Widget _listAnimalView() {
      final filterAnimal = ref.watch(seletedDropdownProvider);
  
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
            itemCount: posts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
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
  
              // Retornamos un FutureBuilder que nos traera siempre el nombre de usuario actualizado
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
  
                  // nombre de usuario desde la coleccion "users"
                  final username = userSnapshot.data!['username'];
  
                  return _buildCard(
                      imageUrl, description, gender, animalType, username);
                },
              );
            },
          );
        },
      );
    }
  
    Widget _buildCard(String imageUrl, String description, String gender,
        String animalType, String username) {
      return GestureDetector(
        onTap: () =>
            _showDialogDetails(
                imageUrl, description, gender, animalType, username),
        child: Card(
          color: Theme
              .of(context)
              .colorScheme
              .surface,
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
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
  
              // Descripción
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomLabel(
                      text: '$animalType - $gender',
                      fontWeight: FontWeight.w500,
                    ),
                    CircleAvatar(
                      radius: 10,
                      child: Icon(
                        gender == 'Macho'
                            ? FontAwesomeIcons.mars
                            : FontAwesomeIcons.venus,
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  
    void _showDialogDetails(String imageUrl, String description, String gender,
        String animalType, String username) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomLabel(
                    text: 'Detalles',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Color de texto suave pero visible
                  ),
                  gapH(20),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  gapH(20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomLabel(
                          text: 'Descripción',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        gapH(5),
                        CustomLabel(
                          text: description,
                          color: Colors
                              .black54, // Descripción en un color más suave
                        ),
                        gapH(10),
                        CustomLabel(
                          text: 'Tipo: $animalType - Género: $gender',
                          color: Colors.black87,
                        ),
                        gapH(10),
                        CustomLabel(
                          text: 'Publicado por: $username',
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  gapH(25),
                  CustomButton(
                    onPressed: () => context.pop(),
                    text: 'Adoptame',
                  ),
                ],
              ),
            ),
      );
    }
  
    // DropdownButton para seleccion de tipo
    Widget _buildDropDownButton(BuildContext context, {
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
              dropdownColor: Theme
                  .of(context)
                  .colorScheme
                  .surface,
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
  }
   /*
     int _selectedValue = 1;
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
        },
      );
    }
    */
  
