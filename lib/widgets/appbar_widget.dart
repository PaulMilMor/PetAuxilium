import 'package:flutter/material.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(75);
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(75),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.blue,
          ),
          Center(
            child: Text("AppBar"),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      /*child: AppBar(
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: new IconButton(
              icon: new Icon(
                Icons.arrow_back_ios,
                color: Color.fromRGBO(49, 232, 93, 1),
              ),
              onPressed: () => Navigator.of(context).pop(),
              iconSize: 32,
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            Image.asset(
              'lib/assets/logo_asset.png',
              //width: 120,
            ),
          ]),*/
    );
  }
}
