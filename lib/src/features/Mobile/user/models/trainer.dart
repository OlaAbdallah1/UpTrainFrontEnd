class Trainer {
  String email;
  String password;
  String first_name;
  String last_name;
  String phone;
  String photo;
  String company;

  Trainer({
    required this.email,
    required this.password,
    required this.first_name,
    required this.last_name,
    required this.phone,
    required this.photo,
    required this.company,
  });

  static Trainer fromJson(json) => Trainer(
        first_name: json['first_name'],
        last_name: json['last_name'],
        phone: json['tPhone_number'],
        photo: json['tPhoto'],
        email: json['email'],
        password: json['password'],
        company: json['cName'],
      );

  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'password': password,
        'phone': phone,
        'photo': photo,
      };
}
