  
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:mustahiq_app/ui/widgets/datePicker.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';


class InsertMustahiq extends StatefulWidget {


  @override
  _InsertMustahiqState createState() => _InsertMustahiqState();
}

class _InsertMustahiqState extends State<InsertMustahiq> {
  String pilihTanggal, labelText;
  DateTime tglSurvey = new DateTime.now();
  final TextStyle valueStyle =TextStyle(fontSize: 16.0);
  DateTime tglLahir = new DateTime.now();
  Future<Null> _selectTglLahir(BuildContext context) async {
    final DateTime picked =  await showDatePicker(
      context: context, 
      initialDate: tglLahir, 
      firstDate: DateTime(1900), 
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != tglLahir) {
      setState(() {
        tglLahir = picked;
        pilihTanggal = new DateFormat.yMd().format(tglLahir);
      });
    } else {
    }
  }

  Future<Null> _selectTglSurvey(BuildContext context) async {
    final DateTime picked =  await showDatePicker(
      context: context, 
      initialDate: tglSurvey, 
      firstDate: DateTime(1900), 
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != tglSurvey) {
      setState(() {
        tglSurvey = picked;
        pilihTanggal = new DateFormat.yMd().format(tglSurvey);
      });
    } else {
    }
  }


  Position _currentPosition;
  bool _validate = false;
  bool _isLoading =false;
  File _image;
  final TextEditingController cNama = new TextEditingController();
  final TextEditingController cAlamat = new TextEditingController();
  final TextEditingController cGender = new TextEditingController();
  final TextEditingController cTptLahir = new TextEditingController();
  final TextEditingController cPekerjaan = new TextEditingController();
  final TextEditingController cPenghasilan = new TextEditingController();
  final TextEditingController cUlp = new TextEditingController();
  final TextEditingController cIdpel = new TextEditingController();
  final TextEditingController cTanggungan = new TextEditingController();
  final TextEditingController cNilai = new TextEditingController();

  String _myKategori,_myRumah,_myStatus,_myRekomendasi,_myKondisi, _myGenders, _myKategoriMus;
  // String _myRumah;
  final format = DateTime(1945,1,1);
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  // final String url ="http://192.168.43.197/lensa-mustahiq/beckend/kategori_list.php";

  List data = List(); //edited line

  List<Map> kategoriMus =[
    {"id": "1","kategori": "Fakir"},{"id": "2","kategori": "Miskin"},
    {"id": "3","kategori": "Amiz Zakat"},{"id": "4","kategori": "Muallaf"},
    {"id": "5","kategori": "Riqob"},{"id": "6","kategori": "Ghorim"},
    {"id": "7","kategori": "Fiisabilillah"},{"id": "8","kategori": "Ibnu Sabil"}
  ];

  List<Map> rumah = [
    {"id": "1","jenis": "Milik Sendiri"},
    {"id": "2","jenis": "Kost"},
    {"id": "3","jenis": "Kontrakan"},
    {"id": "4","jenis": "Lainnya"}
  ];

  List<Map> status =[
    {"id": "1","status": "Belum Menikah"},
    {"id": "2","status": "Menikah"},
    {"id": "3","status": "Janda / Duda"}
  ];

  List<Map> genders =[{"id":"1","gender":"Laki-laki"},{"id":"2","gender":"Perempuan"}];
  List<Map> kondisi =[
    {"id":"1","kondisi":"Sehat"},{"id":"2","kondisi":"Sakit"}
  ];

  List<Map> rekomendasi =[{"id":"1","rekomendasi":"Uang"},{"id":"2","rekomendasi":"Paket"},{"id":"3","rekomendasi":"Lainnya"}];

  @override
  void initState() {
    super.initState();
    // this.getKategory();
  }

  Future getImageGallery() async{
  var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

  // final tempDir =await getTemporaryDirectory();
  // final path = tempDir.path;

  // int rand= new Math.Random().nextInt(100000);

  // Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
  // Img.Image smallerImg = Img.copyResize(image, 500);

  // var compressImg= new File("$path/image_$rand.jpg")
  // ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));


  setState(() {
      // _image = compressImg;
      _image = imageFile;
    });
  }

  Future upload(File imageFile) async{
    var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length= await imageFile.length();
    // var uri = Uri.parse("http://192.168.43.197/lensa-mustahiq/beckend/mustahiq_add.php");
     var uri = Uri.parse(BaseUrl().insertMustahiq);

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("photo", stream, length, filename: basename(imageFile.path)); 
    request.fields['nama'] = cNama.text;
    request.fields['gender'] = _myGenders;
    request.fields['tempat_lahir'] = cTptLahir.text;
    // request.fields['tgl_lahir'] = _dateTime.toString();
    request.fields['tgl_lahir'] = "$tglLahir";
    request.fields['alamat'] = cAlamat.text;
    request.fields['ulp'] = cUlp.text;
    request.fields['idpel'] = cIdpel.text;
    request.fields['pekerjaan'] = cPekerjaan.text;
    request.fields['penghasilan'] = cPenghasilan.text;
    request.fields['tanggungan'] = cTanggungan.text;
    request.fields['kategori_mustahiq'] = _myKategoriMus;
    request.fields['status_rumah'] =_myRumah;
    request.fields['rekomendasi'] = _myRekomendasi;
    request.fields['kondisi'] = _myKondisi;
    request.fields['status_nikah'] = _myStatus;
    request.fields['nilai_rekomend'] = cNilai.text;
    request.fields['lokasi'] = _currentPosition.latitude.toString()+','+_currentPosition.longitude.toString();
    // request.fields['tgl_survey'] = _surveyDate.toString();
    request.fields['tgl_survey'] = "$tglSurvey";
    request.files.add(multipartFile); 

    var response = await request.send();

    if(response.statusCode==200){
      print("Image Uploaded");
    }else{
      print("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
  }

   @override
  void dispose() {
    cNama.dispose();
    cAlamat.dispose();
    cUlp.dispose();
    cIdpel.dispose();
    cPekerjaan.dispose();
    cTanggungan.dispose();
    cPenghasilan.dispose();
    super.dispose();
  }
  
  DateTime _dateTime, _surveyDate;

  

  _showSnackBar(message){
    final snackbar = SnackBar(content: Text(message),);
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150,
      child: Image.asset("./images/placeholder.png"),
    );


    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Lensa Mustahiq",
        style: TextStyle(color: Colors.blue),),
        // backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[  
              TextField(
                keyboardType: TextInputType.text,
                controller: cNama,
                decoration:new InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  hintText: "Nama",
                  errorText: _validate ? 'Data tidak Boleh Kosong' : null,
                ),
              ),
              SizedBox(
                width: 500,
                height: 60.0,
                child: DropdownButton<String>(
                hint: Text("Jenis Kelamin"),
                value: _myGenders,
                items: genders.map((Map map) {
                    return new DropdownMenuItem<String>(
                      value: map["id"].toString(),
                      child: new Text(
                        map["gender"],
                      ),
                    );
                  }).toList(),
                isExpanded: true,
                onChanged: (String newValue) {
                  setState(() {
                    _myGenders = newValue;
                  });
                  print (_myGenders);
                },
              ),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                controller: cAlamat,
                decoration:new InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  hintText: "Alamat",
                ),
              ),
              SizedBox(height: 6.0,),
              TextField(
                controller: cTptLahir,
                decoration:new InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  hintText: "Tempat Lahir",
                ),
              ),
              
              Row(
                children: <Widget>[
                  Container(
                    width: 170,
                    child: Text("Tanggal Lahir", style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),

                  Expanded(
                    child: DateDropdown(
                      labelText: labelText,
                      valueText: new DateFormat.yMd().format(tglLahir),
                      valueStyle: valueStyle,
                      onPressed: (){
                        _selectTglLahir(context);
                        print("$tglLahir");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0,),
              TextField(
                controller: cUlp,
                decoration:new InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  hintText: "ULP",
                ),
              ),
              SizedBox(
                width: 400.0,
                height: 60,
                child: DropdownButton<String>(
                  hint: Text("Status Tempat Tinggal"),
                  // isDense: true,
                  value: _myRumah,
                  
                  onChanged: (String newValue) {
                    setState(() {
                      _myRumah = newValue;
                    });
                    print (_myRumah);
                  },
                  items: rumah.map((Map map) {
                    return new DropdownMenuItem<String>(
                      value: map["id"].toString(),
                      child: new Text(
                        map["jenis"],
                      ),
                    );
                  }).toList(),
                  isExpanded: true,
                ),
              ),
              SizedBox(
                width: 400.0,
                height: 55,
                child: DropdownButton<String>(
                  hint: Text("Status Pernikahan"),
                  // isDense: true,
                  value: _myStatus,
                  onChanged: (String newValue) {
                    setState(() {
                      _myStatus = newValue;
                    });
                    print (_myStatus);
                  },
                  items: status.map((Map map) {
                    return new DropdownMenuItem<String>(
                      value: map["id"].toString(),
                      child: new Text(
                        map["status"],
                      ),
                    );
                  }).toList(),
                  isExpanded: true,
                ),
              ),
              SizedBox(
                width: 400.0,
                height: 55,
                child: DropdownButton<String>(
                  hint: Text("Kondisi Kesehatan"),
                  // isDense: true,
                  value: _myKondisi,
                  items: kondisi.map((Map map) {
                    return new DropdownMenuItem<String>(
                      value: map["id"].toString(),
                      child: new Text(
                        map["kondisi"],
                      )
                    );
                  }).toList(),
                  isExpanded: true, 
                  onChanged: (String newValue){
                    setState(() {
                      _myKondisi = newValue;
                    });
                    print (_myKondisi);
                  }
                ),
              ),
              TextField(
                controller: cIdpel,
                decoration:new InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  hintText: "IDPEL",
                ),
              ),
              SizedBox(height: 6.0,),
              TextField(
                controller: cPekerjaan,
                decoration:new InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  hintText: "Pekerjaan",
                ),
              ),
              SizedBox(height: 6.0,),
              TextField(
                keyboardType: TextInputType.number,
                controller: cPenghasilan,
                decoration:new InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  hintText: "Penghasilan",
                ),
              ),
              SizedBox(height: 8.0,),
              TextField(
                keyboardType: TextInputType.number,
                controller: cTanggungan,
                decoration:new InputDecoration(
                  hintText: "Tanggungan",
                ),
              ),
              
              SizedBox(
                width: 400.0,
                height: 55,
                  child: DropdownButton<String>(
                  hint: Text("Kategori Mustahiq"),
                  // isDense: true,
                  value: _myKategoriMus,
                  items: kategoriMus.map((Map map) {
                     return new DropdownMenuItem<String>(
                      value: map["id"].toString(),
                      child: new Text(
                        map["kategori"],
                      )
                    );
                  }).toList(),
                  isExpanded: true,
                  onChanged: (newValue){
                    setState(() {
                      _myKategoriMus = newValue;
                    });
                    print(_myKategoriMus);
                  },
                  
                ),
              ),
              SizedBox(
                width: 400.0,
                height: 55,
                  child: DropdownButton<String>(
                  hint: Text("Rekomendasi Bantuan Berupa"),
                  // isDense: true,
                  value: _myRekomendasi,
                  items: rekomendasi.map((Map map) {
                     return new DropdownMenuItem<String>(
                      value: map["id"].toString(),
                      child: new Text(
                        map["rekomendasi"],
                      )
                    );
                  }).toList(),
                  isExpanded: true,
                  onChanged: (newValue){
                    setState(() {
                      _myRekomendasi = newValue;
                    });
                    print(_myRekomendasi);
                  },
                  
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: cNilai,
                decoration:new InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  hintText: "Nilai Bantuan",
                ),
              ),
              SizedBox(height: 8.0,),
              Row(
                children: <Widget>[
                  Container(
                    width: 170,
                    child: Text("Tanggal Survey", style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: DateDropdown(
                      labelText: labelText,
                      valueText: new DateFormat.yMd().format(tglSurvey),
                      valueStyle: valueStyle,
                      onPressed: (){
                        _selectTglSurvey(context);
                        print("$tglSurvey");
                      },
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: _image == null ? placeholder: Image.file(_image, fit: BoxFit.fill,),
                ),
              ),           
              RaisedButton(
                    child: Icon(Icons.image),
                    onPressed: getImageGallery,
                  ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_currentPosition != null)
                    Text(
                        "${_currentPosition.latitude}, ${_currentPosition.longitude}"),
                  FlatButton(
                    color: Colors.red,
                    child: Text("Get location",),
                    onPressed: () {
                      _getCurrentLocation();
                      print(_currentPosition);
                      print(_currentPosition.latitude);
                      print(_currentPosition.longitude);
                    },
                  ),
                ],
              ),
              Container(
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child:                     
                    new RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      onPressed: (){
                        // upload(_image);
                        setState(() {
                          _validasi();
                          upload(_image);
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Save Data", style: TextStyle(color: Colors.white, letterSpacing: 3),),
                    ),
                  ),
             
             
            ],
          ),
        ),
      ),
    );
  }

_validasi(){
    cNama.text.isEmpty? _validate = true : _validate = false;
    cAlamat.text.isEmpty? _validate = true : _validate = false;
    cTptLahir.text.isEmpty? _validate = true : _validate = false;
    cPekerjaan.text.isEmpty? _validate = true : _validate = false;
    cPenghasilan.text.isEmpty? _validate = true : _validate = false;
    cTanggungan.text.isEmpty? _validate = true : _validate = false;
    cUlp.text.isEmpty? _validate = true : _validate = false;
    cIdpel.text.isEmpty? _validate = true : _validate = false;
    cNilai.text.isEmpty? _validate = true : _validate = false;
  }

  
_getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
         setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

}


