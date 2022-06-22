import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mustahiq_app/core/models/model_mustahiq.dart';
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:mustahiq_app/main.dart';
import 'package:mustahiq_app/ui/screens/edit_mustahiq.dart';
import '../../mainMenu.dart';
import 'list_mustahiq.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class MustahiqDetails extends StatefulWidget {
  final Modelmustahiq modelmustahiq;
  MustahiqDetails(this.modelmustahiq);

  @override
  _MustahiqDetailsState createState() => _MustahiqDetailsState(modelmustahiq);
}



class _MustahiqDetailsState extends State<MustahiqDetails> {
  final Modelmustahiq modelmustahiq;

  _MustahiqDetailsState(this.modelmustahiq);
  @override
  void initState() {
    super.initState();
  }

  void approveData(){
    // var url = "http://192.168.43.197/lensa-mustahiq/beckend/mustahiq_approve.php";
    var url = BaseUrl().approveData;
    http.post(url, body: {
      'id': widget.modelmustahiq.id
    });
  }

  void deleteData(){
    // var url = "http://192.168.43.197/lensa-mustahiq/beckend/mustahiq_hapus.php";
    var url = BaseUrl().deleteMustahiq;
    http.post(url, body: {
      'id': widget.modelmustahiq.id
    });
  }

  void approveConfirm(){
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Anda Yakin Akan Meng-Approve Data Ini"),
      actions: <Widget>[
        new RaisedButton(
          child: Text("OK"),
          color: Colors.red,
          onPressed: (){
            approveData();
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Login()));
          }),
        new RaisedButton(
          child: Text("Cancel"),
          color: Colors.green,
          onPressed: (){
            Navigator.pop(context);
          }),
      ],
    );

    showDialog(context: context,child: alertDialog);
  }

  void confirm(){
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Anda Yakin Akan Menghapus data ini ?"),
      actions: <Widget>[
        new RaisedButton(
          child: Text("Approve"),
          color: Colors.red,
          onPressed: (){
            deleteData();
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new Login()));
          }),
        new RaisedButton(
          child: Text("Cancel"),
          color: Colors.green,
          onPressed: (){
            Navigator.pop(context);
          }),
      ],
    );

    showDialog(context: context,child: alertDialog);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;


  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  Future<void> notificationAfterSec() async {
    var timeDelayed = DateTime.now().add(Duration(days: 90));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(1, 'Assalamualaikum',
        'Jadwal Untuk menyerahkan Bantuan Selanjutnya untuk '+widget.modelmustahiq.nama, timeDelayed, notificationDetails);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

   @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width*0.55;

    return Scaffold(
      appBar: AppBar(
        title: Text("Lensa Mustahiq", style: TextStyle(color: Colors.blue),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10,top: 10,right: 10,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(BaseUrl().image+widget.modelmustahiq.photo,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: <Widget>[ 
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Nama",
                         style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Jenis Kelamin"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Alamat"),
                      ),                     
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Tempat/Tgl Lahir"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("ULP"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("IDPEL"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Status Rumah"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Status Pernikahan"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Kondisi"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pekerjaan"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Penghasilan"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Tanggungan"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Kategori"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Rekomendasi"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Tgl Survey"),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[ 
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.modelmustahiq.nama,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.gender),
                      ),
                      // Flexible(child: Text(widget.modelmustahiq.alamat,overflow: TextOverflow.ellipsis,),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 180,
                          child: Text(widget.modelmustahiq.alamat,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Text(widget.modelmustahiq.tempatLahir),
                            Text(", "),
                            Text(widget.modelmustahiq.tglLahir),
                          ],
                        )
                          
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.ulp),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.idpel),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.statusRumah),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.ulp),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.kondisi),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.pekerjaan),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.penghasilan),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.tanggungan),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.rekomendasi),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.nilaiRekomend),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.modelmustahiq.tglSurvey),
                      )
                    ],
                  ),
                ],
              ),
            ),

            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(64,8,64,8),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child:
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        color: Colors.blue,
                        child: Text("Approve"),
                        onPressed:(){
                            print("Approve");
                            approveConfirm();
                            _showNotificationsAfterSecond();
                          },
                        ),
                    
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(64,8,64,8),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed:(){
                            print("Decline");
                            confirm();
                            
                           
                          },
                          child: Text("Decline"),
                          color: Colors.greenAccent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: (){
                            confirm();
                            print(modelmustahiq.id);
                          },
                          child: Text("Delete"),
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            
          ],

        ),
      ),
    );

  }

  
} 