library mapbox_gl;
import 'package:flutter/material.dart';
import 'package:mustahiq_app/mainMenu.dart';
import 'package:mustahiq_app/ui/screens/login_mustahiq.dart';
// import 'package:mustahiq_app/ui/screens/login_screen.dart';
import 'package:mustahiq_app/ui/screens/profile_screen.dart';
import 'package:mustahiq_app/ui/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:http/http.dart' as http;
import 'MenuUser.dart';



import 'dart:convert';

import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';


part 'src/controller.dart';
part 'src/flutter_mapbox_view.dart';
part 'src/camera.dart';
part 'src/models.dart';



void main() {
  runApp(MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      appBarTheme: AppBarTheme(color: Colors.white,
          iconTheme: IconThemeData(color: Colors.blue))
    ),
  ));
}


enum LoginStatus{ notSignIn, signIn , signInUser }

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginStatus _loginStatus = LoginStatus.notSignIn;

  String email,username, password;

  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      load();
      login();
    }
  }

  savePref(int value, String username, String email, String id_user , String role_id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("email", email);
      preferences.setString("id_user", id_user);
      preferences.setString("role_id", role_id);
      preferences.commit();
    });
  }

  login() async {
    final response = await http.post(BaseUrl().login, body: {
      "username" : username,
      "password" : password,
    });
    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String emailAPI = data['email'];
    String id_user = data['id_user'];
    String role_id = data['role_id'];
    if (value == 1) {
      if(role_id == "3"){
        setState(() {
        _loginStatus = LoginStatus.signInUser;
        savePref(value, usernameAPI, emailAPI, id_user, role_id);
      });
      } else {
         setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, emailAPI, id_user, role_id);
        });
      }
     

      print(pesan);
    } else {
      print(pesan);
    }
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("role_id");
      _loginStatus = value == "4" ? LoginStatus.signIn 
      : value =="3" ? LoginStatus.signInUser : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

    SignOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });

  }

  @override
  Widget build(BuildContext context) {
    switch(_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          backgroundColor: Colors.blue,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: <Color>[
                  Colors.blue,
                  Colors.white,
                ],
              ),
            ),
            child: Form(
              key: _key,
              
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(32, 128, 32, 150),
                  padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.white38,
                        offset: new Offset(8.0, 8.0)
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child:  CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 56.0,
                          child: Image.asset('images/ybm2.jpg'),
                        ),
                      ),
                      Text("Login", style: TextStyle(color: Colors.black, fontSize: 24),),
                      SizedBox(height: 12,),
                      // Text("Welcome back\nPlease Login to Your Count", style: TextStyle(fontSize: 20, color: Colors.grey),),
                      SizedBox(height: 24,),

                      TextFormField(
                        validator: (e){
                          if(e.isEmpty) {
                            return "Please insert usrename";
                          }
                        },
                        onSaved: (e) => username = e,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                          labelText: "Username"),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        obscureText: _secureText,
                        onSaved: (e) => password = e,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                            labelText: "Password",
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                            ) ),

                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          onPressed: (){
                            
                            check();
                          },
                          child: Text("Login", style: TextStyle(color: Colors.white, letterSpacing: 3),),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(SignOut);
        break;
      case LoginStatus.signInUser:
        return MenuUser(SignOut);
        break;
    }
  }
}

class load extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.cyan,
      strokeWidth: 5,);
  }
}