
// import 'dart:js';

// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:mustahiq_app/main.dart';
import 'package:mustahiq_app/ui/screens/about_apps.dart';
import 'package:mustahiq_app/ui/screens/add_mustahiq.dart';
import 'package:mustahiq_app/ui/screens/list_bantuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mustahiqlist.dart';
import 'notifikasi.dart';

class Setting extends StatefulWidget {

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: ListView(
         padding: const EdgeInsets.all(8.0),
         children: <Widget>[
           Card(
            child: ListTile(
              leading: Icon(Icons.help),
              title: Text('Tentang Aplikasi'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutApps()));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('List Bantuan'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListBantuan()));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('Notifikasi'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>LocalNotifications()));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Version 1.0.1'),
              // subtitle: Text('versi 1.0.1'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddMustahiq()));
              },
            ),
          ),
         ],
       ),
    );
  }
}