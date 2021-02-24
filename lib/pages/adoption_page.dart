import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/storage_util.dart';

class Adoptionpage extends StatefulWidget {
  @override
  Adoption_page createState() => Adoption_page();
}

class Adoption_page extends State {
  final db = dbUtil();
  final auth = AuthUtil();
  final _storage=StorageUtil();

  AddAdoption ad = AddAdoption(
      category: "adopcion",
      name: "Mauricio",
      description: "damos en adopcion a este perro",
      location: "aqui",
      imgRef: "aquivaunaimagen.png");

  File imagefile;
  final picker = ImagePicker();
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

/*setState(() {
      if (picture != null) {
        imagefile = picture;
      } else {
        print('No image selected');
      }
    });*/
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice wey"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      print("ostia puta");
                      print(context);
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      })
                ],
              ),
            ),
          );
        });
  }

  Widget _decideImageView() {
    if (imagefile == null) {
      return Text("No hay imagenes seleccionadas");
    } else {
      print("dentro del decide");
      print(imagefile);
      return Image.file(imagefile, width: 200, height: 200);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Adopcion'),
        ),
        body: SingleChildScrollView(
           child: Column(
            //mainAxisAlignment: MainAxisAligment.spaceAround,
            children: <Widget>[
              
              Container(
                height: 100.0,
                child: Center(
                  child: Text("PUBLICAR ADOPCIÓN", textAlign:  TextAlign.center,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)
                  ),
                ),
                ),
              Container(
                height: 50.0,
                width: 300.0,
                child: Text("Completa los siguientes campos:", textAlign:  TextAlign.left,style: TextStyle(fontSize: 18)
                ),
                ),
              
              Container(
                height: 70.0,
                width: 300.0,
                child: TextField(
                  decoration: InputDecoration(hintText: 'Nombre'),
                ),
              ),
              Container(
                child: Container(
                  height: 100.0,
                  width: 300.0,
                    child: TextField(
                  decoration: InputDecoration(hintText: 'Descripción'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                ),
              ),
              Container(
                child: Container(
                  height: 50.0,
                    child: Text("Aqui va la ubicación"),
                  ),
              ),
              _decideImageView(),
              RaisedButton(
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: Text("Agregar imagenes"),
              ),
              Container(
                height: 100.0,
                width: 200.0,
                child: Center(
                  child: Container(
                    
                    child: RaisedButton(
                        onPressed: () {

                          //Esto retorna un striing con el enlace
                    _storage.uploadFile(imagefile, 'adopcion');
                      
                        },child: Text("Publicar"),
                      ),
                  ),
                ),
              ),
            ],
          ))
        );
  }
}
