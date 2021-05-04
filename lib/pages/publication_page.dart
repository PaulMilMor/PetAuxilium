import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_auxilium/blocs/createpublication/createpublication_bloc.dart';
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

  CreatepublicationBloc createpublicationBloc = CreatepublicationBloc();
  final StorageUtil _storage = StorageUtil();
  final MapsUtil mapsUtil = MapsUtil();
  Set<Marker> _markers = new Set<Marker>();
  List listItems = ['ADOPCIÓN', 'ANIMAL PERDIDO', 'SITUACIÓN DE CALLE'];
  var _dirTxtController = TextEditingController();
  List<LatLng> _locations;
  List<String> imagesRef = [];
  List<Object> images = [];
  Future<File> _imageFile;
  List<ImageUploadModel> _imgsFiles = [];
  File imagefile;
  List<File> _listImages = [];
  final picker = ImagePicker();
  final nameKey = UniqueKey();
  void initState() {
    super.initState();

    setState(() {
      images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _markers = ModalRoute.of(context).settings.arguments;
    _locations = mapsUtil.getLocations(_markers);
    getDir(_locations);
    createpublicationBloc = BlocProvider.of<CreatepublicationBloc>(context);
    return Scaffold(
      body: SingleChildScrollView(child: _publicationForm(context)),
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
            padding: const EdgeInsets.all(8.0),
            child: AddImageButton(onTap: () {
              images.length < 6
                  ? _onAddImageClick(index)
                  : _limitImages(context);
            }),
          );
        }
      }),
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

    setState(() {
      ImageUploadModel imageUpload = new ImageUploadModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = imagefile;
      imageUpload.imageUrl = '';
      // _imgsFiles.add(imageUpload);
      print("en el file");

      images.replaceRange(index, index + 1, [imageUpload]);
    });
    /*});*/
  }

  Widget _publicationForm(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
        child: BlocBuilder<CreatepublicationBloc, CreatepublicationState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 15),
                  child: Text(
                    'CREAR PUBLICACIÓN',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget _category(state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
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
              hint: Text("Selecciona una categoría"),
              value: state.category,
              onChanged: (newValue) {
                createpublicationBloc.add(UpdateCategory(newValue));
              },
              items: listItems.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem, style: TextStyle(fontSize: 14)),
                );
              }).toList(),
            )),
      ]),
    );
  }

  Widget _nameTxt(state) {
    var txtController = TextEditingController(text: state.name);
    return Container(
        child: Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'Completa los siguientes campos',
            style: TextStyle(fontSize: 16),
          )),
      Container(
          height: 77,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(1, 4, 12, 1), //width: 300.0,
          child: GrayTextFormField(
            key: nameKey,
            initialvalue: state.name,
            hintText: 'Nombre',
            maxLength: 20,
            textCapitalization: TextCapitalization.words,
            suffixIcon: IconButton(
              onPressed: () {
                createpublicationBloc.add(UpdateName(''));
              },
              icon: Icon(Icons.clear),
            ),
            onChanged: (value) {
              createpublicationBloc.add(UpdateName(value));
            },
          ))
    ]));
  }

  Widget _descTxt(state) {
    var txtController = TextEditingController(text: state.desc);
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 140,
            //padding: const EdgeInsets.fromLTRB(1, 0, 12, 0),
            child: TextFormField(
              //key: UniqueKey(),
              controller: txtController,
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
                      createpublicationBloc.add(UpdateDesc(''));
                    },
                    icon: Icon(Icons.clear),
                  )),
              maxLength: 400,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                createpublicationBloc.add(UpdateDesc(value));
              },
            )));
  }

  Widget _dirTxt() {
    return Container(
        padding: const EdgeInsets.fromLTRB(1, 9, 13, 0),
        child: Stack(
          children: [
            Container(
                height: 52,
                alignment: Alignment.centerLeft,
                //padding: const EdgeInsets.fromLTRB(1, 1, 1, 5),
                child: GrayTextFormField(
                  controller: _dirTxtController,
                  readOnly: true,
                  hintText: 'Dirección',
                  focusNode: AlwaysDisabledFocusNode(),
                  maxLines: null,
                  onTap: () {
                    Navigator.pushNamed(context, 'mapPublication',
                        arguments: _markers);
                  },
                )),
            Positioned(
              right: 1,
              top: 2,
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
        createpublicationBloc.add(CleanData());
        Navigator.of(context).pop();
      },
      style: TextButton.styleFrom(
        primary: Color.fromRGBO(49, 232, 93, 1),
      ),
    );
  }

//TODO: Posiblemente mover el proceso al bloc o por lo menos adaptar lo de los validadores
  Widget _saveBtn(state) {
    String name = state.name;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(30, 215, 96, 1),
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'paidOptionsPage');
          // if (state.category == 'SITUACIÓN DE CALLE') {
          //   name = 'Animal Callejero';
          // }
          // if (name.isEmpty ||
          //     state.desc.isEmpty ||
          //     imagesRef.isEmpty ||
          //     _locations.isEmpty) {
          //   ScaffoldMessenger.of(context)
          //     ..removeCurrentSnackBar()
          //     ..showSnackBar(SnackBar(
          //         content: Text('Es necesario llenar todos los campos')));
          // } else {

          //   PublicationModel ad = PublicationModel(
          //       category: state.category,
          //       name: name,
          //       location: mapsUtil.locationtoString(_locations),
          //       userID: prefs.userID,
          //       description: state.desc,
          //       imgRef: imagesRef);
          //   _db.addPublication(ad).then((value) {
          //     createpublicationBloc.add(CleanData());
          //     Navigator.popAndPushNamed(context, 'navigation');
          //     ScaffoldMessenger.of(context)
          //       ..removeCurrentSnackBar()
          //       ..showSnackBar(SnackBar(
          //           content: Text('Se ha creado tu publicación.')));
          //   });

          // }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Publicar'),
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
