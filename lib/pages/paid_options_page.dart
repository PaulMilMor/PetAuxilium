import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/stripe_util.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaidOptionsPage extends StatefulWidget {
  @override
  _PaidOptionsPageState createState() => _PaidOptionsPageState();
}

String _cardNumber = '';
String _packSelected = '12 meses';
String _cvv = '';
String _expMonth = '';
String _expYear = '';
String _price = '799';

class _PaidOptionsPageState extends State<PaidOptionsPage> {
  @override
  void initState() {
    super.initState();
    StripeUtil.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(1, 31, 60, 1),
                    // SizedBox(height: 25),
                    child: Text(
                      'Demuestra tu apoyo suscribiéndote a \nnuestro plan Patreon...',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 10),
                _freeOption(),
                _paidOption(),
                SizedBox(height: 15),
                _freeButton()
              ]),
        ),
      ),
    );
  }

  Widget _freeOption() {
    return Stack(
      children: [
        _freeDesc(),
        _freeTitle(),
      ],
    );
  }

  Widget _freeTitle() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'GRATIS',
        style: TextStyle(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 150, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _freeDesc() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 45, vertical: 40),
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey)),
      child: Column(children: [
        Text(
          'Publicaciones de forma ilimitada',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Recibe retroalimentación al instante',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'La comunidad podrá ver tus publicaciones \nen su feed',
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }

  Widget _paidOption() {
    return Stack(
      children: [
        _paidDesc(),
        _paidTitle(),
      ],
    );
  }

  Widget _paidTitle() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'PATREON',
        style: TextStyle(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.symmetric(horizontal: 150, vertical: 0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(30, 215, 96, 1),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _paidDesc() {
    var align = TextAlign.center;
    var style = TextStyle(color: Colors.white);
    var style2 = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
      padding: EdgeInsets.fromLTRB(1, 35, 1, 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.black87
          //border: Border.all(color:Colors.grey)
          ),
      child: Column(children: [
        Text('Publicaciones de forma ilimitada',
            textAlign: align, style: style),
        SizedBox(
          height: 10,
        ),
        Text('Obtén una mayor visibilidad en tu perfil \n de cuidador',
            textAlign: align, style: style),
        SizedBox(
          height: 10,
        ),
        Text('Destaca en el feed en la comunidad',
            textAlign: align, style: style),
        SizedBox(
          height: 10,
        ),
        Text('Consigue recompensas según tu progreso',
            textAlign: align, style: style),
        SizedBox(
          height: 10,
        ),
        Text('Otorga señalización especial a tus \n publicaciones',
            textAlign: align, style: style),
        SizedBox(
          height: 10,
        ),
        Text('Acceso anticipado a funcionalidades',
            textAlign: align, style: style),
        SizedBox(
          height: 10,
        ),
        Text(
            'Tu nombre aparecerá en la sección de \n patrones de nuestro sitio web',
            textAlign: align,
            style: style),
        SizedBox(
          height: 20,
        ),
        Text('Desde sólo \$0.99 USD al mes', textAlign: align, style: style2),
        SizedBox(
          height: 20,
        ),
        _paidButton()
      ]),
    );
  }

  Widget _paidButton() {
    return GestureDetector(
      child: Text(
        'PAGAR AHORA',
        style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
      ),
      onTap: () {
        _bottomMenu();
      },
    );
  }

  _bottomMenu() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                height: 450,
                margin: EdgeInsets.only(left: 15),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Padding(
                          //padding: const EdgeInsets.only(bottom: 42),
                          Center(
                            child: Text("Completa tu plan de pago",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            child: Text("Tipo de suscripción",
                                style: TextStyle(fontSize: 14)),
                          ),
                          Container(
                            child: Row(children: [
                              _monthButton('1 mes', setState),
                              _monthButton('4 meses', setState),
                              _monthButton('12 meses', setState)
                            ]),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text("Número de tarjeta",
                                style: TextStyle(fontSize: 14)),
                          ),

                          Container(
                            width: 300,
                            child: GrayTextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 16,
                              onChanged: (value) {
                                _cardNumber = value;
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 80),
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: Text("Fecha de expiración",
                                    style: TextStyle(fontSize: 14)),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child:
                                    Text("CVV", style: TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 60,
                                child: GrayTextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    _expMonth = value;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                width: 60,
                                child: GrayTextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    _expYear = value;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 65),
                                width: 60,
                                child: GrayTextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    _cvv = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          const Divider(
                            color: Colors.black26,
                            height: 5,
                            thickness: 1,
                            endIndent: 20,
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(1, 1, 35, 1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total a pagar: ' +
                                        '\$${(int.parse(_price) / 100).toString()}' +
                                        ' USD',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary:
                                              Color.fromRGBO(30, 215, 96, 1)),
                                      child: Text(
                                        'PAGAR',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () {
                                        _paid();
                                      }),
                                ],
                              )),
                        ])));
          });
        });
  }

  Widget _monthButton(String m, Function setS) {
    Color borderColor;
    if (m == _packSelected) {
      borderColor = Color.fromRGBO(30, 215, 96, 1);
      TextStyle(fontWeight: FontWeight.bold);
    } else {
      borderColor = Colors.grey;
    }
    return GestureDetector(
      onTap: () {
        if (m == '1 mes') {
          _price = '099';
        } else if (m == '4 meses') {
          _price = '299';
        } else if (m == '12 meses') {
          _price = '799';
        }
        _packSelected = m;

        setS(() {});
      },
      child: Container(
          child: Text(m),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: borderColor))),
    );
  }

  _paid() async {
    var pack;
    CreditCard card = CreditCard(
        number: _cardNumber,
        expMonth: int.parse(_expMonth),
        expYear: int.parse(_expYear),
        cvc: _cvv);
    if (_packSelected == '1 mes') pack = 1;
    if (_packSelected == '4 meses') pack = 4;
    if (_packSelected == '12 meses') pack = 6;
    StripeTransactionResponse response = await StripeUtil.payViaCard(
        amount: _price, currency: 'USD', card: card, pack: pack);

    if (response.success) {
      preferencesUtil().patreonUser = true;
      await dbUtil()
          .setPatreonPublications('publications', preferencesUtil().userID);
      await dbUtil()
          .setPatreonPublications('business', preferencesUtil().userID);
      Navigator.popAndPushNamed(context, 'navigation');
    }
    print(response.message);
  }

  Widget _freeButton() {
    return Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(1, 1, 10, 20),
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'mypublicationsPage');
                },
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text('Continuar de forma gratuita'),
                  Icon(
                    Icons.chevron_right,
                    color: Color.fromRGBO(30, 215, 96, 1),
                  )
                ]))));
  }
}
