import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Método para registrar un nuevo usuario con correo electrónico y contraseña
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Guardar información del usuario en Firestore
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName ?? 'Usuario',
          'uid': user.uid,
        });
      }

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Método para iniciar sesión con correo electrónico y contraseña
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Guardar o actualizar información del usuario en Firestore
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName ?? 'Usuario',
          'uid': user.uid,
        }, SetOptions(merge: true));
      }

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Obtener el usuario actual
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }
}
