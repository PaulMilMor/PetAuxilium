import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
  File imageFile;

  List<String> _dir;
  List<String> imagesRef = [];
  List<ImageUploadModel> _imgsFiles = [];

  List<LatLng> _locations;
  List<Object> images = [];
  List<String> _selectedServices = [];
  List listItems = [
    'CUIDADOS ESPECIALES',
    'ESTÉTICA',
    'GUARDERÍA / HOTEL ANIMAL',
    'LIMPIEZA / ASEO',
    'VETERINARIA',
    'VENTAS'
  ];
  final picker = ImagePicker();
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
        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                'PUBLICAR NEGOCIO',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            _selectService(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Text('Completa los siguientes campos',
                  style: TextStyle(fontSize: 18)),
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
        maxLength: 20,
        textCapitalization: TextCapitalization.words,
        onChanged: (value) {
          setState(() {
            prefs.businessName = value;
            _name = value;
          });
        },
        suffixIcon: IconButton(
          onPressed: () {
            _nameTxtController.clear();
            prefs.businessName = '';
            _name = '';
          },
          icon: Icon(Icons.clear),
        ),
      ),

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
        child: Stack(
          children: [
            GrayTextFormField(
                controller: _dirTxtController,
                hintText: 'Direccion',
                //Esto es para que no se pueda editar manualmente el texta de la ubicación
                focusNode: AlwaysDisabledFocusNode(),
                maxLines: null,
                onTap: () {
                  Navigator.pushNamed(context, 'map', arguments: _markers);
                }),
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
        )
        /*TextField(
      controller: _dirTxtController,
    hintText: 'Direccion',
      onTap: () {
        Navigator.pushNamed(context, 'map', arguments: _markers);
      },
    )*/
        );
  }

  void _cleanDir() {
    _dirTxtController.clear();
    _markers.clear();
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
            labelText: 'Describa los servicios que ofrece',
            labelStyle: TextStyle(
              color: Colors.grey,
              // color: Color.fromRGBO(49, 232, 93, 1),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            suffixIcon: IconButton(
              onPressed: () {
                _descTxtController.clear();
                prefs.businessDescription = '';
                _desc = '';
              },
              icon: Icon(Icons.clear),
            )),
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

// ignore: todo
//TODO: cambiar el userID por el que este usando el usuario
  Widget _saveBtn() {
    return Container(
      child: ElevatedButton(
          onPressed: () async {
            // print(mapsUtil.locationtoString(_locations));
            if (_name.isEmpty ||
                _locations.isEmpty ||
                _desc.isEmpty ||
                _selectedServices.isEmpty) {
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
                  imgRef: imagesRef,
                  services: _selectedServices);
              _db.addBusiness(business).then((value) {
                prefs.businessName = '';
                prefs.businessDescription = '';
                Navigator.popAndPushNamed(context, 'navigation');
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Se ha publicado tu negocio.')),
                  );
              });
            }

            //print(_dir);
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(49, 232, 93, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Publicar'),
          )),
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
    //FIXME: cambiar .pickimage a -getimage para evitar errores futuros
    final _imageFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(_imageFile.path);

    setState(() {
      if (imageFile != null) {
        if (images.length < 6) images.add("Add Image");
        getFileImage(index);

        print("xd" + imageFile.toString());
      } else {
        print("faros");
      }
      //if (images.length < 6) images.add("Add Image");
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

      setState(() {
        if (imageFile == null) {
          images.remove("Add Image");
        }
      });
      imagesRef.add(await _storage.uploadFile(imageFile, 'BusinessImages'));

      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = imageFile;
        imageUpload.imageUrl = '';
        images.replaceRange(index, index + 1, [imageUpload]);
      });
  }

  Widget _selectService() {
    return Container(
      // height: 100.0,
      margin: const EdgeInsets.fromLTRB(8, 24, 8, 18),
      child: MultiSelectBottomSheetField<String>(
        //key: _multiSelectKey,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        cancelText: Text(
          'CANCELAR',
          style: TextStyle(color: Color.fromRGBO(49, 232, 93, 1)),
        ),
        confirmText: Text(
          'OK',
          style: TextStyle(color: Color.fromRGBO(49, 232, 93, 1)),
        ),
        selectedColor: Color.fromRGBO(49, 232, 93, 1),
        decoration: BoxDecoration(
          color: Color.fromRGBO(235, 235, 235, 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Color.fromRGBO(235, 235, 235, 1),
            width: 6,
          ),
        ),
        title: Text(
          'Servicios',
          style: TextStyle(
            //color: Color.fromRGBO(202, 202, 202, 1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonText: Text(
          "Servicios que ofrece",
          style: TextStyle(
            //color: Color.fromRGBO(202, 202, 202, 1),
            fontSize: 16,
          ),
        ),
        buttonIcon: Icon(
          Icons.arrow_drop_down, color: Colors.grey[800],
          //color: Colors.blue,
        ),
        items: listItems
            .map((item) => MultiSelectItem<String>(item, item))
            .toList(),
        searchable: false,

        onConfirm: (values) {
          setState(() {
            _selectedServices = values;
          });
          // _multiSelectKey.currentState.validate();
        },
        chipDisplay: MultiSelectChipDisplay.none(),
      ),
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
