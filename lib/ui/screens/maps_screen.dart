import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:mustahiq_app/main.dart';
import 'package:latlong/latlong.dart';
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:mustahiq_app/core/models/model_mustahiq.dart';
import 'package:http/http.dart' as http;


class MapsPage extends StatefulWidget {

  MapsPage({Key key}) : super(key: key);

  @override
  MapsPageState createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage>{
  var loading = false;
  final list = new List<Modelmustahiq>();

  // Future _lihatData() async {
  //   list.clear();
  //   setState(() {
  //     loading = true;
  //   });
  //   final response = await http.get(BaseUrl().listMustahiq);

  //   if(response.contentLength == 2) {

  //   } else {
  //     final data = jsonDecode(response.body);
  //     data.forEach((api) {
  //       final ab = new Modelmustahiq(
  //         api['id'], 
  //         api['nama'],
  //         api['tempatLahir'], 
  //         api['gender'], 
  //         api['tglLahir'], 
  //         api['alamat'],
  //         api['ulp'],
  //         api['statusRumah'], 
  //         api['idpel'],
  //         api['statusNikah'], 
  //         api['kondisi'],
  //         api['kondisiDesc'],
  //         api['pekerjaan'],
  //         api['penghasilan'], 
  //         api['tanggungan'],
  //         api['kategoriMustahiq'],
  //         api['rekomendasi'],
  //         api['nilaiRekomend'], 
  //         api['tglSurvey'],
  //         api['tglBantuan'],
  //         api['photo'],
  //         api['lokasi'],
  //         api['isApprove'],
  //         api['createdAt'],
  //         api['createdBy'],
  //         api['updatedAt'],
  //         api['updatedBy'],
  //         api['isDeleted']
  //       );
  //       list.add(ab);
  //     });
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  //  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _lihatData();
  // }

   
  
  @override
  Widget build(BuildContext context) {
    List<int> text = [1,2,3,4];
    return Scaffold(
      // appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: new FlutterMap(
        options: new MapOptions(
          center: LatLng(2.153957,117.501540),
          zoom: 13.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/1/1/0?",
            // urlTemplate: "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken' : 'pk.eyJ1IjoieWJtYmVyYXUiLCJhIjoiY2s3cG15ZWJzMG1lazNscGJhOGZ3NG80OCJ9.0EqZR-aBDtmSHqGnXHij9g',
              'id' : 'mapbox.streets',
              // 'id' : 'mapbox.mapbox-streets-v7'
            }
          ),
          MarkerLayerOptions(
            markers: [
              // List.generate(text.length, (index){
                Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(2.153957,117.501540),
                builder: (ctx)=>
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.place,color: Colors.red,), 
                      onPressed: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (builder){
                            return Container(
                              margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                              color: Colors.white,
                              height: 250,
                              
                            );
                          }
                        );
                      }
                    ),
                  )
                  // ),
                ),
              // },
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(2.153332,117.501640),
                builder: (ctx)=>
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.place,color: Colors.red,), 
                      onPressed: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (builder){
                            return Container(
                              margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                              color: Colors.white,
                              height: 250,
                              
                            );
                          }
                        );
                      }
                    ),
                  )
              )
            ]
          )
        ],
        
      )
    );
  }
}

