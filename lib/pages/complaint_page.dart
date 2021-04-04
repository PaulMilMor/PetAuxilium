import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pet_auxilium/models/complaint_model.dart';
import 'package:pet_auxilium/models/ImageUploadModel.dart';
import 'package:pet_auxilium/pages/create_business_page.dart';

import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/storage_util.dart';
import 'package:pet_auxilium/widgets/button_widget.dart';

import 'package:pet_auxilium/widgets/textfield_widget.dart';

class ComplaintPage extends StatefulWidget {
  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  TextEditingController _titleTxtController;
  TextEditingController _dirTxtController;
  TextEditingController _descTxtController;
  final prefs = new preferencesUtil();
  Set<Marker> _markers = new Set<Marker>();
  final _db = dbUtil();
  final StorageUtil _storage = StorageUtil();
  String _title = "";
  String _desc = "";
  String _direct = "";
  Future<File> _imageFile;
  List<String> _dir;
  List<String> imagesRef = [];
  List<ImageUploadModel> _imgsFiles = [];
  List<LatLng> _locations;
  List<Object> images = [];
  final MapsUtil mapsUtil = MapsUtil();

  @override
  void initState() {
    super.initState();
    setState(() {
      images.add("Add Image");
    });
    _titleTxtController = TextEditingController(text: _title);
    _dirTxtController = TextEditingController();
    _descTxtController = TextEditingController(text: _desc);
  }

  @override
  Widget build(BuildContext context) {
    _markers = ModalRoute.of(context).settings.arguments;
    _locations = mapsUtil.getLocations(_markers);
    return Scaffold(
      body: SingleChildScrollView(child: _complaintForm(context)),
    );
  }

  Widget _complaintForm(BuildContext context) {
    return SafeArea(
      child: Padding(
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
                'denunciar',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Text(
                'Completa los siguientes campos',
                style: TextStyle(fontSize: 18),
              ),
            ),
            _titleTxt(),
            _dirTxt(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            _descriptionTxt(),
            _buildGridView(),
            _buttons(),
          ],
        ),
      ),
    );
  }

  Widget _titleTxt() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
          controller: _titleTxtController,
          hintText: 'Título',
          onChanged: (value) {
            setState(() {
              //prefs.businessName = value;
              _title = value;
            });
          }),
    );
  }

  Widget _dirTxt() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
          controller: _dirTxtController,
          hintText: 'Ubicación',
          onChanged: (value) {
            setState(() {
              //prefs.businessName = value;
              _direct = value;
            });
          }),
    );
  }

  Widget _buttons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_cancelBtn(), _saveBtn()],
    );
  }

  Widget _descriptionTxt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: TextField(
        maxLength: 500,
        maxLines: 4,
        controller: _descTxtController,
        decoration: InputDecoration(
            labelText: "Describa su denuncia",
            labelStyle: TextStyle(
              color: Colors.grey,
              // color: Color.fromRGBO(49, 232, 93, 1),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
        onChanged: (value) {
          setState(() {
            prefs.businessDescription = value;
            _desc = value;
          });
        },
      ),
    );
  }

  Widget _cancelBtn() {
    return TextButton(
      child: Text('Cancelar', style: TextStyle(color: Colors.black)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _saveBtn() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(49, 232, 93, 1),
        ),
        onPressed: () async {
          // print(mapsUtil.locationtoString(_locations));
          if (_title.isEmpty || _direct.isEmpty || _desc.isEmpty) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text('Es necesario llenar todos los campos')));
          } else {
            ComplaintModel complaint = ComplaintModel(
                title: _title,
                location: [_direct],
                //location: mapsUtil.locationtoString(_locations),
                userID: prefs.userID,
                description: _desc,
                imgRef: imagesRef);
            _db.addComplaint(complaint).then((value) {
              /*prefs.businessName = '';
              prefs.businessDescription = '';*/
              Navigator.popAndPushNamed(context, 'navigation');
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text('listo krnal ya se guardó 👍')));
            });
          }

          //print(_dir);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Publicar'),
        ));
  }

  Widget _buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.removeAt(index);
                        // images.replaceRange(index, index + 1, ['Add Image']);
                        _imgsFiles.remove(index);
                        //         images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: _addBtn(index),
          );
        }
      }),
    );
  }

  Widget _addBtn(int index) {
    return AddImageButton(
      onTap: () {
        images.length < 6 ? _onAddImageClick(index) : _limitImages(context);
      },
    );
    /*return FlatButton(
      onPressed: () {
        images.length < 6 ? _onAddImageClick(index) : _limitImages(context);
      },
      color: Colors.grey[200],
      height: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 48,
            color: Color.fromRGBO(210, 210, 210, 1),
          ),
        ],
      ),
    );*/
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      //FIXME: cambiar .pickimage a -getimage para evitar errores futuros
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      if (_imageFile != null) {
        getFileImage(index);
      } else {}
      if (images.length < 6) images.add("Add Image");
    });
  }

  _limitImages(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text('Solo se pueden insertar 5 imágenes a la vez')));
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    _imageFile.then((file) async {
      imagesRef.add(await _storage.uploadFile(file, 'BusinessImages'));

      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        imageUpload.imageUrl = '';
        // _imgsFiles.add(imageUpload);
        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }
}
