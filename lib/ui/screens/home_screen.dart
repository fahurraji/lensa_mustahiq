import 'dart:ui';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:mustahiq_app/core/utils/toast_utils.dart';
import 'package:mustahiq_app/main.dart';
import 'package:mustahiq_app/ui/screens/add_mustahiq.dart';
import 'package:mustahiq_app/ui/screens/list_mustahiq.dart';

import 'package:mustahiq_app/ui/screens/maps_screen.dart';
import 'package:mustahiq_app/ui/screens/mustahiqlist.dart';
// import 'package:mustahiq_app/src/flutter_mapbox_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_bantuan.dart';



/// This Widget is the main application widget.
class HomeScreen extends StatelessWidget {
  static const String _title = 'Halaman Home';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
   
    new ListBantuan(),
    // new Mustahiqlist(),
    new MustahiqList(),
    new MapsPage(),
    // Text(
    //   'Index 2: School',
    //   style: optionStyle,
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  void _logout(){
    setState(() {
      print("IconButton is clicked");
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
    });
  }

  String username, email;

  @override
  void initState() { 
    super.initState();
    getPref();
  }

  logout(){
    ToastUtils.show("waiting logout...");
    savePref();

    Future.delayed(const Duration(microseconds: 2000),(){
      ToastUtils.show("Success logout...");
      // Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic>routes)=>false);
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new Login()),);
    });
  }

  savePref()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.remove('username');
      pref.remove('email');
    });
  }

  getPref()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    setState(() {
        username = pref.getString('username'); 
        email = pref.getString('email');     
    });

    if(username != null){
    }else{
      Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic>routes)=>false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MustahiqApps'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Exit',
            // onPressed: _logout
            onPressed: (){
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              logout();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                  'Lensa Mustahiq',
                    style: TextStyle(
                    color: Colors.white,                
                    fontSize: 24,
                  ),
                ),
            ),
            
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),

            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
            ),
            
          ],
         
        ),
        
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            title: Text('Mustahiq'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Maps'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[300],
        onTap: _onItemTapped,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     print("floatingActionButton pressed");
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddMustahiq()));
      //   },
      //   elevation: 5,
      //   child: Icon(Icons.add, size: 25,),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

