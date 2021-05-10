import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pet_auxilium/models/ImageUploadModel.dart';

import 'package:pet_auxilium/models/donations_model.dart';

import 'package:pet_auxilium/widgets/button_widget.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';

import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/storage_util.dart';

class AddDonationsPage extends StatefulWidget {
  @override
  _AddDonationsPageState createState() => _AddDonationsPageState();
}

class _AddDonationsPageState extends State<AddDonationsPage> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _websiteController;
  final _prefs = new preferencesUtil();
  final _db = dbUtil();
  final _storage = StorageUtil();
  String _name = '';
  String _desc = '';
  String _web = '';
  bool _isLoading = false;
  Future<File> _imageFile;
  File _file;
  ImageUploadModel _imageUpload = null;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: _name);
    _descriptionController = TextEditingController(text: _desc);
    _websiteController = TextEditingController(text: _web);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(child: _donationForm(context)),
      ),
    );
  }

  _donationForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 10, 36, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              'AÑADIR ORGANIZACIÓN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text(
              'Complete los siguientes campos',
              style: TextStyle(fontSize: 18),
            ),
          ),
          _nameTxt(),
          _websiteTxt(),
          _descriptionTxt(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text(
              'Añada una imágen',
              style: TextStyle(fontSize: 18),
            ),
          ),
          _picture(),
          SizedBox(
            height: 24,
          ),
          _buttons(),
        ],
      ),
    );
  }

  Widget _nameTxt() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
        controller: _nameController,
        hintText: 'Nombre',
        maxLength: 20,
        textCapitalization: TextCapitalization.words,
        onChanged: (value) {
          setState(() {
            //prefs.businessName = value;
            _name = value;
          });
        },
        suffixIcon: IconButton(
          onPressed: () {
            _nameController.clear();
          },
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }

  Widget _websiteTxt() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
        controller: _websiteController,
        hintText: 'Sitio de contacto',
        maxLength: null,
        textCapitalization: TextCapitalization.none,
        onChanged: (value) {
          setState(() {
            //prefs.businessName = value;
            _web = value;
          });
        },
        suffixIcon: IconButton(
          onPressed: () {
            _websiteController.clear();
          },
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }

  Widget _descriptionTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: TextField(
        maxLength: 100,
        maxLines: 1,
        controller: _descriptionController,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            labelText: "Describa la organización",
            labelStyle: TextStyle(
              color: Colors.grey,
              // color: Color.fromRGBO(49, 232, 93, 1),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                _descriptionController.clear();
              },
              icon: Icon(Icons.clear),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
        onChanged: (value) {
          setState(() {
            //   prefs.businessDescription = value;
            _desc = value;
          });
        },
      ),
    );
  }

  Widget _picture() {
    return Center(child: _imageUpload == null ? _addPhoto() : _removePhoto());
  }

  Widget _addPhoto() {
    return Container(
      height: 100,
      width: 175,
      child: AddImageButton(
        onTap: _onAddImageClick,
      ),
    );
  }

  Widget _removePhoto() {
    return Stack(
      children: [
        Image.file(
          _imageUpload.imageFile,
          width: 175,
          height: 100,
          fit: BoxFit.cover,
        ),
        Positioned(
          right: -7,
          bottom: -7,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            padding: EdgeInsets.all(10),
            child: InkWell(
              child: Icon(
                Icons.edit,
                size: 25,
                color: Color.fromRGBO(49, 232, 93, 1),
              ),
              onTap: () {
                _onAddImageClick();
              },
            ),
          ),
        ),
      ],
    );
  }

  Future _onAddImageClick() async {
    final _imageFile = await picker.getImage(source: ImageSource.gallery);
    _file = File(_imageFile.path);

    setState(() {
      if (_file != null) {
        getFileImage();
      }
    });
  }

  void getFileImage() async {
    if (_file != null) {
      setState(() {
        ImageUploadModel imageUpload2 = new ImageUploadModel();
        imageUpload2.isUploaded = false;
        imageUpload2.uploading = false;
        imageUpload2.imageFile = _file;
        imageUpload2.imageUrl = '';
        _imageUpload = imageUpload2;
      });
    }
  }

  Widget _cancelBtn() {
    return TextButton(
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
    );
  }

  Widget _saveBtn() {
    return _isLoading
        ? Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
            child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(30, 215, 96, 1),
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(49, 232, 93, 1),
            ),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });

              _addOrganization(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Añadir'),
            ));
  }

  _addOrganization(context) async {
    if (_name.isEmpty ||
        _web.isEmpty ||
        _desc.isEmpty ||
        _imageUpload == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Es necesario llenar todos los campos')));
    } else {
      if (!_web.contains('http')) _web = 'http://' + _web;
      String imgRef = await _storage.uploadFile(_file, 'OrganizationsImages');
      DonationModel donation = DonationModel(
          name: _name, website: _web, description: _desc, img: imgRef);
      _db.addDonation(donation).then((value) {
        /*prefs.businessName = '';
              prefs.businessDescription = '';*/
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Se añadió la organización')));
      });
    }

    //print(_dir);
  }

  Widget _buttons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_cancelBtn(), _saveBtn()],
    );
  }
}
