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
  File imagefile;
  final picker = ImagePicker();
  void initState() {
    super.initState();

    setState(() {
      images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    //_markers = ModalRoute.of(context).settings.arguments;
    createpublicationBloc = BlocProvider.of<CreatepublicationBloc>(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(child: _publicationForm(context))),
      backgroundColor: Colors.white,
    );
  }

  Widget _publicationForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15),
      child: BlocBuilder<CreatepublicationBloc, CreatepublicationState>(
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
                  'CREAR PUBLICACIÓN',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              _category(state),
              if (state.category != "SITUACIÓN DE CALLE") _nameTxt(state),
              _dirTxt(),
              _descTxt(state),
              buildGridView(),
              _buttons(state)
            ],
          );
        },
      ),
    );
  }

//Formulario
  Widget _category(state) {
    return Container(
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
    return Container(
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
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(1, 4, 12, 1),
          child: GrayTextFormField(
            initialvalue: state.name,
            hintText: 'Nombre',
            maxLength: 20,
            textCapitalization: TextCapitalization.words,
            // suffixIcon: IconButton(
            //   onPressed: () {
            //     createpublicationBloc.add(UpdateName(''));
            //   },
            //   icon: Icon(Icons.clear),
            // ),
            onChanged: (value) {
              createpublicationBloc.add(UpdateName(value));
            },
          ))
    ]));
  }

  Widget _descTxt(state) {
    // var txtController = TextEditingController(text: state.desc);
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 140,
            //padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
            child: TextFormField(
              //key: UniqueKey(),
              initialValue: state.desc,
              decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  // color: Color.fromRGBO(49, 232, 93, 1),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                // suffixIcon: IconButton(
                //   onPressed: () {
                //     createpublicationBloc.add(UpdateDesc(''));
                //   },
                //   icon: Icon(Icons.clear),
                // )
              ),
              maxLength: 400,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                createpublicationBloc.add(UpdateDesc(value));
              },
            )));
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
                key: UniqueKey(),
                controller: _dirTxtController,
                readOnly: true,
                hintText: 'Dirección',
                focusNode: AlwaysDisabledFocusNode(),
                maxLines: null,
                onTap: () {
                  Navigator.pushNamed(context, 'mapPublication',
                      arguments: createpublicationBloc);
                },
              ),
            ),
            Positioned(
              right: 1,
              top: 10,
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
    createpublicationBloc.add(UpdateLocations(Set<Marker>()));
    _dirTxtController.clear();
    _markers.clear();
  }

// Sistema de imageness
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
        if (images.length < 6) images.add("Add Image");
        getFileImage(index);
      } else {}
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
    print("qie pedo");
    print(imagesRef);
    setState(() {
      ImageUploadModel imageUpload = new ImageUploadModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = imagefile;
      imageUpload.imageUrl = '';

      print("en el file");

      images.replaceRange(index, index + 1, [imageUpload]);
      createpublicationBloc.add(UpdateImgs(images));
    });
  }
  //BOTONES

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
        Navigator.pop(context);
        //images.add("Add Image");
      },
      style: TextButton.styleFrom(
        primary: Color.fromRGBO(49, 232, 93, 1),
      ),
    );
  }

//TODO: Posiblemente mover el proceso al bloc o por lo menos adaptar lo de los validadores
  Widget _saveBtn(state) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(30, 215, 96, 1),
        ),
        onPressed: () {
          if (state.category == 'SITUACIÓN DE CALLE') {
            state.name = 'Animal Callejero';
          }
          if (state.name.isEmpty ||
              state.desc.isEmpty ||
              imagesRef.isEmpty ||
              _locations.isEmpty) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Es necesario llenar todos los campos')));
          } else {
            print("que pedo alb");
            print(imagesRef);
            print(images);

            PublicationModel ad = PublicationModel(
                category: state.category,
                name: state.name,
                location: mapsUtil.locationtoString(_locations),
                userID: prefs.userID,
                description: state.desc,
                imgRef: imagesRef);
            _db.addPublication(ad).then((value) {
              createpublicationBloc.add(CleanData());
              _dirTxtController.clear();
              //Navigator.popAndPushNamed(context, 'navigation');
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Se ha creado tu publicación.')));
              //images.add("Add Image");

              Navigator.popAndPushNamed(context, 'navigation');
              if (prefs.patreonUser) {
              } else {
                Navigator.pushNamed(context, 'paidOptionsPage');
              }
            });
          }
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
