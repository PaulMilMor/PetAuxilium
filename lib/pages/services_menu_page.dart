import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

class ServicesMenuPage extends StatefulWidget {
  @override
  _ServicesMenuPageState createState() => _ServicesMenuPageState();
}

final dbUtil _db = dbUtil();

//FIXME: ¿Qué es exactamente lo q se busca? xdxd Actualmente busca servicios pero ya q algunos no tienen todos los campos se tuvo q limitar
class _ServicesMenuPageState extends State<ServicesMenuPage> {
  TextEditingController _searchTxtController;
  String _query;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: AnimatedPadding(
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate,
            padding: _query == null || _query == ''
                ? const EdgeInsets.all(18.0)
                : const EdgeInsets.all(0.0),
            child: Column(
              children: [
                _searchBar(),
                _query == null || _query == ''
                    ? _table(context)
                    : _searchResults(),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 16, 6, 28),
      child: GrayTextFormField(
        prefixIcon: Icon(Icons.search),
        hintText: 'Buscar publicación',
        controller: _searchTxtController,
        onChanged: (value) {
          setState(() {
            _query = value;
          });
        },
      ),
    );
  }

//FIXME: Esto no hace scroll al tocar las cards
//TODO: Ajustar la búsqueda para que busque en publicaciones, denuncias y negocios
  Widget _searchResults() {
    return StreamBuilder(
        stream: _db.searchedElements(_query),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return ListFeed(
              snapshot: snapshot,
            );
          } else {
            return Center(
              child: Text('No se encontró nada.'),
            );
          }
        });
  }

  Widget _table(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _btnService('Adopción', context),
          _btnService('Animales\nCallejeros', context)
        ]),
        TableRow(children: [
          _btnService('Animales\nPerdidos', context),
          _btnService('Cuidados\nEspeciales', context)
        ]),
        TableRow(children: [
          _btnService('Consultoría', context),
          _btnService('Estética', context)
        ]),
        TableRow(children: [
          _btnService('Entrenamiento', context),
          _btnService('Guardería/Hotel\nde animales', context)
        ]),
        TableRow(children: [
          _btnService('Servicios de\nSalud', context),
          _btnService('Servicios de\nLimpieza', context)
        ]),
        TableRow(children: [
          _btnService('Ventas', context),
          _btnService('Veterinarias', context)
        ]),
        TableRow(children: [_btnService('Denuncias', context), _complaint()]),
      ],
    );
  }

  Widget _complaint() {
    return Container(
      height: 40,
    );
  }

  Widget _btnService(String service, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'service', arguments: service);
        print(service);
      },
      child: Container(
        height: 70,
        //margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            //color:Colors.grey[200],
            //borderRadius: BorderRadius.circular(20)
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: _serviceIcon(service),
              width: 45,
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                service,
                style: TextStyle(color: Colors.black),
              ),
            ),
            //SizedBox(height:5.0)
          ],
        ),
      ),
    );
  }

  _serviceIcon(service) {
    String servicio = service;
    switch (servicio) {
      case "Animales\nPerdidos":
        {
          return AssetImage('assets/icons/animales_perdidos.png');
        }
        break;

      case "Adopción":
        {
          return AssetImage('assets/icons/adopcion.png');
        }
        break;

      case "Animales\nCallejeros":
        {
          return AssetImage('assets/icons/animales_callejeros.png');
        }
        break;

      case "Cuidados\nEspeciales":
        {
          return AssetImage('assets/icons/cuidados_especiales.png');
        }
        break;
      case "Consultoría":
        {
          return AssetImage('assets/icons/consultoria.png');
        }
        break;
      case "Estética":
        {
          return AssetImage('assets/icons/estetica.png');
        }
        break;
      case "Entrenamiento":
        {
          return AssetImage('assets/icons/entrenamiento.png');
        }
        break;
      case "Guardería/Hotel\nde animales":
        {
          return AssetImage('assets/icons/guarderia_hotel.png');
        }
        break;
      case "Servicios de\nSalud":
        {
          return AssetImage('assets/icons/servicios_de_salud.png');
        }
        break;
      case "Servicios de\nLimpieza":
        {
          return AssetImage('assets/icons/servicios_de_limpieza.png');
        }
        break;
      case "Ventas":
        {
          return AssetImage('assets/icons/ventas.png');
        }
        break;
      case "Veterinarias":
        {
          return AssetImage('assets/icons/veterinarias.png');
        }
        break;
      case "Denuncias":
        {
          return AssetImage('assets/icons/denuncias.png');
        }
        break;
    }
  }
}
