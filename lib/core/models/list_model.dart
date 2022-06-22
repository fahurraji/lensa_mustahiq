class list_model {
  int status;
  List<Result> result;

  list_model({this.status, this.result});

  list_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String id;
  String nama;
  String tempatLahir;
  String gender;
  String tglLahir;
  String alamat;
  String ulp;
  String statusRumah;
  String idpel;
  String statusNikah;
  String kondisi;
  String kondisiDesc;
  String pekerjaan;
  String penghasilan;
  String tanggungan;
  String kategoriMustahiq;
  String rekomendasi;
  String nilaiRekomend;
  String tglSurvey;
  String tglBantuan;
  String photo;
  String lokasi;
  String isApprove;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  String isDeleted;

  Result(
      {this.id,
      this.nama,
      this.tempatLahir,
      this.gender,
      this.tglLahir,
      this.alamat,
      this.ulp,
      this.statusRumah,
      this.idpel,
      this.statusNikah,
      this.kondisi,
      this.kondisiDesc,
      this.pekerjaan,
      this.penghasilan,
      this.tanggungan,
      this.kategoriMustahiq,
      this.rekomendasi,
      this.nilaiRekomend,
      this.tglSurvey,
      this.tglBantuan,
      this.photo,
      this.lokasi,
      this.isApprove,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.isDeleted});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    tempatLahir = json['tempat_lahir'];
    gender = json['gender'];
    tglLahir = json['tgl_lahir'];
    alamat = json['alamat'];
    ulp = json['ulp'];
    statusRumah = json['status_rumah'];
    idpel = json['idpel'];
    statusNikah = json['status_nikah'];
    kondisi = json['kondisi'];
    kondisiDesc = json['kondisi_desc'];
    pekerjaan = json['pekerjaan'];
    penghasilan = json['penghasilan'];
    tanggungan = json['tanggungan'];
    kategoriMustahiq = json['kategori_mustahiq'];
    rekomendasi = json['rekomendasi'];
    nilaiRekomend = json['nilai_rekomend'];
    tglSurvey = json['tgl_survey'];
    tglBantuan = json['tgl_bantuan'];
    photo = json['photo'];
    lokasi = json['lokasi'];
    isApprove = json['is_approve'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    data['tempat_lahir'] = this.tempatLahir;
    data['gender'] = this.gender;
    data['tgl_lahir'] = this.tglLahir;
    data['alamat'] = this.alamat;
    data['ulp'] = this.ulp;
    data['status_rumah'] = this.statusRumah;
    data['idpel'] = this.idpel;
    data['status_nikah'] = this.statusNikah;
    data['kondisi'] = this.kondisi;
    data['kondisi_desc'] = this.kondisiDesc;
    data['pekerjaan'] = this.pekerjaan;
    data['penghasilan'] = this.penghasilan;
    data['tanggungan'] = this.tanggungan;
    data['kategori_mustahiq'] = this.kategoriMustahiq;
    data['rekomendasi'] = this.rekomendasi;
    data['nilai_rekomend'] = this.nilaiRekomend;
    data['tgl_survey'] = this.tglSurvey;
    data['tgl_bantuan'] = this.tglBantuan;
    data['photo'] = this.photo;
    data['lokasi'] = this.lokasi;
    data['is_approve'] = this.isApprove;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['is_deleted'] = this.isDeleted;
    return data;
  }
}