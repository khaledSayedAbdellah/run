class Bid {
  String id;
  String driverName;
  String driverPhoto;
  String driverID;
  String price;

  Bid({this.id, this.driverName, this.driverPhoto, this.driverID, this.price});

  Bid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverName = json['DriverName'];
    driverPhoto = json['DriverPhoto'];
    driverID = json['DriverID'];
    price = json['Price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['DriverName'] = this.driverName;
    data['DriverPhoto'] = this.driverPhoto;
    data['DriverID'] = this.driverID;
    data['Price'] = this.price;
    return data;
  }
}