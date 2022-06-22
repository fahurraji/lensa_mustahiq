import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:mustahiq_app/core/models/model_bantuan.dart';
import 'package:http/http.dart' as http;


class ListBantuan extends StatefulWidget {
  

  @override
  ListBantuanState createState() => ListBantuanState();
}

class ListBantuanState extends State<ListBantuan>{
  final list = new List<ModelBantuan>();
  var loading = false;
  void _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl().listBantuan);

    if(response.contentLength == 2) {

    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new ModelBantuan(
          api['id_mustahiq'], 
          api['nama'],
          api['nilai_rekomend'], 
          api['tgl_bantuan'], 
        );
        list.add(ab);
      });
      setState(() {
        // loading = false;
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
      appBar: AppBar(
        title: Text("List Bantuan", style: TextStyle(color: Colors.blue),),
      ),
       body: list.isEmpty ? Center(child: Text('No Data Available')) : ListView.builder(
         padding: const EdgeInsets.all(8.0),
         itemCount: list == null ? 0 : list.length,
         itemBuilder: (BuildContext context, int index) {
           final x = list[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: ListTile(
                leading: Icon (Icons.check_circle,color: Colors.blue,),
                title: Text(x.nama),
                subtitle: Text(x.nilaiRekomen),
                trailing: Text(x.tglBantuan),
              ),
            );
         },
      ),
    );
  }
}