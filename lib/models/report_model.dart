class ReportModel {
  String id;
  String publicationid;
  List userid;
  num nreports;
  num nspam;
  num nfalseinfo;
  num nidentityfraud;
  num nbadphotos;


  ReportModel({this.id, this.publicationid, this.nreports,this.nspam,this.nfalseinfo,this.nidentityfraud,this.nbadphotos, this.userid});

  ReportModel.fromJsonMap(Map<String, dynamic> json, String rid) {
    id = rid;
    publicationid = json['publicationid'];
    nreports = json['nreports'];
    userid = json['userid'];
    nspam = json['nspam'];
    nfalseinfo = json['nfalseinfo'];
    nidentityfraud = json['nidentityfraud'];
    nbadphotos = json['nbadphotos'];
  }
}
