class UserMaster {
  String? username;
  String? password;
  bool active;
  int userId;
  int? locationId;
  String? mobileNumber;
  String? contactPerson;
  String? emailId;
  DateTime? createdOn;
  DateTime? updatedOn;
  int countyId;
  int municipalityId;
  String? countyName;
  String? municipalityName;

  UserMaster({
    this.username,
    this.password,
    required this.active,
    required this.userId,
    this.locationId,
    this.mobileNumber,
    this.contactPerson,
    this.emailId,
    this.createdOn,
    this.updatedOn,
    required this.countyId,
    required this.municipalityId,
    this.countyName,
    this.municipalityName,
  });

  /// Convert JSON to UserMaster object
  factory UserMaster.fromJson(Map<String, dynamic> json) {
    return UserMaster(
      username: json['username'],
      password: json['password'],
      active: json['active'] ?? false,
      userId: json['userId'],
      locationId: json['locationId'],
      mobileNumber: json['mobileNumber'],
      contactPerson: json['contactPerson'],
      emailId: json['emailId'],
      createdOn: json['createdOn'] != null ? DateTime.parse(json['createdOn']) : null,
      updatedOn: json['updatedOn'] != null ? DateTime.parse(json['updatedOn']) : null,
      countyId: json['countyId'],
      municipalityId: json['municipalityId'],
      countyName: json['countyName'],
      municipalityName: json['municipalityName'],
    );
  }

  /// Convert UserMaster object to JSON
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "active": active,
      "userId": userId,
      "locationId": locationId,
      "mobileNumber": mobileNumber,
      "contactPerson": contactPerson,
      "emailId": emailId,
      "createdOn": createdOn?.toIso8601String(),
      "updatedOn": updatedOn?.toIso8601String(),
      "countyId": countyId,
      "municipalityId": municipalityId,
      "countyName": countyName,
      "municipalityName": municipalityName,
    };
  }
}
