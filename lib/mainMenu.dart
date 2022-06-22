import 'package:flutter/material.dart';
import 'package:mustahiq_app/ui/screens/add_mustahiq.dart';
import 'package:mustahiq_app/ui/screens/list_calon.dart';
import 'package:mustahiq_app/ui/screens/list_calon_penyalur.dart';
import 'package:mustahiq_app/ui/screens/list_mustahiq.dart';
import 'package:mustahiq_app/ui/screens/maps_screen.dart';
import 'package:mustahiq_app/ui/screens/insertMustahiq.dart';
import 'package:mustahiq_app/ui/screens/mylocations.dart';
import 'package:mustahiq_app/ui/screens/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {

  final VoidCallback signOut;
  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "" , email= "";

getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
    });
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        
      appBar: AppBar(
        backgroundColor: Colors.blue,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Icon(Icons.arrow_back),
                Text("Lensa Mustahiq", style: TextStyle(color: Colors.white, ),)
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.lock_open, color: Colors.red,),
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            MustahiqList(),
            AdminCalonMustahiq(),
            // MyLocation(),
            Setting(),
          
          ],
        ),
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              style: BorderStyle.solid
            )
          ),
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.person),
              text: "Mustahiq",
            ),
            Tab(
            icon: Icon(Icons.person_add),
            text: "Calon",
            ),
         
            Tab(
              icon: Icon(Icons.settings),
              text: "Setting",
            ),
          ],
        ),
      ),
    );
  }
}
