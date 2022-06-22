import 'dart:convert';
import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:mustahiq_app/core/models/model_mustahiq.dart';
import 'package:mustahiq_app/ui/screens/add_mustahiq.dart';
import 'package:mustahiq_app/ui/screens/bantuanmustahiq.dart';
import 'package:mustahiq_app/ui/screens/detail_listhome.dart';
import 'package:mustahiq_app/ui/screens/edit_mustahiq.dart';
import 'package:mustahiq_app/ui/screens/insertMustahiq.dart';
import 'package:mustahiq_app/ui/screens/mustahiqlist.dart';
import 'package:mustahiq_app/ui/screens/update_mustahiq.dart';
import 'detailsmustahiq.dart';
import 'package:url_launcher/url_launcher.dart';


class MustahiqList extends StatefulWidget {
  // final String title;

  // const MustahiqList({Key key, this.title}) : super(key: key);

  @override
  MustahiqListState createState() => MustahiqListState();
}

class MustahiqListState extends State<MustahiqList>{
  // List data;

  // Function to get the JSON data
  // Future<Map<String,dynamic>> getJSONData() async {
  //   var response = await http.get(
  //       // Encode the url
  //       Uri.encodeFull(BaseUrl().listMustahiq),
  //       // Only accept JSON response
  //       headers: {"Accept": "application/json"}
  //   );

  //   setState(() {
  //     // Get the JSON data
  //     // data = json.decode(response.body)['result'];
  //     data = json.decode(response.body);
  //   });

  //   // return "Successfull";
  // }

  var loading = false;
  final list = new List<Modelmustahiq>();

  void _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl().listMustahiq);

    if(response.contentLength == 2) {

    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new Modelmustahiq(
          api['id'], 
          api['nama'],
          api['tempat_lahir'], 
          api['gender'], 
          api['tgl_lahir'],
          api['umur'],
          api['alamat'],
          api['ulp'],
          api['status_rumah'], 
          api['idpel'],
          api['status_nikah'], 
          api['kondisi'],
          api['kondisi_desc'],
          api['pekerjaan'],
          api['penghasilan'], 
          api['tanggungan'],
          api['kategori_mustahiq'],
          api['rekomendasi'],
          api['nilai_rekomend'], 
          api['tgl_survey'],
          api['tgl_bantuan'],
          api['photo'],
          api['lokasi'],
          api['is_approve'],
          api['created_at'],
          api['created_by'],
          api['updated_at'],
          api['updated_by'],
          api['is_deleted']
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }



  @override
  Widget build(BuildContext context) {
    

    return Scaffold( 
      body: _buildListView(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     print("floatingActionButton pressed");
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => InsertMustahiq()));
      //   },
      //   elevation: 5,
      //   child: Icon(Icons.add, size: 25,),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildListView() {
    double c_width = MediaQuery.of(context).size.width*0.7;
    return list.isEmpty ? Center(child: Text('No Data Available')) : ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: list == null ? 0 : list.length,
      // itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, index) {
        final x = list[index];
        final String lat = x.lokasi;
        // return _cardImage(data[index]);
        
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: InkWell(
            onTap: () => {
              // print(item['id']),
              // Navigator.push(context, new MaterialPageRoute(builder: (context)=>MustahiqDetails(x)))
              Navigator.push(context, new MaterialPageRoute(builder: (context)=>MustahiqBantuan(x)))
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Image.network(
                      BaseUrl().image + x.photo,
                      // width: 300,
                      height: 150,
                      fit:BoxFit.fill

                  ),  
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Icon(Icons.person,
                            size: 18),
                          ),
                          Text(x.nama,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(" ( "+x.umur+" tahun )",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Icon(Icons.place,
                            size: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: c_width,
                              child: Text(x.alamat,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.today,
                            size: 16,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(x.tglSurvey),
                          ),
                          Expanded(child: Container(),),
                          // IconButton(
                          //   icon: Icon(Icons.place), 
                          //   onPressed: (){

                          //   }
                          // ),
                          ButtonTheme(
                            minWidth: 16.0,
                            height: 30.0,
                            child: RaisedButton(
                              onPressed: ()async {
                                  // final latlang = x.lokasi as Double;
                                  final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat";

                                  if (await canLaunch(googleMapsUrl)) {
                                    await launch(googleMapsUrl);
                                  }
                                  // if (await canLaunch(appleMapsUrl)) {
                                  //   await launch(appleMapsUrl, forceSafariVC: false);
                                  // } 
                                  else {
                                    throw "Couldn't launch URL";
                                  }
                                print("https://www.google.com/maps/search/?api=1&query=$lat");
                              },
                              child: Icon(Icons.place),
                              color: Colors.red,
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ButtonTheme(
                              minWidth: 16.0,
                              height: 30.0,
                              child: RaisedButton(
                                onPressed: (){
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //         builder: (context) => EditMustahiq(x, _lihatData)));
                                  Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => UpdateMustahiq(x, _lihatData)));
                                },
                                child: Text("Edit"),
                                color: Colors.blue,
                                ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  

}
