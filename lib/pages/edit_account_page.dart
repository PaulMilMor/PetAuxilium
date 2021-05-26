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

class Edit_account_page extends StatefulWidget {
  @override
  _Edit_account_pageState createState() => _Edit_account_pageState();
}

class _Edit_account_pageState extends State<Edit_account_page> {
  final _formKey = GlobalKey<FormState>();
  /*final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();*/
  var _nameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmController = TextEditingController();

  bool _isLoading = false;
  bool _imageSelected = true;
  AuthUtil _auth = AuthUtil();
  final StorageUtil _storage = StorageUtil();
  final _db = dbUtil();
  final preferencesUtil _prefs = preferencesUtil();
  Future<File> _imageFile;
  File imageFile;

  ImageUploadModel _image = null;
  var name;
  var imageload;
  final picker = ImagePicker();
  UserModel _user;
  void initState() {
    super.initState();
    //if (_prefs.userID != ' ') {
    _user = UserModel(
      name: _prefs.userName,
      //birthday: "16/02/99",
      email: _prefs.userEmail,
      imgRef: _prefs.userImg,
    );
    //}
    var fullname = this._user.name;
    var separate = fullname.split(" ");
    var name = separate[0].trim();
    var lastname = separate[1].trim();
    //imageload = Image.network(this._user.imgRef);
    _nameController = TextEditingController(text: name);
    _lastNameController = TextEditingController(text: lastname);
    _emailController = TextEditingController(text: this._user.email);
    //_passwordController = TextEditingController(text: this._user.pass);

    print(this._user.pass);

    print(this._user.imgRef);
  }

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
                  padding: const EdgeInsets.fromLTRB(9, 1, 12, 1),
                  child: new IconButton(
                    icon: new Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromRGBO(30, 215, 96, 1),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    iconSize: 24,
                  ),
                ),
                backgroundColor: Colors.white,
                actions: []),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 130),
              child: _signUpForm()),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            child: Text(
              'Editar cuenta',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(30, 215, 96, 1),
              ),
            ),
          ),
          _photo(),
          _nameTxt(),
          _lastNameTxt(),
          _emailTxt(),
          _passwordTxt(),
          _confirmPasswordTxt(),
          //_signUpButton(),
          _buttons(),
        ],
      ),
    );
  }

  Widget _photo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 25, 12, 6),
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
    return Row(
      children: [
        /*Image.network(this._user.imgRef,height: 85),*/
        CircleAvatar(
          backgroundImage: NetworkImage(this._user.imgRef),
          backgroundColor: Color.fromRGBO(210, 210, 210, 1),
          radius: 40,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 60, left: 0),
            child: InkWell(
              child: Icon(Icons.edit,
                  size: 20, color: Color.fromRGBO(30, 215, 96, 1)),
              onTap: () {
                _onAddImageClick();
              },
            ))
        /*Icon(
          Icons.edit,
            size: 20,
            color: Color.fromRGBO(49, 232, 93, 1),
        ),*/
      ],
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
      ],
    );
  }

  Future _onAddImageClick() async {
    final _imageFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(_imageFile.path);

    setState(() {
      if (imageFile != null) {
        print('NOT NULL');
        print(imageFile);
        getFileImage();
      }
    });
  }

  void getFileImage() async {
    //  _imgRef = await _storage.uploadFile(file, 'usuarios');
    if (imageFile != null) {
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = imageFile;
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
  }

  Widget _nameTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 25, 12, 6),
      child: GrayTextFormField(
        hintText: 'Nombre',
        textCapitalization: TextCapitalization.words,
        controller: _nameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value.trim().isEmpty ? 'Introduce tu nombre' : null;
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
      ),
    );
  }

  Widget _passwordTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
        hintText: 'Nueva contraseña',
        obscureText: true,
        controller: _passwordController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])';
          RegExp regExp = new RegExp(pattern);
          if (value.trim().isEmpty) {
            return null;
          } else {
            if (value.trim().length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            } else if (!regExp.hasMatch(value)) {
              return 'Incluye mayúsculas, minúsculas, y números';
            }
          }

          return null;
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
            return null;
          } else {
            if (value != _passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _signUpButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 12, 6),
      child: Align(
        alignment: Alignment.centerRight,
        child: _isLoading
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
                child: CircularProgressIndicator(
                  backgroundColor: Color.fromRGBO(30, 215, 96, 1),
                ),
              )
            : ElevatedButton(
                child: Text('Guardar cambios',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(30, 215, 96, 1),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print('VALIDATE');
                    print(_imageFile);
                    /*if (_image == null) {
                      setState(() {
                        _imageSelected = false;
                      });
                    } else {*/
                    setState(() {
                      _isLoading = true;
                    });
                    _signUp(context);
                    //}
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

  void _signUp(BuildContext context2) async {
    UserModel _user = UserModel(
      id: _prefs.userID,
      imgRef: _prefs.userImg,
      name: _nameController.text + ' ' + _lastNameController.text,
      email: _emailController.text,
      pass: _passwordController.text,
    );

    if (_image == null) {
      _prefs.userImg = _user.imgRef;
      _prefs.userName = _user.name;
      _prefs.userEmail = _user.email;
      print("aqui wey");
      print(_user.email);
      await _auth.updateEmail(_emailController.text);
      if (_passwordController.text != "") {
        await _auth.updatePassword(_passwordController.text);
      }
      _db.addUser(_user);
      //Aquí debería usarse un Navigator.pop, no es necesario hacer esto.
      //Pero lo voy a dejar porque funciona.
      Navigator.pushNamedAndRemoveUntil(
          context, 'navigation', (Route<dynamic> route) => false);
    } else {
      // await _imageFile.then((file) async {
      _user.imgRef = await _storage.uploadFile(imageFile, 'usuarios');
      _prefs.userImg = _user.imgRef;
      _prefs.userName = _user.name;
      _prefs.userEmail = _user.email;
      await _auth.updateEmail(_emailController.text);
      if (_passwordController.text != "") {
        await _auth.updatePassword(_passwordController.text);
      }
      print('IMGREF');
      print(_user.imgRef);
      _db.addUser(_user);
      Navigator.pushNamedAndRemoveUntil(
          context, 'navigation', (Route<dynamic> route) => false);
      // });
    }
  }

  Widget _buttons() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_CancelBtn(), _signUpButton()],
      ),
    );
  }

//USAR camelCase PLEASE
  Widget _CancelBtn() {
    return Container(
      margin: const EdgeInsets.only(right: 5.0, bottom: 7.0),
      child: TextButton(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Cancelar', style: TextStyle(color: Colors.black)),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
          primary: Color.fromRGBO(49, 232, 93, 1),
        ),
      ),
    );
  }
}
