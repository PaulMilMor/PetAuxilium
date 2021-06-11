

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/widgets/button_widget.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/push_notifications_util.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final preferencesUtil _prefs = preferencesUtil();
  final String adminID='gmMu6mxOb1RN9D596ToO2nuFMKQ2';
  PushNotificationUtil notifications = PushNotificationUtil();
  UserModel _user;
  void initState() {
    super.initState();
    if (_prefs.userID != ' ') {
      _user = UserModel(
        name: _prefs.userName,
        email: _prefs.userEmail,
        imgRef: _prefs.userImg,
      );
    } else {
      _user = UserModel(
        name: 'Usuario Anónimo',
        email: '',
        imgRef: ' ',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Center(
              child: Text(
                'PERFIL',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
            _userInfo(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text('Mi Cuenta'),
            ),
            _buttonColumn(),
          ],
        ),
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
              backgroundColor: Colors.white,
              radius: 50,
            ),
            Flexible(
              child: Column(
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
            ),
          ],
        ),
      ),
    );
  }

  bool isAdmin() {
    if (_prefs.userID == adminID) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buttonColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (!isAdmin()) _editProfileBtn(),
          if (!isAdmin()) _myPostsButton(),
          if (!isAdmin()) _followListButton(),
          //if (!isAdmin()) _postBusinessButton(),
          //if (!isAdmin()) _caretakerButton(),
          //if (!isAdmin()) _complaintButton(),
          if (isAdmin()) _donationsButton(),
          //_createPostButton(),
          //_followedButton(),
          // _settingsButton(),
          if (!isAdmin()) _settingsButton(),
          _logoutButton(),

          //if (!isAdmin()) _switchB(),
        ],
      ),
    );
  }

  Widget _editProfileBtn() {
    if (this._user.imgRef.contains('googleusercontent')) {
      return Container(
        decoration: BoxDecoration(border: Border()),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
        child: GrayFlatButton(
          text: 'Editar perfil',
          icon: Icons.navigate_next,
          onPressed: () {
            Navigator.pushNamed(context, 'edit_account_page');
          },
        ),
      );
    }
  }

  Widget _myPostsButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Mis publicaciones',
        icon: Icons.navigate_next,
        onPressed: () {
          Navigator.pushNamed(context, 'mypublicationsPage');
        },
      ),
    );
  }

  Widget _followListButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Lista de seguimiento',
        icon: Icons.navigate_next,
        onPressed: () {
          Navigator.pushNamed(context, 'followingPage');
        },
      ),
    );
  }

  /*Widget _postBusinessButton() {
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
  }*/

  /*Widget _caretakerButton() {
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
  }*/

  Widget _settingsButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Ajustes',
        icon: Icons.navigate_next,
        onPressed: () async {
          openAppSettings();
        },
      ),
    );
  }

  /*Widget _complaintButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Hacer una denuncia',
        icon: Icons.navigate_next,
        onPressed: () {
          Navigator.pushNamed(context, 'complaintPage');
        },
      ),
    );
  }*/

  Widget _donationsButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(202, 202, 202, 1)))),
      child: GrayFlatButton(
        text: 'Asociaciones animalistas',
        icon: Icons.navigate_next,
        onPressed: () {
          Navigator.pushNamed(context, 'donationsPage');
        },
      ),
    );
  }

  Widget _logoutButton() {
    return GrayFlatButton(
      text: 'Cerrar sesión',
      icon: Icons.navigate_next,
      onPressed: () {
        _prefs.userID = ' ';
        _prefs.userName = '';
        _prefs.userImg = '';
        _prefs.userEmail = '';
        _prefs.selectedIndex = 0;
        
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      },
    );
  }

  //bool isSwitched = false;
  /*Widget _switchB() {
    return Container(
        child: Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          '    Recibir notificaciones',
          style: TextStyle(fontSize: 15),
        ),
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              //notifications.onoffNotifications(isSwitched);
              print(isSwitched);
            });
          },
          activeTrackColor: Colors.greenAccent[400],
          activeColor: Colors.greenAccent[600],
        ),
      ])
    ]));
  }*/
}
