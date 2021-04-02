import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';

import 'package:pet_auxilium/utils/prefs_util.dart';

class AuthUtil {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final preferencesUtil _prefs = preferencesUtil();
  final _db = dbUtil();
  //Utiliza los datos del modelo User para registrar los datos en la base de datos y En el servicio de aunteticacion de firebase
  Future registerWithEmailAndPassword(UserModel user) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.pass);
      user.id = result.user.uid;
      await _db.addUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> updateEmail(String email) async {
    var firebaseUser = await _auth.currentUser;
    firebaseUser.updateEmail(email);
    print(email);
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;
    firebaseUser.updatePassword(password);
    print(_auth.currentUser);
  }

//c
  //Obtiene email y password para ingresar

  //TODO:  Utilizar SharedPreferences para que la configuracion se quede guardada en el telefono

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(result);

      UserModel userModel = await _db.getUser(result.user.uid);
      print('SIGN IN');
      print(result.user.uid);

      _prefs.userID = result.user.uid;
      _prefs.selectedIndex = 0;
      return 'Ingresó';
      //_prefs.userName = userModel.name;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No se encontró el usuario.';
          break;
        case 'wrong-password':
          return 'La contraseña es incorrecta.';
          break;
        case 'invalid-email':
          return 'El correo electrónico no es válido.';
          break;
        case 'too-many-requests':
          return 'Se bloquearon las solicitudes del dispositivo por actividad inusual. Intentalo más tarde';
          break;
        default:
          return 'Algo salió mal. Error [${e.code}]';
          break;
      }
    } on PlatformException catch (e) {
      print('ERROR');
      print(e);
    }
    /*
    catch (error) {
      print('ERROR');
      print(error);
    }*/
  }

  //Retorna un usuario con nombre 'anonimo' y con una id generada automaticamente
  Future<UserModel> signInAnon() async {
    try {
      //TODO:Poner img default para los anonimos
      var result = await _auth.signInAnonymously();
      print(result.user);
      return (UserModel(id: result.user.uid, name: "anonimo"));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Cerrar Sesion
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final authResult = await _auth.signInWithCredential(credential);
      final user = authResult.user;

      List<String> follows = await _db.getFollows(user.uid);
      UserModel userModel = UserModel(
          id: user.uid,
          name: user.displayName,
          email: user.email,
          imgRef: user.photoURL,
          follows: follows);
      print(user);
      _db.addUser(userModel);
      _prefs.userName = userModel.name;
      _prefs.userID = userModel.id;
      _prefs.userImg = userModel.imgRef;
      _prefs.userEmail = userModel.email;
      return 'Ingresó';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No se encontró el usuario.';
          break;
        case 'wrong-password':
          return 'La contraseña es incorrecta.';
          break;
        case 'invalid-email':
          return 'El correo electrónico no es válido.';
          break;
        default:
          return 'Algo salió mal. Error [${e.code}]';
          break;
      }
      // assert(!user.isAnonymous);
      // assert(await user.getIdToken() != null);

      //return user;
    }

    void signOutGoogle() async {
      await _googleSignIn.signOut();
    }
  }
}
