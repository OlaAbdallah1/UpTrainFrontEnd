class Admin {
  String email;
  String password;
  String first_name;
  String last_name;
  String field;
  String phone;
  String photo;

  Admin({
    required this.email,
    required this.password,
    required this.first_name,
    required this.last_name,
    required this.field,
    required this.phone,
    required this.photo,
  });

  static Admin fromJson(json) => Admin(
        first_name: json['first_name'],
        last_name: json['last_name'],
        field: json['field'],
        phone: json['phone'],
        photo: json['photo'],
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'field': field,
        'email': email,
        'password': password,
        'phone': phone,
        'photo': photo,
      };
}
