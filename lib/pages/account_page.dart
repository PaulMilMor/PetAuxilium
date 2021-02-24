import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/widgets/button_widget.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final preferencesUtil _prefs = preferencesUtil();

  UserModel _user;
  void initState() {
    super.initState();
    if (_prefs.userID != ' ') {
      _user = UserModel(
        name: _prefs.userName,
        //birthday: "16/02/99",
        email: _prefs.userEmail,
        imgRef: _prefs.userImg,
      );
    } else {
      _user = UserModel(
        name: 'Usuario Anónimo',
        email: '',
        imgRef: ' ',
        //imgRef:
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileInfo(_user.name, _user.email, _user.imgRef),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Mi Cuenta'),
          ),
          ButtonColumn(),
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  ProfileInfo(this._name, this._email, this._imgRef);
  final String _name;
  final String _email;
  final String _imgRef;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(this._imgRef),
              backgroundColor: Color.fromRGBO(210, 210, 210, 1),
              radius: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 11.0),
                  child: Text(
                    this._name,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Text(this._email),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonColumn extends StatelessWidget {
  final preferencesUtil _prefs = preferencesUtil();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
            child: GrayFlatButton(
              text: 'Editar perfil',
              icon: Icons.navigate_next,
              onPressed: () {},
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
            child: GrayFlatButton(
              text: 'Mis publicaciones',
              icon: Icons.navigate_next,
              onPressed: () {},
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
            child: GrayFlatButton(
              text: 'Publicar mi negocio',
              icon: Icons.navigate_next,
              onPressed: () {
                Navigator.pushNamed(context, 'CreateBusiness');
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
            child: GrayFlatButton(
              text: 'Anunciarme como cuidador',
              icon: Icons.navigate_next,
              onPressed: () {},
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
            child: GrayFlatButton(
              text: 'Mis Publicaciones',
              icon: Icons.navigate_next,
              onPressed: () {},
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
            child: GrayFlatButton(
              text: 'Publicaciones seguidas',
              icon: Icons.navigate_next,
              onPressed: () {},
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
            child: GrayFlatButton(
              text: 'Ajustes',
              icon: Icons.navigate_next,
              onPressed: () {},
            ),
          ),
          GrayFlatButton(
            text: 'Cerrar sesión',
            icon: Icons.navigate_next,
            onPressed: () {
              _prefs.userID = null;
              _prefs.userName = null;
              _prefs.userImg = null;
              _prefs.userEmail = null;

              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
