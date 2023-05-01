class Trainer {
  String email;
  String password;
  String first_name;
  String last_name;
  String phone;
  String photo;
  int company_id;

  Trainer({
    required this.email,
    required this.password,
    required this.first_name,
    required this.last_name,
    required this.phone,
    required this.photo,
    required this.company_id,
  });

  static Trainer fromJson(json) => Trainer(
        first_name: json['first_name'],
        last_name: json['last_name'],
        phone: json['phone'],
        photo: json['photo'],
        email: json['email'],
        password: json['password'],
        company_id: json['company_id'],
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
