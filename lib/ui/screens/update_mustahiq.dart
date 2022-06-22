import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mustahiq_app/core/models/model_mustahiq.dart';
import 'package:mustahiq_app/core/config/constanFile.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mustahiq_app/ui/widgets/datePicker.dart';


class UpdateMustahiq extends StatefulWidget {
  final Modelmustahiq model;
  final VoidCallback reload;

  UpdateMustahiq(this.model, this.reload);
  

  // const UpdateMustahiq({Key key, this.model}) : super(key: key);

  
  @override
  _UpdateMustahiqState createState() => _UpdateMustahiqState();
}

class _UpdateMustahiqState extends State<UpdateMustahiq> {
  Position _currentPosition;
  final _key = new GlobalKey<FormState>();
  String id, nama, tempatLahir, gender, alamat, ulp, statusRumah, idpel, statusNikah, kondisiDesc, pekerjaan, penghasilan,
tanggungan, kategoriMustahiq, nilaiRekomend, tglSurvey, tglBantuan, photo, lokasi, isApprove, createdAt,
createdBy, updatedAt, updatedBy, isDeleted;

  bool _validate = false;
  String _myKategori,_myRumah,_myStatus,_myRekomendasi,_myKondisi, _myGenders, _myKategoriMus, _genders;
  // String _myRumah;
  final format = DateTime(1945,1,1);
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final String url ="http://192.168.43.197/lensa-mustahiq/beckend/kategori_list.php";

  List data = List(); //edited l

   File _imageFile;
  _pilihGalery() async{
    var image = await ImagePicker.pickImage(
    source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
    setState((){
      _imageFile = image;
    });
  }
  
  TextEditingController txtNama, txttempatLahir, txtgender, txttglLahir, txtalamat, txtulp, txtstatusRumah,
     txtidpel, txtstatusNikah, txtkondisi, txtkondisiDesc, txtpekerjaan, txtpenghasilan, txttanggungan, txtkategoriMustahiq,
     txtrekomendasi, txtnilaiRekomend, txttglSurvey, txttglBantuan, txtphoto, txtlokasi, txtisApprove, txtcreatedAt, txtcreatedBy,
     txtupdatedAt, txtupdatedBy, txtisDeleted;

     
  String tgl_lahir, klm;
  setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
    });
    tgl_lahir = widget.model.tglLahir;
    klm = widget.model.gender;
    txtNama = TextEditingController(text: widget.model.nama);
    txtalamat = TextEditingController(text: widget.model.alamat);
    txtidpel = TextEditingController(text: widget.model.idpel);
    txtulp = TextEditingController(text: widget.model.ulp);
    txttempatLahir= TextEditingController(text: widget.model.tempatLahir);
    txtgender = TextEditingController(text: widget.model.gender);
    txtpekerjaan = TextEditingController(text: widget.model.pekerjaan);
    txtpenghasilan = TextEditingController(text: widget.model.penghasilan);
    txttanggungan = TextEditingController(text: widget.model.tanggungan);
    txtnilaiRekomend = TextEditingController(text: widget.model.nilaiRekomend);
    txtlokasi =TextEditingController(text: widget.model.lokasi);
    // txtidpel = TextEditingController(text: widget.model.idpel);
    // txtulp = TextEditingController(text: widget.model.idpel);
    txttglLahir = TextEditingController(text : widget.model.tglLahir);
    // _valSelectedJK = widget.model.gender.toString();
  }


  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      editData(_imageFile);
      updateData();
    } else {

    }
  }
  


  String pilihTanggal, labelText;
  DateTime tglLahir = new DateTime.now();
  var formatLahir = new DateFormat('yyyy-MM-dd');
  final TextStyle valueStyle =TextStyle(fontSize: 16.0);
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
        // pilihTanggal = new DateFormat.yMd().format(tglLahir);
       tgl_lahir = formatLahir.format(tglLahir);
      });
    } else {
      tgl_lahir = widget.model.tglLahir;
      // tgl_lahir = "$tglLahir";
    }
  }

  void updateData(){
    var url = BaseUrl().rubah;
    http.post(url, body:{
      'id' : widget.model.id,
      'nama' : txtNama.text,
      'gender' : _valSelectedJK,
      'tempat_lahir' : txttempatLahir.text,
      'tgl_lahir' : "$tglLahir",
      'alamat' : txtalamat.text,
      'status_rumah' : _selectRumah,
      'status_nikah' : _selectStatus,
      'ulp' : txtulp.text,
      'idpel' : txtidpel.text,
      'kondisi' : _selectedKondisi,
      'pekerjaan' : txtpekerjaan.text,
      'penghasilan' : txtpenghasilan.text,
      'tanggungan' : txttanggungan.text,
      'kategori_mustahiq' : _selectKategory,
      'rekomendasi' : _selectRekomend,
      'nilai_rekomend' : txtnilaiRekomend.text,
      'lokasi' : txtlokasi.text
    });
  }

  Future editData(File imageFile) async{
    var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length= await imageFile.length();
    // var uri = Uri.parse("http://192.168.43.197/lensa-mustahiq/beckend/mustahiq_update.php");
    var uri = Uri.parse(BaseUrl().gambar);

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("photo", stream, length, filename: path.basename(imageFile.path)); 
      request.fields['id'] = widget.model.id;
      // request.fields['nama'] = txtNama.text;
      // request.fields['gender'] = _valSelectedJK;
      // request.fields['tempat_lahir'] = txttempatLahir.text;
      // request.fields['tgl_lahir'] = "$tglLahir";
      // request.fields['alamat'] = txtalamat.text;
      // request.fields['status_rumah'] = _selectRumah;
      // request.fields['status_nikah'] = _selectStatus;
      // request.fields['ulp'] = txtulp.text;
      // request.fields['idpel'] = txtidpel.text;
      // request.fields['kondisi'] = _selectedKondisi;
      // request.fields['pekerjaan'] = txtpekerjaan.text;
      // request.fields['penghasilan'] = txtpenghasilan.text;
      // request.fields['tanggungan'] = txttanggungan.text;
      // request.fields['kategori_mustahiq'] = _selectKategory;
      // request.fields['rekomendasi'] = _selectRekomend;
      // request.fields['nilai_rekomend'] = txtnilaiRekomend.text;
      // request.fields['lokasi'] = txtlokasi.text;
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
    void initState() {
      // TODO: implement initState
      super.initState();
      // selectGenders=jnskelamin[0];
      // _valSelectedJK = widget.model.gender.toString();
      setup();
    }

  @override
  void dispose() {
    txtNama.dispose();
    txtalamat.dispose();
    txttempatLahir.dispose();
    txtulp.dispose();
    txtidpel.dispose();
    txtpekerjaan.dispose();
    txtpenghasilan.dispose();
    txttanggungan.dispose();
    txtnilaiRekomend.dispose();
    super.dispose();
  }

  DateTime _dateTime, _surveyDate;
  String _valSelectedJK ='1';
  String _selectedKondisi ='1';
  String _selectStatus ='1';
  String _selectKategory ='1';
  String _selectRumah = '1'; 
  String _selectRekomend = '1';


  @override
  Widget build(BuildContext context) {

    var placeholder = Container(
      width: double.infinity,
      height: 150,
      child: Image.asset("./images/placeholder.png"),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Lensa Mustahiq", style: TextStyle(color: Colors.blue),),
          ],
        ),
      ),
      body: Form(
    
        key: _key,
        
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: <Widget>[
           
            TextFormField(
              controller: txtNama,
                onSaved: (e)=>nama=e,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  errorText: _validate ? "Nama Tidak Boleh Kosong" :null,
                ),
              ),
                    
              Row(
              children: <Widget>[
                Container(
                  // alignment: Alignment.topRight,
                  width: 120,
                  child: Text("Gender", style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey, 
                  ),),
                ),
                SizedBox(width: 40,),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: DropdownButton(items: [
                      DropdownMenuItem(
                        value: '1',
                        child: Text("Laki-Laki"),
                      ),DropdownMenuItem(
                        value: '2',
                        child: Text("Perempuan"),
                      ),],
                    value: _valSelectedJK,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ), onChanged: (String newValue) {
                      setState(() {
                        _valSelectedJK = newValue;
                        print(_valSelectedJK);
                      });
                    },isDense: false,
                    isExpanded: true,
                    ),
                  )
                ),
              ],
            ),

              TextFormField(
                controller: txttempatLahir,
                onSaved: (e)=>tempatLahir=e,
                decoration: InputDecoration(
                  labelText: 'Tempat Lahir',
                  errorText: _validate ? "Tidak Boleh Kosong" :null,
                ),
              ),
              
              DateDropdown(
                labelText: labelText,
                valueText: tgl_lahir,
                valueStyle: valueStyle,
                onPressed: (){
                  _selectTglLahir(context);
                  print("$tglLahir");
                },
              ),

              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                controller: txtalamat,
                onSaved: (e)=>alamat=e,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  errorText: _validate ? "Tidak Boleh Kosong" :null,
                ),
              ),
              TextFormField(
                controller: txtulp,
                onSaved: (e)=>ulp=e,
                decoration: InputDecoration(
                  labelText: 'ULP',
                  errorText: _validate ? "Tidak Boleh Kosong" :null,
                ),
              ),
            
              Row(
              children: <Widget>[
                Container(
                  // alignment: Alignment.topRight,
                  width: 170,
                  child: Text("Status Tempat Tinggal", style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey 
                  ),),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: DropdownButton(items: [
                      DropdownMenuItem(
                        value: '1',
                        child: Text("Milik Sendiri"),
                      ),DropdownMenuItem(
                        value: '2',
                        child: Text("Kost"),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text("Kontrakan"),
                      ),DropdownMenuItem(
                        value: '4',
                        child: Text("Lainnya"),
                      ),
                    ],
                    value: _selectRumah,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ), onChanged: (String newValue) {
                      setState(() {
                        _selectRumah = newValue;
                        print(_selectRumah);
                      });
                    },isDense: false,
                    isExpanded: true,
                      ),
                    )
                  ),
                ],
              ),

              Row(
              children: <Widget>[
                Container(
                  // alignment: Alignment.topRight,
                  width: 170,
                  child: Text("Status Pernikahan", style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: DropdownButton(items: [
                      DropdownMenuItem(
                        value: '1',
                        child: Text("Belum Menikah"),
                      ),DropdownMenuItem(
                        value: '2',
                        child: Text("Menikah"),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text("Janda/Duda"),
                      ),
                    ],
                    value: _selectStatus,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ), onChanged: (String newValue) {
                      setState(() {
                        _selectStatus = newValue;
                        print(_selectStatus);
                      });
                    },isDense: false,
                    isExpanded: true,
                      ),
                    )
                  ),
                ],
              ),

              Row(
              children: <Widget>[
                Container(
                  width: 150,
                  child: Text("Kondisi Kesehatan", style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey, 
                  ),),
                ),
                SizedBox(width: 40,),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: DropdownButton(items: [
                      DropdownMenuItem(
                        value: '1',
                        child: Text("Sehat"),
                      ),DropdownMenuItem(
                        value: '2',
                        child: Text("Sakit"),
                      ),],
                    value: _selectedKondisi,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ), onChanged: (String newValue) {
                      setState(() {
                        _selectedKondisi = newValue;
                        print(_selectedKondisi);
                      });
                    },isDense: false,
                    isExpanded: true,
                      ),
                    )
                  ),
                ],
              ),

              TextFormField(
                controller: txtidpel,
                onSaved: (e)=>idpel=e,
                decoration: InputDecoration(
                  labelText: 'IDPEL',
                  errorText: _validate ? "Tidak Boleh Kosong" :null,
                ),
              ),
              TextFormField(
                controller: txtpekerjaan,
                onSaved: (e)=>pekerjaan=e,
                decoration: InputDecoration(
                  labelText: 'Pekerjaan',
                  errorText: _validate ? "Tidak Boleh Kosong" :null,
                ),
              ),
              TextFormField(
                controller: txtpenghasilan,
                onSaved: (e)=>penghasilan=e,
                decoration: InputDecoration(
                  labelText: 'Penghasilan',
                  errorText: _validate ? "Tidak Boleh Kosong" :null,
                ),
              ),
              TextFormField(
                controller: txttanggungan,
                onSaved: (e)=>tanggungan=e,
                decoration: InputDecoration(
                  labelText: 'Tanggungan',
                  errorText: _validate ? "Tidak Boleh Kosong" :null,
                ),
              ),
          
              Row(
              children: <Widget>[
                Container(
                  width: 150,
                  child: Text("Kategori Mustahiq", style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey, 
                  ),),
                ),
                SizedBox(width: 40,),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: DropdownButton(items: [
                      DropdownMenuItem(
                        value: '1',
                        child: Text("Fakir"),
                      ),DropdownMenuItem(
                        value: '2',
                        child: Text("Miskin"),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text("Amil Zakat"),
                      ),DropdownMenuItem(
                        value: '4',
                        child: Text("Muallaf"),
                      ),
                      DropdownMenuItem(
                        value: '5',
                        child: Text("Riqob"),
                      ),DropdownMenuItem(
                        value: '6',
                        child: Text("Ghorim"),
                      ),
                      DropdownMenuItem(
                        value: '7',
                        child: Text("Fisabilillah"),
                      ),DropdownMenuItem(
                        value: '8',
                        child: Text("Ibnu Sabil"),
                      ),
                    ],
                    value: _selectKategory,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ), onChanged: (String newValue) {
                      setState(() {
                        _selectKategory = newValue;
                        print(_selectKategory);
                      });
                    },
                    isDense: false,
                    isExpanded: true,
                      ),
                    )
                  ),
                ],
              ),

              Row(
              children: <Widget>[
                Container(
                  width: 150,
                  child: Text("Kondisi Kesehatan", style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),),
                ),
                SizedBox(width: 40,),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: DropdownButton(items: [
                      DropdownMenuItem(
                        value: '1',
                        child: Text("Uang"),
                      ),DropdownMenuItem(
                        value: '2',
                        child: Text("Paket"),
                      ),DropdownMenuItem(
                        value: '3',
                        child: Text("Lainnya"),
                      ),
                    ],
                    value: _selectRekomend,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ), onChanged: (String newValue) {
                      setState(() {
                        _selectRekomend = newValue;
                        print(_selectRekomend);
                      });
                    },isDense: false,
                    isExpanded: true,
                      ),
                    )
                  ),
                ],
              ),

              TextFormField(
                controller: txtnilaiRekomend,
                onSaved: (e)=>nilaiRekomend=e,
                decoration: InputDecoration(
                  labelText: 'Nilai Rekomendasi',
                  errorText: _validate ? "Tidak Boleh Kosong" :null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 150, 
                  child : InkWell(
                    onTap: (){
                      _pilihGalery();
                    },  
                    child: _imageFile == null ? Image.network(BaseUrl().image +widget.model.photo):
                    Image.file(_imageFile, fit: BoxFit.fill,)
                  ),
                ),
              ),
              TextFormField(
                controller: txtlokasi,
                onSaved: (e)=>lokasi=e,
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  errorText: _validate ? "Tidak Boleh Kosong" :null,
                ),
              ),
             
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      // check();
                      updateData();
                      editData(_imageFile);
                      _validasi();
                      widget.reload();
                    });
                    Navigator.pop(context);
                  },
                  child:Text("SIMPAN DATA"),
                  ),
              ),
          ],
        ),
      ),
    );
  }

  _validasi(){
    txtNama.text.isEmpty? _validate = true : _validate = false;
    txtalamat.text.isEmpty? _validate = true : _validate = false;
    txttempatLahir.text.isEmpty? _validate = true : _validate = false;
    txtulp.text.isEmpty? _validate = true : _validate = false;
    txtidpel.text.isEmpty? _validate = true : _validate = false;
    txtpenghasilan.text.isEmpty? _validate = true : _validate = false;
    txtpekerjaan.text.isEmpty? _validate = true : _validate = false;
    txttanggungan.text.isEmpty? _validate = true : _validate = false;
    txtnilaiRekomend.text.isEmpty? _validate = true : _validate = false;
  }

  _validation(e){
    if(!e.contains("")){
      return "Field tidak boleh kosong";
    }else{
      return null;
    }
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

