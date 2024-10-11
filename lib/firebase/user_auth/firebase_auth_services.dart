import 'package:firebase_auth/firebase_auth.dart';

import '../../core/utils/toast.dart';

class FirebaseAuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        showToast(message: 'Este correo ya está registrado');
      }else if (error.code == 'channel-error') {
        showToast(message: 'Rellenar los contenedores');
      }
      else if (error.code == 'invalid-email') {
        showToast(message: 'Correo inválido');
      } else if (error.code == 'weak-password') {
        showToast(message: 'La contraseña es demasiado débil');
      } else {
        showToast(message: 'Ocurrió un error: ${error.code}');
      }
    }
    return null;
  }



  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-credential') {
        showToast(message: 'Correo o contraseña invalidos.');
      } else if (error.code == 'channel-error') {
        showToast(message: 'Rellenar los contenedores');
      }else if (error.code == 'invalid-email') {
        showToast(message: 'Correo electrónico no válido');
      } else if (error.code == 'missing-password') {
        showToast(message: 'Falta la contraseña');
      } else {
        showToast(message: 'Ocurrió un error: ${error.code}');
      }
    }
    return null;
  }
}
