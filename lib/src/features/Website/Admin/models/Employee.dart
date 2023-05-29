class Employee {
  String email;
 late String password;
  String first_name;
  String last_name;
  String field;
  late int field_id;
  late int location_id;
  String location;
  String phone;
  String photo;

  Employee(
      {required this.email,
      required this.first_name,
      required this.last_name,
      required this.field,
      required this.field_id,
      required this.phone,
      required this.photo,
      required this.location});

  static Employee fromJson(json) => Employee(
        first_name: json['first_name'],
        last_name: json['last_name'],
        field: json['fName'],
        field_id: json['field_id'],
        phone: json['ePhone_number'],
        photo: json['ePhoto'],
        email: json['email'],
        location: json['locationName'],
      );

  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'field': field,
        'field_id': field_id,
        'email': email,
        'password': password,
        'phone_number': phone,
        'photo': photo,
      };
}
