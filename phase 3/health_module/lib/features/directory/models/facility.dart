class LocalHelper {
  final int id;
  final String district;
  final String village;
  final String helperType;
  final String name;
  final String phone;

  LocalHelper({
    required this.id,
    required this.district,
    required this.village,
    required this.helperType,
    required this.name,
    required this.phone,
  });

  factory LocalHelper.fromMap(Map<String, dynamic> map) {
    return LocalHelper(
      id: map['id'],
      district: map['district'] ?? '',
      village: map['village'] ?? '',
      helperType: map['helper_type'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}

class Facility {
  final int id;
  final String name;
  final String type;
  final String system;
  final String address;
  final String? phone;
  final String? workingHours;
  final int is24x7;
  final int emergencyServices;
  final int maternalServices;
  final int childImmunizationServices;

  Facility({
    required this.id,
    required this.name,
    required this.type,
    required this.system,
    required this.address,
    this.phone,
    this.workingHours,
    required this.is24x7,
    this.emergencyServices = 0,
    this.maternalServices = 0,
    this.childImmunizationServices = 0,
  });

  factory Facility.fromMap(Map<String, dynamic> map) {
    return Facility(
      id: map['facility_id'] ?? map['id'] ?? 0,
      name: map['facility_name'] ?? map['name'] ?? '',
      type: map['facility_type'] ?? map['type'] ?? '',
      system: map['system_of_medicine'] ?? map['system'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'],
      workingHours: map['working_hours'] ?? map['workingHours'],
      is24x7: map['is_24x7'] ?? map['is24x7'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'facility_id': id,
      'facility_name': name,
      'facility_type': type,
      'system_of_medicine': system,
      'address': address,
      'phone': phone,
      'working_hours': workingHours,
      'is_24x7': is24x7,
    };
  }
}
