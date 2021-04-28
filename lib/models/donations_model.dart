class DonationModel {
  String id;
  String name;
  String description;
  String img;
  String website;

  DonationModel({
    this.id,
    this.name,
    this.description,
    this.img,
    this.website,
  });

  DonationModel.fromJsonMap(Map<String, dynamic> json, String id) {
    this.id = id;
    name = json['name'];
    description = json['description'];
    img = json['img'];
    website = json['website'];
  }
}
