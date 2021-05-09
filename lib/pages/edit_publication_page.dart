import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_auxilium/blocs/editpublication/editpublication_bloc.dart';
import 'package:pet_auxilium/models/ImageUploadModel.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/storage_util.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';
import 'package:pet_auxilium/widgets/button_widget.dart';

class EditPublicationPage extends StatefulWidget {
  PublicationModel detailDocument;
  EditPublicationPage(this.detailDocument);
  @override
  EditPublicationPageState createState() => EditPublicationPageState();
}

class EditPublicationPageState extends State<EditPublicationPage> {
  final _db = dbUtil();
  final auth = AuthUtil();

  EditpublicationBloc editpublicationBloc = EditpublicationBloc();

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
  var _location;
  List<LatLng> _locations = [];
  //List <String>_location;
  List imagesRef = [];
  List<Object> images = [];
  List<ImageUploadModel> _imgsFiles = [];
  File imagefile;
  final picker = ImagePicker();
  PublicationModel publication;

  void initState() {
    super.initState();

    _selectedCategory = widget.detailDocument.category;
    _name = widget.detailDocument.name;
    _desc = widget.detailDocument.description;
    _location = widget.detailDocument.location.first;
    List<String> latLng = _location.split(",");
    double latitude = double.parse(latLng[0]);
    double longitude = double.parse(latLng[1]);
    print(latitude);
    print(longitude);
    LatLng temp = LatLng(latitude, longitude);
    print(temp);
    _locations.add(temp); //= [latitude,longitude];
    images = widget.detailDocument.imgRef;
    imagesRef = widget.detailDocument.imgRef;
    print('POOOOOOOOOOOOOOOL ImGREG1');
    print(imagesRef);
    print(widget.detailDocument.imgRef);
    print(widget.detailDocument.id);
    setState(() {
      images.remove("Add Image");
      //images.clear();
      print('NOTPOOOOOOOOOOL4');
      print(imagesRef);
      images.add("Add Image");
      print('NOTPOOOOOOOOOOL3');
      print(imagesRef);
    });
    _nameTxtController = TextEditingController(text: _name);
    getDir(_locations);
    //_dirTxtController = TextEditingController(text: _location);
    _descTxtController = TextEditingController(text: _desc);
    print('NOTPOOOOOOOOOOL');
    print(images);
    print('NOTPOOOOOOOOOOL2');
    print(imagesRef);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    editpublicationBloc = BlocProvider.of<EditpublicationBloc>(context);

    return Scaffold(
      /* appBar: AppBar(
        title: Text('EDITAR PUBLICACIÓN'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(30, 215, 96, 1),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),*/
      body: _body(context),
      backgroundColor: Colors.white,
    );
  }

  Widget _body(BuildContext context) {
    _markers = ModalRoute.of(context).settings.arguments;
    if (_locations == null) {
      _locations = mapsUtil.getLocations(_markers);
      getDir(_locations);
    }

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(child: _publicationForm(context))),
      backgroundColor: Colors.white,
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(11, 0, 12, 6),
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          print(images.length);
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
                        imagesRef.removeAt(index);
                        print('POOOOOOOOOOOOOOOL ImGREG2');
                        print(imagesRef);
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
        } else if (images[index] != "Add Image") {
          //ImageUploadModel uploadModel = images[index];
          print("tuperra madre");
          print(images.length);
          //images.add("Add Image");

          print(images);
          print('POOOOOOOOOOOOOOOL ImGREG3');
          print(imagesRef);
          //imagesRef.add(images[index].toString());
          //imagesRef.remove("Add Image");
          //images.add("Add Image");
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
                        images.removeAt(index);
                        imagesRef.removeAt(index);
                        print('POOOOOOOOOOOOOOOL ImGREG4');
                        print(imagesRef);
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
        }
        //else {
        print(images.length);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AddImageButton(onTap: () {
            images.length < 6 ? _onAddImageClick(index) : _limitImages(context);
          }),
        );
      }
          /*}*/),
    );
  }

  Future _onAddImageClick(int index) async {
    //FIXME: cambiar .pickimage a -getimage para evitar errores futuros
    final _imageFile = await picker.getImage(source: ImageSource.gallery);
    imagefile = File(_imageFile.path);
    setState(() {
      if (_imageFile != null) {
        print("xd" + _imageFile.toString());
        if (images.length < 6) images.add("Add Image");
        getFileImage(index);
      } else {
        print("faros");
      }
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
    print(imagefile);
    print(images.length);
    setState(() {
      if (imagefile == null) {
        images.remove("Add Image");
      }
    });

    imagesRef.add(await _storage.uploadFile(imagefile, 'PublicationImages'));

    print('POOOOOOOOOOOOOOOL ImGREG5');
    print(imagesRef);
    print("chingado");
    print(imagesRef.length);
    print(imagesRef);
    setState(() {
      ImageUploadModel imageUpload = new ImageUploadModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = imagefile;
      imageUpload.imageUrl = '';
      // _imgsFiles.add(imageUpload);
      print("en el file");

      images.replaceRange(index, index + 1, [imageUpload]);
      imagesRef.remove(imageUpload);
      imagesRef.remove("Add Image");
      images.add("Add Image");
      //imagesRef.remove("Add Image");
      editpublicationBloc.add(UpdateImgs(images));
      //imagesRef.removeLast();
    });
    /*});*/
  }

  Widget _publicationForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15),
      child: BlocBuilder<EditpublicationBloc, EditpublicationState>(
        builder: (context, state) {
          _locations = mapsUtil.getLocations(state.locations);
          getDir(_locations);
          images = state.imgRef ?? this.images;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                child: Text(
                  'EDITAR PUBLICACIÓN',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              _category(state),
              if (state.category != "SITUACIÓN DE CALLE") _nameTxt(state),
              _dirTxt(),
              _descTxt(state),
              //_images(),
              buildGridView(),
              //_boton(),
              _buttons(state)
            ],
          );
        },
      ),
    );
  }

  Widget _category(state) {
    return Container(
      // height: 100.0,
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 25),
      child: Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 5),
          child: Text(
            'Categoría:',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 50,
          child: GrayDropdownButton(
            hint: Text("Selecciona una categoria"),
            value: state.category,
            onChanged: (newValue) {
              editpublicationBloc.add(UpdateCategory(newValue));
            },
            items: listItems.map((valueItem) {
              return DropdownMenuItem(
                value: valueItem,
                child: Text(valueItem),
              );
            }).toList(),
          ),
        )
      ]),
    );
  }

  Widget _nameTxt(state) {
    return Container(
        //height: 100.0,

        child: Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 15),
          child: Text(
            'Completa los siguientes campos',
            style: TextStyle(fontSize: 16),
          )),
      Container(
          height: 77,
          padding: const EdgeInsets.fromLTRB(1, 4, 12, 1), //width: 300.0,
          child: GrayTextFormField(
            controller: _nameTxtController,
            hintText: 'Nombre',
            maxLength: 20,
            textCapitalization: TextCapitalization.words,
            suffixIcon: IconButton(
              onPressed: () {
                _nameTxtController.clear();
                prefs.adoptionName = '';
              },
              icon: Icon(Icons.clear),
            ),
            onChanged: (value) {
              editpublicationBloc.add(UpdateName(value));
              /*setState(() {
                // _nameTxtController.clear();
                _name = value;
                prefs.adoptionName = value;
              });*/
            },
          ))
    ]));
  }

  Widget _descTxt(state) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
        child: Container(
          alignment: Alignment.centerLeft,
          height: 140,
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: _descTxtController,
            decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  // color: Color.fromRGBO(49, 232, 93, 1),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                suffixIcon: IconButton(
                  onPressed: () {
                    _descTxtController.clear();
                    prefs.adoptionDescription = '';
                  },
                  icon: Icon(Icons.clear),
                )),
            maxLength: 400,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            onChanged: (value) {
              editpublicationBloc.add(UpdateDesc(value));
              /*setState(() {
                prefs.adoptionDescription = value;
                _desc = value;
              });*/
            },
          ),
        ));
  }

  Widget _dirTxt() {
    return Container(
        padding: const EdgeInsets.fromLTRB(1, 4, 13, 1),
        child: Stack(
          children: [
            Container(
              height: 70,
              alignment: Alignment.centerLeft,
              child: GrayTextFormField(
                controller: _dirTxtController,
                readOnly: true,
                hintText: 'Dirección',
                focusNode: AlwaysDisabledFocusNode(),
                maxLines: null,
                onTap: () {
                  /*Navigator.pushNamed(context, 'Map_edit_Page',
                      arguments: _markers);*/
                  prefs.previousPage = 'publication';
                  Navigator.pushNamed(context, 'mapPublication',
                      arguments: editpublicationBloc);
                },
              ),
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
    editpublicationBloc.add(EditUpdateLocations(Set<Marker>()));
    _dirTxtController.clear();
    _markers.clear();
  }

  Widget _buttons(state) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_cancelBtn(), _saveBtn(state)],
      ),
    );
  }

  Widget _cancelBtn() {
    return TextButton(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text('Cancelar', style: TextStyle(color: Colors.black)),
      ),
      onPressed: () {
        /*_nameTxtController.clear();
        _descTxtController.clear();
        _dirTxtController.clear();*/
        editpublicationBloc.add(CleanData());
        Navigator.pop(context);
        print("que pedo");
        print(images);
        print(imagesRef);
      },
      style: TextButton.styleFrom(
        primary: Color.fromRGBO(49, 232, 93, 1),
      ),
    );
  }

  Widget _saveBtn(state) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(30, 215, 96, 1),
        ),
        onPressed: () {
          if (_selectedCategory == 'SITUACIÓN DE CALLE') {
            _name = 'Animal Callejero';
            prefs.adoptionName = 'Animal Callejero';
          }
          print(_locations);
          if (_name.isEmpty ||
              _desc.isEmpty ||
              imagesRef.isEmpty ||
              _locations.isEmpty) {
            print("images");
            print(imagesRef);
            print('POOOOOOOOOOOOOOOL ImGREG6');
            print(imagesRef);
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Es necesario llenar todos los campos')));
          } else {
            print(_imgsFiles.toString());
            print('SEBASSS ImGRE7');

            print(imagesRef);
            //imagesRef.remove('Add Image');
            print(imagesRef);

            //print(mapsUtil.locationtoString(_locations));
            PublicationModel ad = PublicationModel(
                id: widget.detailDocument.id,
                category: _selectedCategory,
                name: _nameTxtController.text,
                location: mapsUtil.locationtoString(_locations),
                userID: prefs.userID,
                description: _descTxtController.text,
                imgRef: imagesRef);
            _db.addPublication(ad).then((value) {
              editpublicationBloc.add(CleanData());
              /*prefs.adoptionCategory = 'ADOPCIÓN';
              prefs.adoptionDescription = '';
              prefs.adoptionName = '';*/
              _dirTxtController.clear();
              Navigator.popAndPushNamed(context, 'navigation');
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Has editado tu publicación.')));
            });
            print(_name);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Guardar cambios'),
        ));
  }

  void getDir(List<LatLng> locations) {
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
