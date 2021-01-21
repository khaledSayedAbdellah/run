class City {
  String id;
  String name;
  String enName;

  City({this.id, this.name, this.enName});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    enName = json['en_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['en_name'] = this.enName;
    return data;
  }
}