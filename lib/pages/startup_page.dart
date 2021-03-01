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
      preferredSize: Size.fromHeight(20.0),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Tab(
                  text: 'Inicio',
                ),
                Tab(
                  text: 'Explorar',
                ),
              ],
              labelColor: Color.fromRGBO(49, 232, 93, 1),
              unselectedLabelColor: Colors.black,
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
