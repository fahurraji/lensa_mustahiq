import 'package:mustahiq_app/core/models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MustahiqProvider extends ChangeNotifier {
  List<list_model> _data = [];
  List<list_model> get dataMustahiq => _data;

  Future<List<list_model>> getMustahiq() async {
    final url = 'http://rizkymediatama.com/trial/beckend/mutahiq_list.php';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      _data = result.map<list_model>((json) => list_model.fromJson(json)).toList();
      return _data;
    } else {
      throw Exception();
    }
  }

  //ADD DATA
  Future<bool> storeMustahiq(String nama, String gender, String alamat, String tptlahir, String tgllahir, String ulp, String statusrumah, String idpel, String statusnikah, String kondisi, String kondesc, String kerja, String hasil, String tanggung,String kategori, String rekomen,String bantuan, String tglsurvey, String tglbantu, String photo, String lokasi ) async {
    final url = 'http://rizkymediatama.com/trial/beckend/mutahiq_create.php';
    final response = await http.post(url, body: {
      'nama': nama,
      'gender': gender,
      'alamat': alamat,
      'tempat_lahir' : tptlahir,
      'tgl_lahir' : tgllahir,
      'ulp' : ulp,
      'status_rumah' : statusrumah,
      'idpel' : idpel,
      'status_nikah' : statusnikah,
      'kondisi' : kondisi,
      'kondisi_desc' : kondesc,
      'pekerjaan' : kerja,
      'penghasilan' : hasil,
      'tanggungan' : tanggung,
      'kategori_mustahiq' : kategori,
      'rekomendasi' : rekomen,
      'nilai_rekomend' : bantuan,
      'tgl_survey' : tglsurvey,
      'tgl_bantuan' : tglbantu,
      'photo' : photo,
      'lokasi' : lokasi
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 ) {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<list_model> findMustahiq(String id) async {
    return _data.firstWhere((i) => i.status == id);
  }

  Future<bool> updateMustahiq(id, nama, gender, alamat, tptlahir, tgllahir, ulp, statusrumah, idpel, statusnikah, kondisi, kondesc, kerja, hasil, tanggung,kategori, rekomen,nilaibantu, tglsurvey, tglbantu, photo, lokasi) async {
    final url = 'http://rizkymediatama.com/trial/beckend/mutahiq_update.php';
    final response = await http.post(url, body: {
      'id': id,
      'nama': nama,
      'gender': gender,
      'alamat': alamat,
      'tempat_lahir' : tptlahir,
      'tgl_lahir' : tgllahir,
      'ulp' : ulp,
      'status_rumah' : statusrumah,
      'idpel' : idpel,
      'status_nikah' : statusnikah,
      'kondisi' : kondisi,
      'kondisi_desc' : kondesc,
      'pekerjaan' : kerja,
      'penghasilan' : hasil,
      'tanggungan' : tanggung,
      'kategori_mustahiq' : kategori,
      'rekomendasi' : rekomen,
      'nilai_rekomend' : nilaibantu,
      'tgl_survey' : tglsurvey,
      'tgl_bantuan' : tglbantu,
      'photo' : photo,
      'lokasi' : lokasi
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['status'] == 'success') {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> deleteMustahiq(String id) async {
    final url = 'http://rizkymediatama.com/trial/beckend/mutahiq_deleted.php';
    await http.get(url + '?id=$id');
  }
}