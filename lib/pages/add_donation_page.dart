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
  Future<File> _imageFile;
  File imageFile;
  String imageRef;
  ImageUploadModel imgFile;
  Object image = 'Add Image';
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    setState(() {
      image = 'Add Image';
    });
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
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
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
        hintText: 'Website',
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
        maxLength: 50,
        maxLines: 4,
        controller: _descriptionController,
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
    return imgFile == null ? _addPhoto() : _removePhoto();
  }

  Widget _addPhoto() {
    return AddImageButton(
      onTap: _onAddImageClick,
    );
  }

  Widget _removePhoto() {
    return Container();
  }

  Future _onAddImageClick() async {
    final _imageFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(_imageFile.path);

    setState(() {
      if (imageFile != null) {
        getFileImage();
      }
    });
  }

  void getFileImage() async {
    if (imageFile != null) {
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = imageFile;
        imageUpload.imageUrl = '';
        /* _image = imageUpload;
      _imageSelected = true;*/
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
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(49, 232, 93, 1),
        ),
        onPressed: () async {
          // print(mapsUtil.locationtoString(_locations));
          if (_name.isEmpty || _web.isEmpty || _desc.isEmpty) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text('Es necesario llenar todos los campos')));
          } else {
            DonationModel donation = DonationModel(
                name: _name,
                website: _web,
                description: _desc,
                img:
                    'https://firebasestorage.googleapis.com/v0/b/millanes-frontend.appspot.com/o/logo_asset.png?alt=media&token=0bf4be90-8002-4821-8531-97c8bcf4e340');
            _db.addDonation(donation).then((value) {
              /*prefs.businessName = '';
              prefs.businessDescription = '';*/
              Navigator.popAndPushNamed(context, 'donationsPage');
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text('Se añadió la organización')));
            });
          }

          //print(_dir);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Añadir'),
        ));
  }

  Widget _buttons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_cancelBtn(), _saveBtn()],
    );
  }
}
