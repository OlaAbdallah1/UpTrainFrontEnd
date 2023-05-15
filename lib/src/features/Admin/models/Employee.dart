class Employee {
  String email;
  late String password;
  String first_name;
  String last_name;
  late String field;
  String phone;
  String photo;

  Employee({
    required this.email,
    required this.first_name,
    required this.last_name,
    // required this.field,
    required this.phone,
    required this.photo,
  });

  static Employee fromJson(json) => Employee(
        first_name: json['first_name'],
        last_name: json['last_name'],
        // field: json['field'],
        phone: json['ePhone_number'],
        photo: json['ePhoto'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        // 'field': field,
        'email': email,
        'password': password,
        'phone_number': phone,
        'photo': photo,
      };

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      email: map['email'],
      first_name: map['first_name'],
      last_name: map['last_name'],
      phone: map['ePhone_number'],
      photo: map['ePhoto'],
    );
  }
}
