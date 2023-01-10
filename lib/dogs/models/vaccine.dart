class Vaccine {
  final String id;
  final String administrationDate;
  final String expirationDate;
  String name;
  String type;

  Vaccine({
    required this.id,
    required this.administrationDate,
    required this.expirationDate,
    required this.name,
    required this.type,
  });

  Vaccine.fromJson(Map<String, dynamic> json)
      : id = json["id"]??'',
        administrationDate = json["administrationDate"],
        expirationDate = json["expirationDate"],
        name = json["name"],
        type = json["type"];

  Vaccine copyWith(
      {String? id,
      String? administrationDate,
      String? expirationDate,
      String? name,
      String? type}) {
    return Vaccine(
      id: id ?? this.id,
      administrationDate: administrationDate ?? this.administrationDate,
      expirationDate: expirationDate ?? this.expirationDate,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['administrationDate'] = administrationDate;
    json['expirationDate'] = expirationDate;
    json['name'] = name;
    json['type'] = type;
    return json;
  }

}
