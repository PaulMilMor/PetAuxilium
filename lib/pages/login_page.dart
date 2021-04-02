import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';
import 'package:pet_auxilium/models/user_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final auth = AuthUtil();
  final _db = dbUtil();
  final preferencesUtil prefs = preferencesUtil();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  FocusScopeNode node;
  //UserModel user;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pswdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context).settings.name);
    node = FocusScope.of(context);
    return Scaffold(
      //TODO: la AppBar fue creada como widget independiente pero hace falta añadirla aquí de esa manera
      /*appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: new IconButton(
                icon: new Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromRGBO(49, 232, 93, 1),
                ),
                onPressed: () => Navigator.of(context).pop(),
                iconSize: 32,
              ),
            ),
            backgroundColor: Colors.white,
            actions: [
              Image.asset(
                'assets/logo_asset.png',
                //width: 120,
              ),
            ]),
      ),*/
      body: Builder(
        builder: (context) => SafeArea(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              elevation: 1,
              expandedHeight: 200,
              leading: IconButton(
                icon: new Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromRGBO(49, 232, 93, 1),
                ),
                onPressed: () => Navigator.of(context).pop(),
                iconSize: 32,
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(49, 232, 93, 1),
                  ),
                ),
                background: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/logo_asset.png',
                    width: 100,
                    //width: 120,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child:
                    Padding(padding: EdgeInsets.all(36.0), child: _loginForm()),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(49, 232, 93, 1),
              ),
            ),
          ),*/
          _emailTxt(),
          _passwordTxt(),
          _loginButton(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 72, 12, 6),
            child: Row(
              children: [
                Expanded(child: Divider()),
                Text('O ingresa con Google®'),
                Expanded(
                  child: Divider(),
                ),
              ],
            ),
          ),
          _googleLoginButton(),
        ],
      ),
    );
  }

  Widget _emailTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
      child: GrayTextFormField(
        hintText: 'Correo Electrónico',
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          return value.trim().isEmpty ? 'Introduce el correo' : null;
        },
        onEditingComplete: () => node.nextFocus(),
      ),
    );
  }

  Widget _passwordTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
      child: GrayTextFormField(
        hintText: 'Contraseña',
        controller: _pswdController,
        obscureText: true,
        validator: (value) {
          return value.trim().isEmpty ? 'Introduce la contraseña' : null;
        },
        onEditingComplete: () {
          if (_formKey.currentState.validate()) {
            node.unfocus();
            setState(() {
              _isLoading = true;
            });
            _login();
          }
        },
      ),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
      child: Align(
        alignment: Alignment.centerRight,
        child: _isLoading
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
                child: CircularProgressIndicator(
                  backgroundColor: Color.fromRGBO(49, 232, 93, 1),
                ),
              )
            : ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      Text('Continuar', style: TextStyle(color: Colors.white)),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(49, 232, 93, 1),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    _login();
                  }
                },
              ),
      ),
    );
  }

  Widget _googleLoginButton() {
    return Center(
      child: _isGoogleLoading
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                //backgroundColor: Color.fromRGBO(49, 232, 93, 1),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: GoogleSignInButton(
                onPressed: () {
                  setState(() {
                    _isGoogleLoading = true;
                  });
                  _loginGoogle();
                },
                text: 'Ingresar con Google',
              ),
            ),
    );
  }

//metodo para ingresar usando auth
  _login() async {
    String _email = _emailController.text;
    String _password = _pswdController.text;
    String _result = await auth.signInWithEmailAndPassword(_email, _password);
    print('LOGIN');
    print(prefs.userName);
    List<String> _bans = await _db.bansList();
    if (_result == 'Ingresó') {
      setState(() {
        _isLoading = false;
      });
      if (_bans.contains(prefs.userID)) {
        print('suspendido');
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text('Esta cuenta ha sido suspendida')));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, 'navigation', (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('POOL LOGIN ERROR');
      print(_result);
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_result)));
    }
  }

  _loginGoogle() async {
    String _result = await auth.signInWithGoogle();
    print('LOGIN');
    print(prefs.userName);
    if (_result == 'Ingresó') {
      Navigator.pushNamedAndRemoveUntil(
          context, 'navigation', (Route<dynamic> route) => false);
      setState(() {
        _isGoogleLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_result)));
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }
}
