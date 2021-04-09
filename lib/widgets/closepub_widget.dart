import 'package:flutter/material.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

enum ClosePub { adopcion, perdido, cuidador, calle, negocio, eliminar }

class ClosePublication extends StatefulWidget {
  @override
  _ClosePublicationState createState() => _ClosePublicationState();
}

class _ClosePublicationState extends State<ClosePublication> {
  ClosePub _option = ClosePub.adopcion;
  Widget build(BuildContext context) {
    void _CloseMenu(publications) {
      if (publications['category'] == 'ANIMAL PERDIDO') {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    height: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Padding(
                          //padding: const EdgeInsets.only(bottom: 42),
                          Center(
                            child: Text("Cerrar publicación",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 15,
                          ), //),
                          const Divider(
                            color: Colors.grey,
                            height: 5,
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: Center(
                              child: Text(
                                  "¿Por qué quieres cerrar esta publicación?",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                    'La mascota perdida ya ha sido localizada'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.perdido,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                    'Deseo eliminar esta publicación'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.eliminar,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text('Cancelar',
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(49, 232, 93, 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Continuar'),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
      } else if (publications['category'] == 'ADOPCIÓN') {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    height: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Padding(
                          //padding: const EdgeInsets.only(bottom: 42),
                          Center(
                            child: Text("Cerrar publicación",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 15,
                          ), //),
                          const Divider(
                            color: Colors.grey,
                            height: 5,
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: Center(
                              child: Text(
                                  "¿Por qué quieres cerrar esta publicación?",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                    'La mascota ya ha sido dada en adopción'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.perdido,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                    'Deseo eliminar esta publicación'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.eliminar,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text('Cancelar',
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(49, 232, 93, 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Continuar'),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
      } else if (publications['category'] == 'CUIDADOR') {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    height: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Padding(
                          //padding: const EdgeInsets.only(bottom: 42),
                          Center(
                            child: Text("Cerrar publicación",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 15,
                          ), //),
                          const Divider(
                            color: Colors.grey,
                            height: 5,
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: Center(
                              child: Text(
                                  "¿Por qué quieres cerrar esta publicación?",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                    'Al chile ya me harté de andar cuidando animales'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.perdido,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                    'Deseo eliminar esta publicación'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.eliminar,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text('Cancelar',
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(49, 232, 93, 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Continuar'),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
      } else if (publications['category'] == 'NEGOCIO') {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    height: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Padding(
                          //padding: const EdgeInsets.only(bottom: 42),
                          Center(
                            child: Text("Cerrar publicación",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 15,
                          ), //),
                          const Divider(
                            color: Colors.grey,
                            height: 5,
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: Center(
                              child: Text(
                                  "¿Por qué quieres cerrar esta publicación?",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                    'Ya no me interesa publicitar este negocio'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.perdido,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                    'Deseo eliminar esta publicación'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.eliminar,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text('Cancelar',
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(49, 232, 93, 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Continuar'),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
      } else if (publications['category'] == 'SITUACIÓN DE CALLE') {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    height: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Padding(
                          //padding: const EdgeInsets.only(bottom: 42),
                          Center(
                            child: Text("Cerrar publicación",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 15,
                          ), //),
                          const Divider(
                            color: Colors.grey,
                            height: 5,
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: Center(
                              child: Text(
                                  "¿Por qué quieres cerrar esta publicación?",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: const Text(
                                    'El animal callejero ya ha sido atendido'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.perdido,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                    'Deseo eliminar esta publicación'),
                                leading: Radio<ClosePub>(
                                  value: ClosePub.eliminar,
                                  groupValue: _option,
                                  onChanged: (ClosePub value) {
                                    setState(() {
                                      _option = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text('Cancelar',
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(49, 232, 93, 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Continuar'),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
      }
    }
  }
}
