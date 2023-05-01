class Company {
  final int id;
  late final String name;
  late final String email;
  late final String description;
  late final String photo;
  late final String phone;
  late final String password;
  late final String website;
  late final String location;

  Company(
      {required this.id,
      required this.password,
      required this.phone,
      required this.name,
      required this.description,
      required this.email,
      required this.photo,
      required this.website,
      required this.location});

  static Company fromJson(json) => Company(
        id: json['id'],
        name: json['name'],
        password: json['password'],
        phone: json['phone'],
        description: json['description'],
        photo: json['photo'],
        email: json['email'],
        website: json['website'],
        location: json['location'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'website': website,
        'location': location,
        'password': password,
        'description': description,
        'phone': phone,
        'photo': photo,
      };
}
