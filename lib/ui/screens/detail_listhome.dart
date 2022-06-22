 import 'package:flutter/material.dart';
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:mustahiq_app/core/models/model_mustahiq.dart';

 
class MustahiqDetail extends StatefulWidget {
  Modelmustahiq modelMustahiq;
  MustahiqDetail(this.modelMustahiq);

  @override
  _MustahiqDetailState createState() => _MustahiqDetailState();
}

class _MustahiqDetailState extends State<MustahiqDetail>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lensa Mustahiq"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10,top: 10,right: 10,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  BaseUrl().insertMustahiq + widget.modelMustahiq.photo,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5,),
            Text(
              widget.modelMustahiq.nama,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 5,),
            Text(
            widget.modelMustahiq.alamat,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(height: 5,),
            Text(
            widget.modelMustahiq.idpel,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal
              ),
            ),
          ],
        ),
      ),
    );

  }
}