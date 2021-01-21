class CarType {
  String cabId;
  String cartype;
  String carRate;
  String transfertype;
  String intialkm;
  String intailrate;
  String standardrate;
  String fromintialkm;
  String fromintailrate;
  String fromstandardrate;
  String nightFromintialkm;
  String nightFromintailrate;
  String extrahour;
  String extrakm;
  String timetype;
  String package;
  String nightPackage;
  String icon;
  String description;
  String rideTimeRate;
  String nightRideTimeRate;
  String daystarttime;
  String dayEndTime;
  String nightStartTime;
  String nightEndTime;
  String nightIntailrate;
  String nightStandardrate;
  String seatCapacity;

  CarType(
      {this.cabId,
        this.cartype,
        this.carRate,
        this.transfertype,
        this.intialkm,
        this.intailrate,
        this.standardrate,
        this.fromintialkm,
        this.fromintailrate,
        this.fromstandardrate,
        this.nightFromintialkm,
        this.nightFromintailrate,
        this.extrahour,
        this.extrakm,
        this.timetype,
        this.package,
        this.nightPackage,
        this.icon,
        this.description,
        this.rideTimeRate,
        this.nightRideTimeRate,
        this.daystarttime,
        this.dayEndTime,
        this.nightStartTime,
        this.nightEndTime,
        this.nightIntailrate,
        this.nightStandardrate,
        this.seatCapacity});

  CarType.fromJson(Map<String, dynamic> json) {
    cabId = json['cab_id'];
    cartype = json['cartype'];
    carRate = json['car_rate'];
    transfertype = json['transfertype'];
    intialkm = json['intialkm'];
    intailrate = json['intailrate'];
    standardrate = json['standardrate'];
    fromintialkm = json['fromintialkm'];
    fromintailrate = json['fromintailrate'];
    fromstandardrate = json['fromstandardrate'];
    nightFromintialkm = json['night_fromintialkm'];
    nightFromintailrate = json['night_fromintailrate'];
    extrahour = json['extrahour'];
    extrakm = json['extrakm'];
    timetype = json['timetype'];
    package = json['package'];
    nightPackage = json['night_package'];
    icon = json['icon'];
    description = json['description'];
    rideTimeRate = json['ride_time_rate'];
    nightRideTimeRate = json['night_ride_time_rate'];
    daystarttime = json['daystarttime'];
    dayEndTime = json['day_end_time'];
    nightStartTime = json['night_start_time'];
    nightEndTime = json['night_end_time'];
    nightIntailrate = json['night_intailrate'];
    nightStandardrate = json['night_standardrate'];
    seatCapacity = json['seat_capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cab_id'] = this.cabId;
    data['cartype'] = this.cartype;
    data['car_rate'] = this.carRate;
    data['transfertype'] = this.transfertype;
    data['intialkm'] = this.intialkm;
    data['intailrate'] = this.intailrate;
    data['standardrate'] = this.standardrate;
    data['fromintialkm'] = this.fromintialkm;
    data['fromintailrate'] = this.fromintailrate;
    data['fromstandardrate'] = this.fromstandardrate;
    data['night_fromintialkm'] = this.nightFromintialkm;
    data['night_fromintailrate'] = this.nightFromintailrate;
    data['extrahour'] = this.extrahour;
    data['extrakm'] = this.extrakm;
    data['timetype'] = this.timetype;
    data['package'] = this.package;
    data['night_package'] = this.nightPackage;
    data['icon'] = this.icon;
    data['description'] = this.description;
    data['ride_time_rate'] = this.rideTimeRate;
    data['night_ride_time_rate'] = this.nightRideTimeRate;
    data['daystarttime'] = this.daystarttime;
    data['day_end_time'] = this.dayEndTime;
    data['night_start_time'] = this.nightStartTime;
    data['night_end_time'] = this.nightEndTime;
    data['night_intailrate'] = this.nightIntailrate;
    data['night_standardrate'] = this.nightStandardrate;
    data['seat_capacity'] = this.seatCapacity;
    return data;
  }
}