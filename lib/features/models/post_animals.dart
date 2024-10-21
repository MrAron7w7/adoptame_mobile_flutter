class PostAnimals {
  final String? description;
  final String? imagen;
  final String? gender;
  final String? animalType;
  final String userId;

  PostAnimals({
    required this.description,
    required this.imagen,
    required this.gender,
    required this.animalType,
    required this.userId,
  });

  // Convertimos los datos de firebase a un objeto en post para usarlo en app
  factory PostAnimals.fromDocument(Map<String, dynamic> doc) {
    return PostAnimals(
      description: doc['description'],
      gender: doc['gender'],
      animalType: doc['animalType'],
      imagen: doc['imagen'],
      userId: doc['userId'],
    );
  }

  // Convertimos un documento a mapa para enviar datos a firebase
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'gender': gender,
      'animalType': animalType,
      'imagen': imagen,
      'userId': userId,
    };
  }
}
