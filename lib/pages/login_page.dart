import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
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
  final preferencesUtil prefs = preferencesUtil();
  //UserModel user;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pswdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: la AppBar fue creada como widget independiente pero hace falta añadirla aquí de esa manera
      appBar: PreferredSize(
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
      ),
      body: Builder(
        builder: (context) => Container(
          color: Colors.white,
          width: double.infinity,
          child: Padding(
              padding: EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 12),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 232, 93, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
                      child: GrayTextFormField(
                        hintText: 'Correo Electrónico',
                        controller: _emailController,
                        validator: (value) {
                          return value.trim().isEmpty
                              ? 'Introduce el correo'
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
                      child: GrayTextFormField(
                        hintText: 'Contraseña',
                        controller: _pswdController,
                        obscureText: true,
                        validator: (value) {
                          return value.trim().isEmpty
                              ? 'Introduce la contraseña'
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          child: Text('Continuar',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(49, 232, 93, 1),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _login(context);
                            }
                          },
                        ),
                      ),
                    ),
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                        child: GoogleSignInButton(
                          onPressed: () {},
                          text: 'Ingresar con Google',
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

//metodo para ingresar usando auth
  _login(BuildContext context2) async {
    String _email = _emailController.text;
    String _password = _pswdController.text;
    await auth.signInWithEmailAndPassword(_email, _password);
    print('LOGIN');
    print(prefs.userName);
    if (prefs.userName == null) {
      Scaffold.of(context2)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Error al ingresar')));
    } else {
      Scaffold.of(context2)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Ingreso correcto')));
    }

    Navigator.pushNamed(context, 'navigation');
  }
}
