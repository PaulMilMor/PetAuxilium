import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/feed_page.dart';
import 'package:pet_auxilium/pages/services_menu_page.dart';
import 'package:pet_auxilium/pages/user_map_page.dart';

class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 49.0,
            title: TabBar(
              indicatorColor: Colors.lightGreenAccent[700],
              tabs: [
                Container(
                  height: 47.0,
                  child: new Tab(text: 'Inicios'),
                ),
                Container(
                  height: 47.0,
                  child: new Tab(text: 'Servicios'),
                ),
                Container(
                  height: 47.0,
                  child: new Tab(text: 'Explorar'),
                ),
              ],
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelColor: Colors.grey[600],
            ),
          ),
          body: TabBarView(
            children: [
              Feed(),
              ServicesMenuPage(),
              UserMapPage(),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
