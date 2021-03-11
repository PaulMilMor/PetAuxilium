class ReportModel {
  String id;
  String publicationid;
  List userid;
  String nreports;
  
  ReportModel(
      {this.id,
      this.publicationid,
      this.nreports,
      this.userid
      });

  ReportModel.fromJsonMap(Map<String, dynamic> json, String rid) {
    id = rid;
    publicationid = json['publicationid'];
    nreports = json['nreports'];
    userid = json['userid'];
    
  }
}