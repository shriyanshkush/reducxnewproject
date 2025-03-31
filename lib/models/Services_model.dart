class ServicesModel {
  final int serviceId;
  final String serviceName;
  final String? imagePath;

  ServicesModel({
    required this.serviceId,
    required this.serviceName,
    this.imagePath,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      imagePath: json['imagePath'],
    );
  }
}