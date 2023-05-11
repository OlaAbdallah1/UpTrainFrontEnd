class Company {
  late final String name;
  late final String email;
  late final String description;
  late final String photo;
  late final String password;
  late final String website;
  late final String location;

  Company(
      {
      // required this.password,
      // required this.phone,
      required this.name,
      required this.description,
      required this.email,
      required this.photo,
      required this.website,
      required this.location});

  static Company fromJson(json) => Company(
        name: json['cName'],
        // password: json['cPassword'],
        // phone: json['cPhone'],
        description: json['cDescription'],
        photo: json['cPhoto'],
        email: json['cEmail'],
        website: json['cWebSite'],
        location: json['cLocation'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'webSite': website,
        'location': location,
        // 'password': password,
        'description': description,
        // 'phone': phone,
        'photo': photo,
      };
}
