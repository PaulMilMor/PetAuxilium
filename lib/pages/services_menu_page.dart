import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
        _btnService('Servicio 1', context),
        _btnService('Servicio 2', context)
       ]
     ),
     TableRow(
       children:[
        _btnService('Servicio 3', context),
        _btnService('Servicio 4', context)
       ]
     ),
     TableRow(
       children:[
        _btnService('Servicio 5', context),
        _btnService('Servicio 6', context)
       ]
     ),
     TableRow(
       children:[
        _btnService('Servicio 7', context),
        _btnService('Servicio 8', context)
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
         height: 180,
         margin: EdgeInsets.all(15),
         decoration: BoxDecoration(
           color:Colors.grey[200], 
           borderRadius: BorderRadius.circular(20)
           ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
                SizedBox(height:5.0),
               CircleAvatar(
                 radius: 35.0,
                 backgroundColor: Colors.white,
                 child:Icon(Icons.pets, color: Colors.black,size: 30.0,)
                 ),
                 Text(service, style:  TextStyle(color: Colors.black),),
                 SizedBox(height:5.0)
             ],),
        ),
    );
    
  }
}
