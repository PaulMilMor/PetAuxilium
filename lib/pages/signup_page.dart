import 'package:flutter/material.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO la AppBar fue creada como widget independiente pero hace falta añadirla aquí de esa manera
      //FIX El contenido de este widget hace overflow en una pantalla de 1280p
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
                'lib/assets/logo_asset.png',
                //width: 120,
              ),
            ]),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(36.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
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
                  child: GrayTextField(
                    hintText: 'Nombre',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                  child: GrayTextField(
                    hintText: 'Apellido',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                  child: GrayTextField(
                    hintText: 'E-mail',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                  child: GrayTextField(
                    hintText: 'Contraseña',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                  child: GrayTextField(
                    hintText: 'Confirmar contraseña',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      child: Text('Registrarse',
                          style:
                              TextStyle(color: Color.fromRGBO(49, 232, 93, 1))),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      onPressed: () {},
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
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
