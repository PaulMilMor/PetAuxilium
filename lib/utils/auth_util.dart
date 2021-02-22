import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/models/publication_model.dart';

class AuthUtil {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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

  //Obtiene email y password para ingresar

  //TODO:  Utilizar SharedPreferences para que la configuracion se quede guardada en el telefono
  Future signInWithEmailAndPassword(String email, String password) async {
    print('SIGN IN');
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Future<UserModel> user = _db.getUser(result.user.uid);
      print('SIGN IN TRY');
      print(user);
      return user;
    } catch (error) {
      print('SIGN IN CATCH');
      print(error.toString());
      return null;
    }
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

  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final authResult = await _auth.signInWithCredential(credential);
    final user = authResult.user;
    print(user);
    // assert(!user.isAnonymous);
    // assert(await user.getIdToken() != null);

    //return user;
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
