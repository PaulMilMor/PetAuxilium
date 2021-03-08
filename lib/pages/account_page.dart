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
          _userInfo(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Mi Cuenta'),
          ),
          _buttonColumn(),
        ],
      ),
    );
  }

  Widget _userInfo() {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(this._user.imgRef),
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
                    this._user.name,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Text(this._user.email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //_editProfileBtn(),
          _myPostsButton(),
          _postBusinessButton(),
          _caretakerButton(),
          //_createPostButton(),
          //_followedButton(),
          // _settingsButton(),
          _logoutButton(),
        ],
      ),
    );
  }

  Widget _editProfileBtn() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Editar perfil',
        icon: Icons.navigate_next,
        onPressed: () {},
      ),
    );
  }

  Widget _myPostsButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Mis publicaciones',
        icon: Icons.navigate_next,
        onPressed: () {},
      ),
    );
  }

  Widget _postBusinessButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Publicar mi negocio',
        icon: Icons.navigate_next,
        onPressed: () {
          Navigator.pushNamed(context, 'CreateBusiness');
        },
      ),
    );
  }

  Widget _caretakerButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Anunciarme como cuidador',
        icon: Icons.navigate_next,
        onPressed: () {
          Navigator.pushNamed(context, 'caretakerPage');
        },
      ),
    );
  }

  Widget _followedButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Publicaciones seguidas',
        icon: Icons.navigate_next,
        onPressed: () {},
      ),
    );
  }

  Widget _settingsButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Ajustes',
        icon: Icons.navigate_next,
        onPressed: () {},
      ),
    );
  }

  Widget _logoutButton() {
    return GrayFlatButton(
      text: 'Cerrar sesión',
      icon: Icons.navigate_next,
      onPressed: () {
        _prefs.userID = ' ';
        _prefs.userName = null;
        _prefs.userImg = null;
        _prefs.userEmail = null;
        _prefs.selectedIndex = 0;
        print('USER ID');
        print(_prefs.userID);
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      },
    );
  }
}
