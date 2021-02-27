import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_auxilium/models/ImageUploadModel.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/storage_util.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';

class PublicationPage extends StatefulWidget {
  @override
  PublicationPageState createState() => PublicationPageState();
}

class PublicationPageState extends State<PublicationPage> {
  final _db = dbUtil();
  final auth = AuthUtil();
  final prefs = new preferencesUtil();
  var _nameTxtController = TextEditingController();
  //TextEditingController _nameTxtController;
  var _dirTxtController = TextEditingController();
  var _descTxtController = TextEditingController();
  final StorageUtil _storage = StorageUtil();
  final MapsUtil mapsUtil = MapsUtil();
  Set<Marker> _markers = new Set<Marker>();
  String _selectedCategory;
  List listItems = ['Adopción', 'Animales perdidos', 'Situacion de calle'];
  String _name;
  String _desc;
  List<String> _dir;
  List<LatLng> _locations;
  List<String> imagesRef = List<String>();
  List<Object> images = List<Object>();
  Future<File> _imageFile;
  List<ImageUploadModel> _imgsFiles = List<ImageUploadModel>();
  File imagefile;
  List<File> _listImages = [];
  final picker = ImagePicker();

  void initState() {
    super.initState();
    setState(() {
      images.add("Add Image");
      /*images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");*/
    });
    //_name = prefs.adoptionName ?? ' ';
    //_desc = prefs.adoptionDescription;
    _nameTxtController = TextEditingController(text: _name);
    _dirTxtController = TextEditingController();
    _descTxtController = TextEditingController(text: _desc);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _markers = ModalRoute.of(context).settings.arguments;
    _locations = mapsUtil.getLocations(_markers);

    getDir(_locations);
    return Scaffold(
      body: SingleChildScrollView(child: _publicationForm(context)),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 48, right: 48),
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          print(uploadModel.imageUrl);
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
          return Card(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                //_showChoiceDialog(context);
                images.length < 6
                    ? _onAddImageClick(index)
                    : _limitImages(context);
              },
            ),
          );
        }
      }),
    );
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
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text('Solo se pueden insertar 5 imágenes a la vez')));
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    _imageFile.then((file) async {
      imagesRef.add(await _storage.uploadFile(file, 'PublicationImages'));

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

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imagefile = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  _openGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    setState(() {
      print("chingadamadre");
      print(picture);

      imagefile = picture;
      print(imagefile);
    });
  }

  _openCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    Navigator.of(context).pop();
    setState(() {
      print(picture);
      imagefile = picture;
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Selecciona una opción"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      print("ostia puta");
                      print(context);
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                      child: Text("Cámara"),
                      onTap: () {
                        _openCamera(context);
                      })
                ],
              ),
            ),
          );
        });
  }

  void _addImages() {
    setState(() {
      _listImages.add(imagefile);
    });
  }

  Widget _publicationForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18),
        Center(
          child: Text(
            'CREAR PUBLICACIÓN',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        _category(),
        if (_selectedCategory != "Situacion de calle") _nameTxt(),
        _dirTxt(),
        _descTxt(),
        //_images(),
        buildGridView(),
        //_boton(),
        _buttons()
      ],
    );
  }

  Widget _category() {
    return Container(
      // height: 100.0,
      margin: const EdgeInsets.only(left: 40.0, top: 10),
      child: Center(
          child: Row(children: [
        Container(
          margin: const EdgeInsets.only(right: 30.0),
          child: Text(
            'Categoría:',
            style: TextStyle(fontSize: 18),
          ),
        ),
        DropdownButton(
          hint: Text("Selecciona una categoria"),
          value: _selectedCategory,
          onChanged: (newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
          items: listItems.map((valueItem) {
            return DropdownMenuItem(
              value: valueItem,
              child: Text(valueItem),
            );
          }).toList(),
        )
      ])),
    );
  }

  Widget _nameTxt() {
    return Container(
        //height: 100.0,
        child: Center(
      child: Column(children: [
        Text(
          'Completa los siguientes campos',
          style: TextStyle(fontSize: 18),
        ),
        Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            width: 300.0,
            child: GrayTextFormField(
              controller: _nameTxtController,
              hintText: 'Nombre',
              suffixIcon: IconButton(
                onPressed: () => _nameTxtController.clear(),
                icon: Icon(Icons.clear),
              ),
              onChanged: (value) {
                setState(() {
                  prefs.adoptionName = value;
                  _name = value;
                });
              },
            )),
      ]),
    ));
  }

  Widget _descTxt() {
    return Container(
        height: 100.0,
        child: Center(
          child: Column(children: [
            Container(
                width: 300.0,
                child: TextField(
                  controller: _descTxtController,
                  decoration: InputDecoration(
                      labelText: 'Descripción',
                      suffixIcon: IconButton(
                        onPressed: () => _descTxtController.clear(),
                        icon: Icon(Icons.clear),
                      )),
                  maxLength: 500,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    setState(() {
                      prefs.adoptionDescription = value;
                      _desc = value;
                    });
                  },
                )),
          ]),
        ));
  }

  Widget _dirTxt() {
    return Container(
        width: 300.0,
        margin: const EdgeInsets.only(left: 55.0, bottom: 20),
        child: Center(
            child: GrayTextFormField(
          controller: _dirTxtController,
          readOnly: true,
          hintText: 'Dirección',
          suffixIcon: IconButton(
            onPressed: () => _dirTxtController.clear(),
            icon: Icon(Icons.clear),
          ),
          maxLines: null,
          onTap: () {
            Navigator.pushNamed(context, 'mapPublication', arguments: _markers);
          },
        )));
  }

  Widget _boton() {
    return Container(
      width: 300.0,
      margin: const EdgeInsets.only(left: 40, top: 20),
      child: RaisedButton(
        onPressed: () {
          _showChoiceDialog(context);
        },
        child: Text("+"),
      ),
    );
  }

  /*Widget _images() {
    return Container(
        width: 300.0,
        margin: const EdgeInsets.only(left: 40, top: 20),
        child: Row(
          children: renderImages(),

          //mainAxisAlignment: MainAxisAligment.spaceAround,

          /*child: RaisedButton(
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: Text("+"),
              ),*/
        ));
  }*/

  Widget _buttons() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_CancelBtn(), _saveBtn()],
      ),
    );
  }

  Widget _CancelBtn() {
    return Container(
      margin: const EdgeInsets.only(right: 30.0, bottom: 50),
      child: RaisedButton(onPressed: () async {}, child: Text('Cancelar')),
    );
  }

  Widget _saveBtn() {
    return Container(
      margin: const EdgeInsets.only(right: 40.0, bottom: 50),
      child: RaisedButton(
          onPressed: () async {
            print(_imgsFiles.toString());
            //print(mapsUtil.locationtoString(_locations));
            PublicationModel ad = PublicationModel(
                category: _selectedCategory,
                name: _name,
                location: mapsUtil.locationtoString(_locations),
                userID: '1441414',
                description: _desc,
                imgRef: imagesRef);
            _db.addPublication(ad);
            print(_name);
          },
          child: Text('Publicar')),
    );
  }

  void getDir(List<LatLng> locations) {
    if (locations != null) {
      locations.forEach((LatLng element) async {
        String place = "";
        List<Placemark> placemarks =
            await placemarkFromCoordinates(element.latitude, element.longitude);
        placemarks.forEach((Placemark element) {
          place = place +
              "\n" +
              element.street +
              " " +
              element.subLocality +
              ", " +
              element.locality;
        });
        setState(() {
          _dirTxtController.text = place;
        });
      });
    }
  }
}
