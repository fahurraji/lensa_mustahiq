import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:mustahiq_app/ui/screens/list_calon.dart';
import 'package:mustahiq_app/ui/screens/setting.dart';

class MenuUser extends StatefulWidget {
  final VoidCallback signOut;
  MenuUser(this.signOut);


  
  @override
  _MenuUserState createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            CalonMustahiq(),
            // MyLocation(),
            Setting(),
            // Profile(),
          ],
        ),
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              style: BorderStyle.none
            )
          ),
          tabs: <Widget>[
            
            Tab(
              icon: Icon(Icons.person_add),
              text: "Calon",
            ),
            Tab(
            icon: Icon(Icons.settings),
            text: "Setting",
            ),
          ]
        )
      ),
    );
  }
}