import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';
import 'package:pet_auxilium/widgets/appbar_widget.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: la AppBar fue creada como widget independiente pero hace falta añadirla aquí de esa manera
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child:
            //EmptyAppBar(),
            AppBar(
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
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(36.0),
            child: SingleChildScrollView(
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
                        'Crea una cuenta',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 232, 93, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                      child: GrayTextFormField(
                        hintText: 'Nombre',
                        textCapitalization: TextCapitalization.words,
                        controller: _nameController,
                        validator: (value) {
                          return value.trim().isEmpty
                              ? 'Introduce tu nombre'
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                      child: GrayTextFormField(
                        hintText: 'Apellido',
                        textCapitalization: TextCapitalization.words,
                        controller: _lastNameController,
                        validator: (value) {
                          return value.trim().isEmpty
                              ? 'Introduce tu Apellido'
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                      child: GrayTextFormField(
                        hintText: 'E-mail',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Introduce tu correo electrónico';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Ingresa un correo válido';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                      child: GrayTextFormField(
                        hintText: 'Contraseña',
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Ingresa una contraseña';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                      child: GrayTextFormField(
                        hintText: 'Confirmar contraseña',
                        obscureText: true,
                        controller: _confirmController,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Ingresa confirmación de contraseña';
                          } else if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          child: Text('Registrarse',
                              style: TextStyle(
                                  color: Color.fromRGBO(49, 232, 93, 1))),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _signUp(context);
                            }
                            ;
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
                          text: 'Registrarse con Google',
                          darkMode: true,
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  _signUp(BuildContext context2) async {
    UserModel _user = UserModel(
      name: _nameController.text + ' ' + _lastNameController.text,
      email: _emailController.text,
      pass: _passwordController.text,
      //imgRef??
      //birthday??
    );
    AuthUtil _auth = AuthUtil();
    await _auth.registerWithEmailAndPassword(_user);
    String _result =
        await _auth.signInWithEmailAndPassword(_user.email, _user.pass);
    if (_result == 'Ingresó') {
      Navigator.pushNamedAndRemoveUntil(
          context, 'navigation', (Route<dynamic> route) => false);
    } else {
      Scaffold.of(context2)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_result)));
    }
  }
}
