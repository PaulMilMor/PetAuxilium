import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pet_auxilium/blocs/editbusiness/editbusiness_bloc.dart';

import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/models/ImageUploadModel.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/storage_util.dart';

import 'package:pet_auxilium/widgets/button_widget.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';

class EditBusinessPage extends StatefulWidget {
  PublicationModel detailDocument;
  EditBusinessPage(this.detailDocument);
  @override
  _EditBusinessPageState createState() => _EditBusinessPageState();
}

class _EditBusinessPageState extends State<EditBusinessPage> {
  TextEditingController _nameTxtController;
  var _dirTxtController = TextEditingController();
  TextEditingController _descTxtController;
  final prefs = new preferencesUtil();
  Set<Marker> _markers = new Set<Marker>();
  final _db = dbUtil();
  final StorageUtil _storage = StorageUtil();
  EditbusinessBloc editbusinessBloc = EditbusinessBloc();

  String _name = " ";
  String _desc;
  File imageFile;
  var _location;
  List imagesRef = [];
  final picker = ImagePicker();
  List<LatLng> _locations = [];
  List<Object> images = [];
  List _selectedServices = [];
  List listItems = [
    'CUIDADOS ESPECIALES',
    'ESTÉTICA',
    'GUARDERÍA / HOTEL ANIMAL',
    'LIMPIEZA / ASEO',
    'VETERINARIA',
    'VENTAS'
  ];
  final MapsUtil mapsUtil = MapsUtil();
  @override
  void initState() {
    super.initState();

//FIXME: cambiar esto en proximos sprints para que esta info la obtenga de Firebase
    _selectedServices = widget.detailDocument.services;
    _name = widget.detailDocument.name;
    _desc = widget.detailDocument.description;
    _location = widget.detailDocument.location.first;
    List<String> latLng = _location.split(",");
    double latitude = double.parse(latLng[0]);
    double longitude = double.parse(latLng[1]);
    LatLng temp = LatLng(latitude, longitude);
    _locations.add(temp);
    images = widget.detailDocument.imgRef;
    imagesRef = widget.detailDocument.imgRef;

    setState(() {
      images.remove("Add Image");
      images.add("Add Image");
    });

    _nameTxtController = TextEditingController(text: _name);
    getDir(_locations);
    _descTxtController = TextEditingController(text: _desc);
  }

  @override
  Widget build(BuildContext context) {
    editbusinessBloc = BlocProvider.of<EditbusinessBloc>(context);
    return Scaffold(
      /*appBar: AppBar(
        title: Text('EDITAR NEGOCIO'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(49, 232, 93, 1),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),*/
      body: _body(context),
    );
    //  _dir=mapsUtil.getDir(_locations);
  }

  Widget _body(BuildContext context) {
    _markers = ModalRoute.of(context).settings.arguments;
    if (_locations == null) {
      _locations = mapsUtil.getLocations(_markers);
      getDir(_locations);
    }
    return Scaffold(
      body:
          SafeArea(child: SingleChildScrollView(child: _businessForm(context))),
      backgroundColor: Colors.white,
    );
  }

  Widget _businessForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15),
      child: BlocBuilder<EditbusinessBloc, EditbusinessState>(
        builder: (context, state) {
          _locations = getLocations();
          getDir(_locations);
          //images = state.imgRef ?? this.images;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              'EDITAR NEGOCIO',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),*/
              SizedBox(height: 15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Text(
                  'EDITAR NEGOCIO',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              _selectService(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Text('Completa los siguientes campos',
                    style: TextStyle(fontSize: 16)),
              ),
              _nameTxt(state),
              _dirTxt(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 9, 12, 0),
                //child: Text('Describa los servicios que ofrece'),
              ),
              _descriptionTxt(state),
              _buildGridView(),
              _buttons(state)
            ],
          );
        },
      ),
    );
  }
  List<LatLng> getLocations()  {
   List<LatLng> locations=[];
      widget.detailDocument.location.forEach((element) {
        String location = element.toString();
      locations.add(LatLng(
              double.parse(location.substring(0, location.indexOf(',')).trim()),
              double.parse( location.substring(location.indexOf(',') + 1).trim())));
      });
   return locations;
  }

  Widget _nameTxt(state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(1, 1, 31, 7),
      child: GrayTextFormField(
        controller: _nameTxtController,
        hintText: 'Nombre',
        maxLength: 20,
        textCapitalization: TextCapitalization.words,
        onChanged: (value) {
          editbusinessBloc.add(UpdateName(value));
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
    );
  }

  Widget _dirTxt() {
    return Container(
        padding: const EdgeInsets.fromLTRB(1, 0, 31, 1),
        child: Stack(
          children: [
            GrayTextFormField(
                controller: _dirTxtController,
                readOnly: true,
                hintText: 'Dirección',
                //Esto es para que no se pueda editar manualmente el texta de la ubicación
                focusNode: AlwaysDisabledFocusNode(),
                maxLines: null,
                onTap: () {
                  //Navigator.pushNamed(context, 'map', arguments: _markers);
                  prefs.previousPage = 'publication';
                  Navigator.pushNamed(context, 'map',
                      arguments: editbusinessBloc);
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
    editbusinessBloc.add(EditUpdateLocations(Set<Marker>()));
    _dirTxtController.clear();
    _markers.clear();
  }

  Widget _buttons(state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_cancelBtn(), _saveBtn(state)],
    );
  }

  Widget _descriptionTxt(state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 1, 12, 1),
      child: Container(
        height: 120,
        child: TextField(
          maxLength: 400,
          maxLines: 3,
          controller: _descTxtController,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              labelText: 'Describa los servicios que ofrece',
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 15,
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
            editbusinessBloc.add(UpdateDesc(value));
          },
        ),
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
          editbusinessBloc.add(CleanData());
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
  Widget _saveBtn(state) {
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
                    behavior: SnackBarBehavior.floating,
                    content: Text('Es necesario llenar todos los campos')));
            } else {
              imagesRef.remove('Add Image');
              BusinessModel business = BusinessModel(
                  id: widget.detailDocument.id,
                  name: _nameTxtController.text,
                  location: mapsUtil.locationtoString(_locations),
                  userID: prefs.userID,
                  description: _descTxtController.text,
                  imgRef: imagesRef,
                  services: _selectedServices);
              _db.addBusiness(business).then((value) {
                editbusinessBloc.add(CleanData());
                /*prefs.businessName = '';
                prefs.businessDescription = '';*/
                _dirTxtController.clear();
                Navigator.popAndPushNamed(context, 'navigation');
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('Haz editado tu negocio.')),
                  );
                      if (prefs.patreonUser) {
                    Navigator.popAndPushNamed(context, 'navigation');
                  } else {
                    Navigator.pushNamed(context, 'paidOptionsPage');
                  }
              });
            }

            //print(_dir);
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(30, 215, 96, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Guardar cambios'),
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
                        //images.removeAt(index);
                        // images.replaceRange(index, index + 1, ['Add Image']);
                        imagesRef.removeAt(index);
                        //         images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (images[index] != "Add Image") {
          print(images.length);
          print(images);
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image(
                    image: NetworkImage(images[index].toString()),
                    width: 300,
                    height: 300),
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
                        //images.add("Add Image");
                        //images.removeAt(index);
                        imagesRef.removeAt(index);
                        // images.replaceRange(index, index + 1, ['Add Image']);
                        //_imgsFiles.removeAt(index);
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
          behavior: SnackBarBehavior.floating,
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
    //imagesRef.removeLast();

    setState(() {
      ImageUploadModel imageUpload = new ImageUploadModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = imageFile;
      imageUpload.imageUrl = '';
      images.replaceRange(index, index + 1, [imageUpload]);
      imagesRef.remove(imageUpload);
      imagesRef.remove("Add Image");
      images.add("Add Image");
      editbusinessBloc.add(UpdateImgs(images));
    });
  }

  Widget _selectService() {
    return Container(
      // height: 100.0,
      margin: const EdgeInsets.fromLTRB(1, 24, 8, 18),
      child: MultiSelectBottomSheetField<String>(
        initialValue: this
            .widget
            .detailDocument
            .services
            .map((item) => item.toString())
            .toList(),
        //key: _multiSelectKey,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        cancelText: Text(
          'CANCELAR',
          style: TextStyle(color: Colors.black),
        ),
        confirmText: Text(
          'ACEPTAR',
          style: TextStyle(color: Colors.black),
        ),
        selectedColor: Color.fromRGBO(30, 215, 96, 1),
        decoration: BoxDecoration(
          color: Color.fromRGBO(235, 235, 235, 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Color.fromRGBO(235, 235, 235, 1),
            width: 6,
          ),
        ),
        title: Text(
          'Seleccionar servicios',
          style: TextStyle(
            //color: Color.fromRGBO(202, 202, 202, 1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonText: Text(
          "Servicios que ofrece el negocio",
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
