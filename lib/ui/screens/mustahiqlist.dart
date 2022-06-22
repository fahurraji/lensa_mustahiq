import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:mustahiq_app/core/models/auth_model.dart';
import 'package:mustahiq_app/core/models/model_mustahiq.dart';
import 'package:http/http.dart' as http;
import 'package:mustahiq_app/ui/screens/add_mustahiq.dart';
import 'package:mustahiq_app/ui/screens/detail_listhome.dart';
import 'package:mustahiq_app/ui/screens/edit_mustahiq.dart';


class Mustahiqlist extends StatefulWidget {
  @override
  _MustahiqlistState createState() => _MustahiqlistState();
}

class _MustahiqlistState extends State<Mustahiqlist> {
  var daftar;
  var loading = false;
  final list = new List<Modelmustahiq>();

  
  
  // Future<String> _lihatData() async{
  //   list.clear();
  //   setState(() {
  //     loading=true;
  //   });
  //   final response = await http.get(BaseUrl().listMustahiq);

  //   if(response.contentLength==2){
  //     // return;
  //   }else{
  //     final data = jsonDecode(response.body)["results"];
  //     data.forEach((api){
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
  //         );
  //         list.add(ab);
  //     });
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  _delete(String id) async{
    final response = await http.post(BaseUrl().deleteMustahiq, body: {
      "id": id });
    final data = jsonDecode(response.body);
    int status = data['status'];
    String pesan = data['message'];
    if(status == 200){
      _lihatData();
    } else{
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  void getData() async {
    var data = await _lihatData();

    setState(() {
      daftar = data['results'];
    });
  }

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMustahiq()));
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: (){
          _lihatData();
        },
        child: loading ? Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: daftar == null ? 0 : daftar.length,
          itemBuilder: (context, i){
            final x = daftar[i];
            return InkWell(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (contex) => MustahiqDetail(x)));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(BaseUrl().insertMustahiq + x.photo,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(x.nama, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                              Text(x.alamat, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),

                            ],
                          )
                        ),
                        IconButton(
                          icon: Icon(Icons.edit) , 
                          onPressed: (){
                            print('edit');
                          }
                        ),
                        IconButton(
                          icon: Icon(Icons.delete) , 
                          onPressed: (){
                            _delete(x.id);
                          } 
                        )
                      ],
                    ),
                    SizedBox(height: 5,),
                      Divider(
                        color: Colors.pink,
                        height: 1,
                        thickness: 2,
                    ),
                  ],
                ),
              ),
            );
          })
      ),
    );
  }
}

Future<Map> _lihatData() async {
    var url =
        'http://rizkymediatama.com/lensa-mustahiq/beckend/mustahiq_list.php';
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }