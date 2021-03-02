import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/feed_page.dart';
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
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 49.0,
            title: TabBar(
              indicatorColor: Colors.lightGreenAccent[700],
              tabs: [
                Container(
                  height: 47.0,
                  child: new Tab(text: 'Inicio'),
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
              UserMapPage(),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
