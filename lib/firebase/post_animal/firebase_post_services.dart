import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../features/models/post_animals.dart';

class FirebasePostServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Subir la imagen a Firebase Storage
  Future<String> uploadImage(File imageFile) async {
    try {
      String filePath = 'animal_photos/${DateTime.now().millisecondsSinceEpoch}.png';
      UploadTask uploadTask = _storage.ref().child(filePath).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error al subir la imagen: $e');
      return '';
    }
  }

  // Guardar un nuevo post en Firestore
  Future<void> createPost(PostAnimals post) async {
    try {
      await _db.collection('posts').add(post.toMap());
      print("Post guardado exitosamente.");
    } catch (e) {
      print("Error al guardar el post: $e");
    }
  }
}
