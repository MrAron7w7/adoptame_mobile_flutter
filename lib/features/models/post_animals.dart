class PostAnimals {
  final String? description;
  final String? imagen;
  final String? gender;

  PostAnimals({
    required this.description,
    required this.imagen,
    required this.gender,
  });

  // Convertimos los datos de firebase a un objeto en post  para udarlo en app
  factory PostAnimals.fromDocument(Map<String, dynamic> doc) {
    return PostAnimals(
      description: doc['description'],
      gender: doc['gender'],
      imagen: doc['imagen'],
    );
  }

  // Convertimos un documento a mapa para enviar datos a firease

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'gender': gender,
      'imagen': imagen,
    };
  }
}
