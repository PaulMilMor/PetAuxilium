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
import 'package:pet_auxilium/widgets/button_widget.dart';

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
  var _catController = TextEditingController();
  final StorageUtil _storage = StorageUtil();
  final MapsUtil mapsUtil = MapsUtil();
  Set<Marker> _markers = new Set<Marker>();
  String _selectedCategory;
  List listItems = ['ADOPCIÓN', 'ANIMAL PERDIDO', 'SITUACIÓN DE CALLE'];
  String _name;
  String _desc;

  List<LatLng> _locations;
  List<String> imagesRef = [];
  List<Object> images = [];
  Future<File> _imageFile;
  List<ImageUploadModel> _imgsFiles = [];
  File imagefile;
  List<File> _listImages = [];
  final picker = ImagePicker();

  void initState() {
    super.initState();
    setState(() {
      images.add("Add Image");
    });
    _name = prefs.adoptionName ?? ' ';
    _desc = prefs.adoptionDescription;
    _selectedCategory = 'ADOPCIÓN';
    _nameTxtController = TextEditingController(text: _name);
    _dirTxtController = TextEditingController();
    _descTxtController = TextEditingController(text: _desc);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _markers = ModalRoute.of(context).settings.arguments;
    _locations = mapsUtil.getLocations(_markers);
    print(ModalRoute.of(context).settings.name);
    getDir(_locations);
    print("mm");
    print(_locations);
    return Scaffold(
      body: SingleChildScrollView(child: _publicationForm(context)),
      backgroundColor: Colors.white,
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                images.length < 6
                    ? _onAddImageClick(index)
                    : _limitImages(context);
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
      print("La maldita imagen");
      print(_imageFile);
      if (_imageFile != null) {
        print("xd" + _imageFile.toString());
        if (images.length < 6) images.add("Add Image");
        getFileImage(index);
      } else {
        print("faros");
      }
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

  _limitImages(BuildContext context) {
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text('Solo se pueden insertar 5 imágenes a la vez')));
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    _imageFile.then((file) async {
      print(file);
      print(images.length);
      setState(() {
        if (file == null) {
          images.remove("Add Image");
        }
      });

      imagesRef.add(await _storage.uploadFile(file, 'PublicationImages'));

      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        imageUpload.imageUrl = '';
        // _imgsFiles.add(imageUpload);
        print("en el file");

        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }

  Widget _publicationForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18),
          /*Center(
            child: Text(
              'CREAR PUBLICACIÓN',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),*/
          _category(),
          if (_selectedCategory != "SITUACIÓN DE CALLE") _nameTxt(),
          _dirTxt(),
          _descTxt(),
          //_images(),
          buildGridView(),
          //_boton(),
          _buttons()
        ],
      ),
    );
  }

  Widget _category() {
    return Container(
      // height: 100.0,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Center(
          child: Column(children: [
        Container(
          margin: const EdgeInsets.only(right: 4.5),
          child: Text(
            'Categoría:',
            style: TextStyle(fontSize: 18),
          ),
        ),
        GrayDropdownButton(
          hint: Text("Selecciona una categoria"),
          value: _selectedCategory,
          onChanged: (newValue) {
            prefs.adoptionCategory = newValue;
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

        child: Column(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          child: Text(
            'Completa los siguientes campos',
            style: TextStyle(fontSize: 18),
          )),
      Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6), //width: 300.0,
          child: GrayTextFormField(
            controller: _nameTxtController,
            hintText: 'Nombre',
            suffixIcon: IconButton(
              onPressed: () {
                _nameTxtController.clear();
                prefs.adoptionName = '';
              },
              icon: Icon(Icons.clear),
            ),
            onChanged: (value) {
              setState(() {
                // _nameTxtController.clear();
                _name = value;
                prefs.adoptionName = value;
                print('NAME');
                print(_name);
              });
            },
          ))
    ]));
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
                      onPressed: () {
                        _descTxtController.clear();
                        prefs.adoptionDescription = '';
                      },
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
        ])));
  }

  Widget _dirTxt() {
    return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        child: Stack(
          children: [
            GrayTextFormField(
              controller: _dirTxtController,
              readOnly: true,
              hintText: 'Dirección',
              focusNode: AlwaysDisabledFocusNode(),
              /* suffixIcon: IconButton(
              onPressed: () => _dirTxtController.clear(),
              icon: Icon(Icons.clear),
            ),*/
              maxLines: null,
              onTap: () {
                Navigator.pushNamed(context, 'mapPublication',
                    arguments: _markers);
              },
            ),
            Positioned(
              right: 1,
              top: 5,
              child: IconButton(
                color: Colors.grey[600],
                onPressed: _cleanDir,
                icon: Icon(Icons.clear),
              ),
            ),
          ],
        ));
  }

  void _cleanDir() {
    _dirTxtController.clear();
    _markers.clear();
  }

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
      child: TextButton(
        child: Text('Cancelar', style: TextStyle(color: Colors.black)),
        onPressed: () {
          //Navigator.pop(context);
          //_name = null;
          //_desc = null;
          _nameTxtController.clear();
          _descTxtController.clear();
          _dirTxtController.clear();
        },
      ),
    );
  }

  Widget _saveBtn() {
    return Container(
      margin: const EdgeInsets.only(right: 12.0, bottom: 50),
      child: ElevatedButton(
          onPressed: () {
            if (_selectedCategory == 'SITUACIÓN DE CALLE') {
              _name = 'Animal Callejero';
              prefs.adoptionName = 'Animal Callejero';
            }
            if (_name.isEmpty ||
                _desc.isEmpty ||
                imagesRef.isEmpty ||
                _locations.isEmpty) {
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text('Es necesario llenar todos los campos')));
            } else {
              print(_imgsFiles.toString());
              //print(mapsUtil.locationtoString(_locations));
              PublicationModel ad = PublicationModel(
                  category: _selectedCategory,
                  name: _name,
                  location: mapsUtil.locationtoString(_locations),
                  userID: prefs.userID,
                  description: _desc,
                  imgRef: imagesRef);
              _db.addPublication(ad).then((value) {
                prefs.adoptionCategory = 'ADOPCIÓN';
                prefs.adoptionDescription = '';
                prefs.adoptionName = '';
                Navigator.popAndPushNamed(context, 'navigation');
              });
              print(_name);
            }
          },
          child: Text('Publicar')),
    );
  }

  void getDir(List<LatLng> locations) {
    print(locations);
    if (locations != null) {
      locations.forEach((LatLng element) async {
        String place = "";
        List<Placemark> placemarks =
            await placemarkFromCoordinates(element.latitude, element.longitude);
        place =
            placemarks.first.street + " " + placemarks.first.locality + "\n";

        setState(() {
          print(place);
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
