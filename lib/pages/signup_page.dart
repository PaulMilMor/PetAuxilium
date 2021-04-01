import 'dart:io';
import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/ImageUploadModel.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/storage_util.dart';
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
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  FocusScopeNode node;
  bool _imageSelected = true;
  AuthUtil _auth = AuthUtil();
  final StorageUtil _storage = StorageUtil();
  final _db = dbUtil();
  final preferencesUtil _prefs = preferencesUtil();
  Future<File> _imageFile;
  ImageUploadModel _image = null;

  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);
    return Scaffold(
      //TODO: la AppBar fue creada como widget independiente pero hace falta añadirla aquí de esa manera
      /*appBar: PreferredSize(
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
      ),*/
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
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
                  'Crea una cuenta',
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
                child: Padding(
                    padding: EdgeInsets.all(36.0), child: _signUpForm()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Text(
              'Crea una cuenta',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(49, 232, 93, 1),
              ),
            ),
          ),*/
          _photo(),
          _nameTxt(),
          _lastNameTxt(),
          _emailTxt(),
          _passwordTxt(),
          _confirmPasswordTxt(),
          _signUpButton(),
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
          _googleSignUpButton(),
        ],
      ),
    );
  }

  Widget _photo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Row(
        children: [
          _image == null ? _addPhoto() : _removePhoto(),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _imageSelected
                  ? Text('Foto de Perfil')
                  : Text('Selecciona una foto de perfil',
                      style: TextStyle(
                        color: Color.fromRGBO(232, 49, 93, 1),
                      )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addPhoto() {
    return FlatButton(
      onPressed: () {
        _onAddImageClick();
      },
      color: Colors.grey[200],
      height: 85,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
      child: Column(
        children: [
          Icon(
            Icons.add_a_photo,
            size: 48,
            color: Color.fromRGBO(210, 210, 210, 1),
          ),
        ],
      ),
    );
  }

  Widget _removePhoto() {
    print('JALO');
    print(_image);
    print(_image.imageFile);
    return Stack(
      children: <Widget>[
        CircleAvatar(
          child: ClipOval(
            child: Image.file(
              _image.imageFile,
              width: 100,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          backgroundColor: Color.fromRGBO(210, 210, 210, 1),
          radius: 42.5,
        ),
        Positioned(
          right: -3,
          bottom: -3,
          child: InkWell(
            child: Icon(
              Icons.edit,
              size: 20,
              color: Color.fromRGBO(49, 232, 93, 1),
            ),
            onTap: () {
              _onAddImageClick();
              /* setState(() {
                images.removeAt(index);
                // images.replaceRange(index, index + 1, ['Add Image']);
                _imgsFiles.remove(index);
                //         images.replaceRange(index, index + 1, ['Add Image']);
              });*/
            },
          ),
        ),
        /*Positioned(
          bottom: -11,
          right: 20,
          child: FlatButton(
            onPressed: () {
              _onAddImageClick();
            },
            color: Color.fromRGBO(49, 232, 93, 1),
            height: 30,
            minWidth: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0)),
            child: Column(
              children: [
                Icon(
                  Icons.add_a_photo,
                  size: 15,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),*/
      ],
    );
  }

  Future _onAddImageClick() async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      if (_imageFile != null) {
        print('NOT NULL');
        print(_imageFile);
        getFileImage();
      }
    });
  }

  void getFileImage() async {
    _imageFile.then((file) async {
      //  _imgRef = await _storage.uploadFile(file, 'usuarios');
      if (file != null) {
        setState(() {
          ImageUploadModel imageUpload = new ImageUploadModel();
          imageUpload.isUploaded = false;
          imageUpload.uploading = false;
          imageUpload.imageFile = file;
          imageUpload.imageUrl = '';
          print('Image UPLOAD');
          _image = imageUpload;
          _imageSelected = true;
        });
      } else {
        setState(() {
          if (_image == null) {
            _imageSelected = false;
          }
        });
      }
    });
  }

  Widget _nameTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
        hintText: 'Nombre',
        textCapitalization: TextCapitalization.words,
        controller: _nameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value.trim().isEmpty ? 'Introduce tu nombre' : null;
        },
        onEditingComplete: () {
          if (_nameController.text.trim().isNotEmpty) {
            node.nextFocus();
          } else {
            _nameController.text = 'a';
            _nameController.text = '';
          }
        },
      ),
    );
  }

  Widget _lastNameTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
        hintText: 'Apellido',
        textCapitalization: TextCapitalization.words,
        controller: _lastNameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value.trim().isEmpty ? 'Introduce tu Apellido' : null;
        },
        onEditingComplete: () {
          if (_lastNameController.text.trim().isNotEmpty) {
            node.nextFocus();
          } else {
            _lastNameController.text = 'a';
            _lastNameController.text = '';
          }
        },
      ),
    );
  }

  Widget _emailTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
        hintText: 'E-mail',
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'Introduce tu correo electrónico';
          } else if (!EmailValidator.validate(value)) {
            return 'Ingresa un correo válido';
          }
          return null;
        },
        onEditingComplete: () {
          if (_emailController.text.trim().isNotEmpty &&
              EmailValidator.validate(_emailController.text)) {
            node.nextFocus();
          } else if (_emailController.text.trim().isEmpty) {
            _emailController.text = 'a';
            _emailController.text = '';
          }
        },
      ),
    );
  }

  Widget _passwordTxt() {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])';
    RegExp regExp = new RegExp(pattern);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
        hintText: 'Contraseña',
        obscureText: true,
        controller: _passwordController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'Ingresa una contraseña';
          } else if (value.trim().length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          } else if (!regExp.hasMatch(value)) {
            return 'Incluye mayúsculas, minúsculas, y números';
          }
          return null;
        },
        onEditingComplete: () {
          if (_passwordController.text.trim().isNotEmpty &&
              _passwordController.text.trim().length >= 6 &&
              regExp.hasMatch(_passwordController.text.trim())) {
            node.nextFocus();
          } else if (_passwordController.text.trim().isEmpty) {
            _passwordController.text = 'a';
            _passwordController.text = '';
          }
        },
      ),
    );
  }

  Widget _confirmPasswordTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
        hintText: 'Confirmar contraseña',
        obscureText: true,
        controller: _confirmController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'Ingresa confirmación de contraseña';
          } else if (value != _passwordController.text) {
            return 'Las contraseñas no coinciden';
          }
          return null;
        },
        onEditingComplete: () {
          if (_confirmController.text.trim().isNotEmpty &&
              _confirmController.text == _passwordController.text) {
            if (_formKey.currentState.validate()) {
              print('VALIDATE');
              print(_imageFile);
              if (_image == null) {
                node.unfocus();

                setState(() {
                  _imageSelected = false;
                });
              } else {
                setState(() {
                  _isLoading = true;
                });
                _signUp(context);
              }
            } else if (_image == null) {
              setState(() {
                _imageSelected = false;
              });
            }
          } else if (_confirmController.text.trim().isEmpty) {
            _confirmController.text = 'a';
            _confirmController.text = '';
          }
        },
      ),
    );
  }

  Widget _signUpButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
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
                child: Text('Registrarse',
                    style: TextStyle(color: Color.fromRGBO(49, 232, 93, 1))),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print('VALIDATE');
                    print(_imageFile);
                    if (_image == null) {
                      setState(() {
                        _imageSelected = false;
                      });
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      _signUp(context);
                    }
                  } else if (_image == null) {
                    setState(() {
                      _imageSelected = false;
                    });
                  }
                },
              ),
      ),
    );
  }

  Widget _googleSignUpButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: _isGoogleLoading
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            : GoogleSignInButton(
                text: 'Registrarse con Google',
                darkMode: true,
                onPressed: () {
                  setState(() {
                    _isGoogleLoading = true;
                  });
                  _signUpGoogle(context);
                },
              ),
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

    await _auth.registerWithEmailAndPassword(_user);
    String _result =
        await _auth.signInWithEmailAndPassword(_user.email, _user.pass);
    await _imageFile.then((file) async {
      _user.imgRef = await _storage.uploadFile(file, 'usuarios');
      _prefs.userImg = _user.imgRef;
      print('IMGREF');
      print(_user.imgRef);
      _db.addUser(_user);
    });

    if (_result == 'Ingresó') {
      _isLoading = false;
      Navigator.pushNamedAndRemoveUntil(
          context, 'navigation', (Route<dynamic> route) => false);
    } else {
      _isLoading = false;
      ScaffoldMessenger.of(context2)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_result)));
    }
  }

  _signUpGoogle(BuildContext context) async {
    String _result = await _auth.signInWithGoogle();
    print(context);
    print("dentro del registro google");
    if (_result == 'Ingresó') {
      _isGoogleLoading = false;
      Navigator.pushNamedAndRemoveUntil(
          context, 'navigation', (Route<dynamic> route) => false);
    } else {
      _isGoogleLoading = false;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_result)));
    }
  }
}
