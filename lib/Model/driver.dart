class Driver {
  String id;
  String name;
  String email;
  String address;
  String licenseNo;
  String dob;
  String regdate;
  String type;
  String rating;
  String lieasenceExpiryDate;
  String licensePlate;
  String insurance;
  String seatingCapacity;
  String carModel;
  String carMake;
  String flag;
  String devid;
  String vehicleSequenceNumber;
  String driverrefr;
  String veichref;
  String paymentType;
  String lastLogin;
  String lastLocUpdate;
  String lang;
  String devicetype;
  String city;
  String bankName;
  String ibanAccount;
  String surname;
  String tripOptions;
  String nationalId;
  String hijriDate;
  String stcPay;
  String deviceToken;
  String walletAmount;
  String driverLat;
  String driverLong;
  String phone;
  String carNo;
  String carType;
  String image;

  Driver(
      {this.id,
        this.name,
        this.email,
        this.address,
        this.licenseNo,
        this.dob,
        this.regdate,
        this.type,
        this.rating,
        this.lieasenceExpiryDate,
        this.licensePlate,
        this.insurance,
        this.seatingCapacity,
        this.carModel,
        this.carMake,
        this.flag,
        this.devid,
        this.vehicleSequenceNumber,
        this.driverrefr,
        this.veichref,
        this.paymentType,
        this.lastLogin,
        this.lastLocUpdate,
        this.lang,
        this.devicetype,
        this.city,
        this.bankName,
        this.ibanAccount,
        this.surname,
        this.tripOptions,
        this.nationalId,
        this.hijriDate,
        this.stcPay,
        this.deviceToken,
        this.walletAmount,
        this.driverLat,
        this.driverLong,
        this.phone,
        this.carNo,
        this.carType,
        this.image});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    licenseNo = json['license_no'];
    dob = json['dob'];
    regdate = json['regdate'];
    type = json['type'];
    rating = json['rating'];
    lieasenceExpiryDate = json['Lieasence_Expiry_Date'];
    licensePlate = json['license_plate'];
    insurance = json['Insurance'];
    seatingCapacity = json['Seating_Capacity'];
    carModel = json['Car_Model'];
    carMake = json['Car_Make'];
    flag = json['flag'];
    devid = json['devid'];
    vehicleSequenceNumber = json['vehicleSequenceNumber'];
    driverrefr = json['driverrefr'];
    veichref = json['veichref'];
    paymentType = json['payment_type'];
    lastLogin = json['last_login'];
    lastLocUpdate = json['Last_loc_update'];
    lang = json['Lang'];
    devicetype = json['Devicetype'];
    city = json['City'];
    bankName = json['bank_name'];
    ibanAccount = json['iban_account'];
    surname = json['surname'];
    tripOptions = json['trip_options'];
    nationalId = json['national_id'];
    hijriDate = json['hijri_date'];
    stcPay = json['stc_pay'];
    deviceToken = json['device_token'];
    walletAmount = json['wallet_amount'];
    driverLat = json['driver_lat'];
    driverLong = json['driver_long'];
    phone = json['phone'];
    carNo = json['car_no'];
    carType = json['car_type'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['license_no'] = this.licenseNo;
    data['dob'] = this.dob;
    data['regdate'] = this.regdate;
    data['type'] = this.type;
    data['rating'] = this.rating;
    data['Lieasence_Expiry_Date'] = this.lieasenceExpiryDate;
    data['license_plate'] = this.licensePlate;
    data['Insurance'] = this.insurance;
    data['Seating_Capacity'] = this.seatingCapacity;
    data['Car_Model'] = this.carModel;
    data['Car_Make'] = this.carMake;
    data['flag'] = this.flag;
    data['devid'] = this.devid;
    data['vehicleSequenceNumber'] = this.vehicleSequenceNumber;
    data['driverrefr'] = this.driverrefr;
    data['veichref'] = this.veichref;
    data['payment_type'] = this.paymentType;
    data['last_login'] = this.lastLogin;
    data['Last_loc_update'] = this.lastLocUpdate;
    data['Lang'] = this.lang;
    data['Devicetype'] = this.devicetype;
    data['City'] = this.city;
    data['bank_name'] = this.bankName;
    data['iban_account'] = this.ibanAccount;
    data['surname'] = this.surname;
    data['trip_options'] = this.tripOptions;
    data['national_id'] = this.nationalId;
    data['hijri_date'] = this.hijriDate;
    data['stc_pay'] = this.stcPay;
    data['device_token'] = this.deviceToken;
    data['wallet_amount'] = this.walletAmount;
    data['driver_lat'] = this.driverLat;
    data['driver_long'] = this.driverLong;
    data['phone'] = this.phone;
    data['car_no'] = this.carNo;
    data['car_type'] = this.carType;
    data['image'] = this.image;
    return data;
  }
}