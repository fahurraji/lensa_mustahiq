import 'dart:io';
import 'dart:math';
// import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:mustahiq_app/core/models/model_mustahiq.dart';
import 'package:mustahiq_app/ui/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mustahiq_app/ui/widgets/form_label.dart';
import 'package:mustahiq_app/ui/widgets/radio_button.dart';
import 'package:mustahiq_app/ui/widgets/capitalize.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:material_dropdown_formfield/material_dropdown_formfield.dart';
import 'package:mustahiq_app/ui/widgets/datePicker.dart';



class AddMustahiq extends StatefulWidget {
  
  @override
  _AddMustahiqState createState() => _AddMustahiqState();
}

class _AddMustahiqState extends State<AddMustahiq>{
  DateTime tgllahir;
  String pilihTanggal, labelText;
  DateTime tglApprove = new DateTime.now();
  final TextStyle valueStyle =TextStyle(fontSize: 16.0);
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked =  await showDatePicker(
      context: context, 
      initialDate: tglApprove, 
      firstDate: DateTime(1990), 
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != tglApprove) {
      setState(() {
        tglApprove = picked;
        pilihTanggal = new DateFormat.yMd().format(tglApprove);
      });
    } else {
    }
  }


  String _myActivity;
  String _myActivityResult;
  FocusNode focusNode = FocusNode();
  
  File _imageFile;
  String id, nama, tempatlahir, gender, tglLahir, alamat, ulp, statusRumah, idpel, statusNikah, kondisi, kondisiDesc, pekerjaan, penghasilan,
tanggungan, kategoriMustahiq, rekomendasi, nilairekomend, tglSurvey, tglBantuan, photo, lokasi, isApprove, createdAt,
createdBy, updatedAt, updatedBy, isDeleted;
  final _key = new GlobalKey<FormState>();

  _pilihGalery() async{
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
      setState((){
        _imageFile = image;
      });
    }

  check(){
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      submit();
    }
  }

  submit() async {
    try {
      // _myActivityResult = _myActivity;
      var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl().insertMustahiq);
      var request = http.MultipartRequest("POST",uri);
      // request.files.add(http.MultipartFile.fromBytes("photo",,filename:path.basename(_imageFile.path) ));
      request.files.add( http.MultipartFile("photo", stream, length, filename: path.basename(_imageFile.path)));

      request.fields['nama']= nama;
      request.fields['gender']= gender;
      request.fields['tempat_lahir']= tempatlahir;
      request.fields['alamat']= alamat;
      request.fields['ulp']= ulp;
      request.fields['idpel']= idpel;
      request.fields['pekerjaan']= pekerjaan;
      request.fields['penghasilan']= penghasilan;
      request.fields['tanggungan']= tanggungan;
      request.fields['nilai_rekomend']= nilairekomend;
      request.fields['kategori_mustahiq'] = kategoriMustahiq;
      // request.fields['tgl_bantuan'] = "$tglApprove";

      var response =  await request.send();

      if(response.statusCode> 2){
        print("Image Upload");
        setState(() {
          Navigator.pop(context);
        });
      }else {
        print("Failed Upload Image");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // gender = 'pria';
    getPref();
  }

  List dataSource=[
    {
      "display": "Belum Menikah",
      "value": 1,
    },
    {
      "display": "Menikah",
      "value": 2,
    },
    {
      "display": "Janda / Duda",
      "value": 3,
    },
  ];

  String _valSelectedJK = "L"; 

  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    
    var placeholder = Container(
      width: double.infinity,
      height: 150,
      child: Image.asset("./images/placeholder.png"),
    );

    

    return Scaffold(
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
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              onSaved: (e)=>nama=e,
              decoration: InputDecoration(
                labelText: 'Nama'
              ),
            ),
           
            TextFormField(
              onSaved: (e)=>gender=e,
              decoration: InputDecoration(
                labelText: 'Gender'
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     new Text("Gender"),
            //     new Radio(
            //       value: 1, 
            //       groupValue: null, 
            //       onChanged: null
            //     ),
            //     new Text("Pria"),
            //     new Radio(value: 2, groupValue: null, onChanged: null),
            //     new Text("Wanita")
                
            //   ],
            // ),
            TextFormField(
              onSaved: (e)=>tempatlahir=e,
              decoration: InputDecoration(
                labelText: 'Tempat Lahir'
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('Tanggal Lahir'),
            ),
            DateTimeField(
              format: format,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
            TextFormField(
              onSaved: (e)=>alamat=e,
              decoration: InputDecoration(
                labelText: 'Alamat'
              ),
            ),
            TextFormField(
              onSaved: (e)=>ulp=e,
              decoration: InputDecoration(
                labelText: 'ULP'
              ),
            ),
            
            // new DropdownButton(
            //   hint: Text('Status Rumah'),
            //   items: rumahList,
            //   value: _selectedRumah,
            //   onChanged: (value){
            //     setState(() {
            //       print(value);
            //       _selectedRumah =value;
            //     });
            //   },
            //   isExpanded: true,
            // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownFormField(
                // innerBackgroundColor: Colors,
                wedgeIcon: Icon(Icons.keyboard_arrow_down),
                wedgeColor: Colors.lightBlue,
                innerTextStyle: TextStyle(color: Colors.blue),
                focusNode: focusNode,
                inputDecoration: OutlinedDropDownDecoration(
                    labelStyle: TextStyle(color: Colors.blue),
                    labelText: "Status Pernikahan ",
                    borderColor: Colors.purple),
                hintText: 'Pilih status pernikahan',
                value: _myActivity,
                onSaved: (value) {
                  setState(() {
                    _myActivity = value;
                  });
                },
                onChanged: (String value) {
                  setState(() {
                    _myActivity = value;
                  });
                },
                dataSource: dataSource,
                textField: 'display',
                valueField: 'value',
            ),
              ),
            TextFormField(
              onSaved: (e)=>idpel=e,
              decoration: InputDecoration(
                labelText: 'IDPEL'
              ),
            ),
            TextFormField(
              onSaved: (e)=>pekerjaan=e,
              decoration: InputDecoration(
                labelText: 'Pekerjaan'
              ),
            ),
            TextFormField(
              onSaved: (e)=>penghasilan=e,
              decoration: InputDecoration(
                labelText: 'Penghasilan'
              ),
            ),
            TextFormField(
              onSaved: (e)=>tanggungan=e,
              decoration: InputDecoration(
                labelText: 'Tanggungan'
              ),
            ),
            
            TextFormField(
              onSaved: (e)=>nilairekomend=e,
              decoration: InputDecoration(
                labelText: 'Nilai Rekomendasi'
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('Tanggal Survey'),
            ),
            DateTimeField(
              format: format,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100)
                  );                    
              },
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 150, 
              child : InkWell(
                onTap: (){
                  _pilihGalery();
                },  
                child: _imageFile == null ? placeholder: Image.file(_imageFile, fit: BoxFit.fill,),
              ),
            ),
            
            DateDropdown(
              labelText: labelText,
              valueText: new DateFormat.yMd().format(tglApprove),
              valueStyle: valueStyle,
              onPressed: (){
                _selectDate(context);
                print("$tglApprove");
              },
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  width: 80,
                  child: Text("gender"),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: DropdownButton(items: [
                      DropdownMenuItem(
                        value: "L",
                        child: Text("Laki-Laki"),
                      ),DropdownMenuItem(
                        value: "P",
                        child: Text("Perempuan"),
                      ),],
                    value: _valSelectedJK,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ), onChanged: (String newValue) {
                      setState(() {
                        _valSelectedJK = newValue;
                      });
                    },isDense: false,),
                  )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  check();
                },
                child:Text("SIMPAN DATA"),
                color: Colors.blue,
                ),
            ), 
          ],
        ),
      ),
    
    );
  }
}