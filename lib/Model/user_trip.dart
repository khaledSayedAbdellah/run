class UserTrip {
  String id;
  String pickupArea;
  String driverImage;
  String dropArea;
  String pickupDateTime;
  String pickupLat;
  String pickupLong;
  String dropLat;
  String dropLong;
  String km;
  String approxTime;
  String departureDateTime;
  String status;
  String statusCode;
  String bookCreateDateTime;
  String amount;
  String tripPriceAfter;
  String finalAmount;
  String comment;
  DriverDetail driverDetail;

  UserTrip(
      {this.id,
        this.pickupArea,
        this.driverImage,
        this.dropArea,
        this.pickupDateTime,
        this.pickupLat,
        this.pickupLong,
        this.dropLat,
        this.dropLong,
        this.km,
        this.approxTime,
        this.departureDateTime,
        this.status,
        this.statusCode,
        this.bookCreateDateTime,
        this.amount,
        this.tripPriceAfter,
        this.finalAmount,
        this.comment,
        this.driverDetail});

  UserTrip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickupArea = json['pickup_area'];
    driverImage = json['driver_image'];
    dropArea = json['drop_area'];
    pickupDateTime = json['pickup_date_time'];
    pickupLat = json['pickup_lat'];
    pickupLong = json['pickup_long'];
    dropLat = json['drop_lat'];
    dropLong = json['drop_long'];
    km = json['km'];
    approxTime = json['approx_time'];
    departureDateTime = json['departure_date_time'];
    status = json['status'];
    statusCode = json['status_code'];
    bookCreateDateTime = json['book_create_date_time'];
    amount = json['amount'];
    tripPriceAfter = json['tripPriceAfter'];
    finalAmount = json['final_amount'];
    comment = json['comment'];
    driverDetail = json['driver_detail'] != null
        ? new DriverDetail.fromJson(json['driver_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pickup_area'] = this.pickupArea;
    data['driver_image'] = this.driverImage;
    data['drop_area'] = this.dropArea;
    data['pickup_date_time'] = this.pickupDateTime;
    data['pickup_lat'] = this.pickupLat;
    data['pickup_long'] = this.pickupLong;
    data['drop_lat'] = this.dropLat;
    data['drop_long'] = this.dropLong;
    data['km'] = this.km;
    data['approx_time'] = this.approxTime;
    data['departure_date_time'] = this.departureDateTime;
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['book_create_date_time'] = this.bookCreateDateTime;
    data['amount'] = this.amount;
    data['tripPriceAfter'] = this.tripPriceAfter;
    data['final_amount'] = this.finalAmount;
    data['comment'] = this.comment;
    if (this.driverDetail != null) {
      data['driver_detail'] = this.driverDetail.toJson();
    }
    return data;
  }
}

class DriverDetail {
  bool driverRate;
  String driverId;
  String driverName;
  String phone;
  String carNo;
  String carType;
  String driverimage;

  DriverDetail(
      {this.driverRate,
        this.driverId,
        this.driverName,
        this.phone,
        this.carNo,
        this.carType,
        this.driverimage});

  DriverDetail.fromJson(Map<String, dynamic> json) {
    driverRate = json['driver_rate'];
    driverId = json['driver_id'];
    driverName = json['driver_name'];
    phone = json['phone'];
    carNo = json['car_no'];
    carType = json['CarType'];
    driverimage = json['Driverimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_rate'] = this.driverRate;
    data['driver_id'] = this.driverId;
    data['driver_name'] = this.driverName;
    data['phone'] = this.phone;
    data['car_no'] = this.carNo;
    data['CarType'] = this.carType;
    data['Driverimage'] = this.driverimage;
    return data;
  }
}