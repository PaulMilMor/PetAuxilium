import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/models/ImageUploadModel.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/storage_util.dart';

import 'package:pet_auxilium/widgets/button_widget.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';

import 'package:image_picker/image_picker.dart';
import 'package:pet_auxilium/models/ImageUploadModel.dart';

class CreateBusinessPage extends StatefulWidget {
  @override
  _CreateBusinessPageState createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
  TextEditingController _nameTxtController;
  TextEditingController _dirTxtController;
  TextEditingController _descTxtController;
  final prefs = new preferencesUtil();
  Set<Marker> _markers = new Set<Marker>();
  final _db = dbUtil();
  final StorageUtil _storage = StorageUtil();
  String _name = " ";
  String _desc;
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
      /*images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");*/
    });
//FIXME: cambiar esto en proximos sprints para que esta info la obtenga de Firebase
    _name = prefs.businessName ?? ' ';
    _desc = prefs.businessDescription;
    _nameTxtController = TextEditingController(text: _name);
    _dirTxtController = TextEditingController();
    _descTxtController = TextEditingController(text: _desc);
  }

  @override
  Widget build(BuildContext context) {
    _markers = ModalRoute.of(context).settings.arguments;
    _locations = mapsUtil.getLocations(_markers);
    getDir(_locations);
    //  _dir=mapsUtil.getDir(_locations);
    return Scaffold(
      body: SingleChildScrollView(child: _businessForm(context)),
    );
  }

  Widget _businessForm(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
              child: Text(
                'PUBLICAR NEGOCIO',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // _selectService(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              child: Text('Completa los siguientes campos'),
            ),
            _nameTxt(),
            _dirTxt(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              //child: Text('Describa los servicios que ofrece'),
            ),
            _descriptionTxt(),
            _buildGridView(),
            _buttons()
          ],
        ),
      ),
    );
  }

  Widget _nameTxt() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: GrayTextFormField(
          controller: _nameTxtController,
          hintText: 'Nombre',
          onChanged: (value) {
            setState(() {
              prefs.businessName = value;
              _name = value;
            });
          }),

      /*TextField(
      controller: _nameTxtController,
      hintText: 'Nombre',
      onChanged: (value) {
        setState(() {
          prefs.businessName = value;
          _name = value;
        });
      },
    )*/
    );
  }

  Widget _dirTxt() {
    return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        child: GrayTextFormField(
            controller: _dirTxtController,
            hintText: 'Direccion',
            //Esto es para que no se pueda editar manualmente el texta de la ubicación
            focusNode: AlwaysDisabledFocusNode(),
            onTap: () {
              Navigator.pushNamed(context, 'map', arguments: _markers);
            })
        /*TextField(
      controller: _dirTxtController,
    hintText: 'Direccion',
      onTap: () {
        Navigator.pushNamed(context, 'map', arguments: _markers);
      },
    )*/
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
        maxLines: 6,
        controller: _descTxtController,
        decoration: InputDecoration(
            hintText: "Describa los servicios que ofrece",
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
    return Container(
      child: TextButton(
        child: Text('Cancelar', style: TextStyle(color: Colors.black)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

// ignore: todo
//TODO: cambiar el userID por el que este usando el usuario
  Widget _saveBtn() {
    return Container(
      child: RaisedButton(
          onPressed: () async {
            // print(mapsUtil.locationtoString(_locations));
            if (_name.isEmpty || _locations.isEmpty || _desc.isEmpty) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text('Es necesario llenar todos los campos')));
            } else {
              BusinessModel business = BusinessModel(
                  name: _name,
                  location: mapsUtil.locationtoString(_locations),
                  userID: prefs.userID,
                  description: _desc,
                  imgRef: imagesRef);
              _db.addBusiness(business).then((value) {
                prefs.businessName = '';
                prefs.businessDescription = '';
                Navigator.popAndPushNamed(context, 'navigation');
              });
            }

            //print(_dir);
          },
          child: Text('Publicar')),
    );
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
    return AddImageButton(onTap: () {
      images.length < 6 ? _onAddImageClick(index) : _limitImages(context);
    });
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      //FIXME: cambiar .pickimage a -getimage para evitar errores futuros
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      if (_imageFile != null) {
        getFileImage(index);
        print("xd" + _imageFile.toString());
      } else {
        print("faros");
      }
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

  Widget _selectService() {
    return Row(
      children: [
        //Text('Servicios que ofrece:'),
        /*DropdownButton(
          isExpanded: true,
          items: [
            DropdownMenuItem(child: Text('Veterinaria')),
            DropdownMenuItem(child: Text('???')),
            DropdownMenuItem(child: Text('Tráfico de personas')),
          ],
        ),*/
      ],
    );
  }

//FIXME: optimizar este sector
  void getDir(List<LatLng> locations) {
    if (locations != null) {
      locations.forEach((LatLng element) async {
        String place = "";
        List<Placemark> placemarks =
            await placemarkFromCoordinates(element.latitude, element.longitude);
        place =
            placemarks.first.street + " " + placemarks.first.locality + "\n";
        setState(() {
          _dirTxtController.text = place;
        });
      });
    }
  }
}

//Aquí se crea la clase AlwaysDisabledFocusNode para que no se pueda editar el campo de la dirección
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
