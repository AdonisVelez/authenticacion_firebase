import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para iniciar sesión
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Propaga el error específico de Firebase
      throw e;
    } catch (e) {
      // Propaga otros errores como genéricos
      throw Exception('Error inesperado: $e');
    }
  }

  // Método para registrar un nuevo usuario
  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Propaga el error específico de Firebase
      throw e;
    } catch (e) {
      // Propaga otros errores como genéricos
      throw Exception('Error inesperado: $e');
    }
  }
}
