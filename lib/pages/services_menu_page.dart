import 'dart:ui';

import 'package:flutter/material.dart';

class ServicesMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
          children:[
           
            SingleChildScrollView(
              child:Column(
                children:[
                  
                  _table(context)
                ]
              ) ,)
          ]
      ),
    );
  }

  Widget _table(BuildContext context){
    return Table(
   children: [
     TableRow(
       children:[
        _btnService('Adopción', context),
        _btnService('Animales\nCallejeros', context)
       ]
     ),
     TableRow(
       children:[
        _btnService('Animales\nPerdidos', context),
        _btnService('Cuidados\nEspeciales', context)
       ]
     ),
     TableRow(
       children:[
        _btnService('Consultaria', context),
        _btnService('Estética', context)
       ]
     ),
     TableRow(
       children:[
        _btnService('Entrenamiento', context),
        _btnService('Guardería/Hotel\nde animales', context)
       ]
     ),
         TableRow(
       children:[
        _btnService('Servicios de\nSalud', context),
        _btnService('Servicios de\nLimpieza', context)
       ]
     ),
         TableRow(
       children:[
        _btnService('Ventas', context),
        _btnService('Veterinarias', context)
       ]
     ),
     
   ],

    );
  }
  Widget _btnService(String service, BuildContext context){
    return GestureDetector(
          onTap: (){
      Navigator.pushNamed(context, 'service',arguments: service);
            print(service);
          },
          child: Container(
         height: 70,
        
         margin: EdgeInsets.all(15),
         decoration: BoxDecoration(
           //color:Colors.grey[200], 
           //borderRadius: BorderRadius.circular(20)
           ),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               // SizedBox(height:5.0),
               CircleAvatar(
                 radius: 35.0,
                 backgroundColor: Colors.white,
                 child:Icon(Icons.pets, color: Colors.black,size: 30.0,)
                 ),
                 Text(service, style:  TextStyle(color: Colors.black),),
                 //SizedBox(height:5.0)
             ],),
        ),
    );
    
  }
}
