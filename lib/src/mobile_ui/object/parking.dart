import 'package:google_maps_flutter/google_maps_flutter.dart';

class Parking {
  late String name;
  late String number;
  late String street;
  late String ward;
  late String district;
  late String city;
  late LatLng geocoor;

  Parking(this.name, this.number, this.street, this.ward, this.district,
      this.city, this.geocoor);

  String address() {
    return [number, street, ward, district].join(', ');
  }
}

Marker fromParking(Parking p) {
  return Marker(
    markerId: MarkerId(p.name),
    position: p.geocoor,
    infoWindow: InfoWindow(title: p.name + '-' + p.district),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );
}

List<Parking> ParkingList = [
  Parking('BKU', '268', 'Ly Thuong Kiet', 'ward 14', 'district 10',
      'Ho Chi Minh city', const LatLng(10.7733743, 106.6606193)),
  Parking('Home', '529/16', 'Nguyen Tri Phuong', 'ward 8', 'district 10',
      'Ho Chi Minh city', const LatLng(10.766627, 106.666779)),
  Parking('DamSen', '262', 'Lac Long Quan', 'ward 5', 'district 11',
      'Ho Chi Minh city', const LatLng(10.766933, 106.642352)),
  Parking(
      'BKU2',
      'undefined',
      'Ta Quang Buu',
      'ward Linh Trung',
      'district Thu Duc',
      'Ho Chi Minh city',
      const LatLng(10.8798973, 106.8041259)),
  Parking('HCMUS', '227', 'Nguyen Van Cu', 'ward 4', 'district 5',
      'Ho Chi Minh city', const LatLng(10.762913, 106.6821717)),
  Parking('USSH', '10-12', 'Dinh Tien Hoang', 'ward Ben Nghe', 'district 1',
      'Ho Chi Minh city', const LatLng(10.7858607, 106.7005199)),
  Parking('FTU2', '15', 'D5', 'ward 25', 'district Binh Thanh',
      'Ho Chi Minh city', const LatLng(10.8069083, 106.7108633)),
  Parking('ThaoDien', '12', 'Quoc Huong', 'ward Thao Dien', 'district Thu Duc',
      'Ho Chi Minh city', const LatLng(10.8069466, 106.7314277)),
  Parking('UFM', '27', 'Tan My', 'ward Tan Thuan Tay', 'district 7',
      'Ho Chi Minh city', const LatLng(10.75297, 106.7106211)),
  Parking('NTTU', '300A', 'Nguyen Tat Thanh', 'ward 13', 'district 4',
      'Ho Chi Minh city', const LatLng(10.7653318, 106.7032414)),
];

class ParkingLotStatus {
  String slot;
  String day;
  String night;
  String allday;

  ParkingLotStatus(
      {this.slot = '0', this.day = '0', this.night = '0', this.allday = '0'});

  factory ParkingLotStatus.fromJson(Map<String, dynamic> json) {
    return ParkingLotStatus(
        slot: json['availableSlot'],
        day: json['day_price'],
        night: json['night_price']);
  }
}

class ParkingStatus {
  String parkingName;
  String address;
  String lot;
  String license;
  String fee;

  ParkingStatus(
      this.parkingName, this.address, this.lot, this.license, this.fee);

  factory ParkingStatus.fromJson(Map<String, dynamic> json) {
    return ParkingStatus(
      json['parkName'],
      json['address'],
      json['blockName'],
      json['carPlateNumber'],
      json['spent'],
    );
  }
}
