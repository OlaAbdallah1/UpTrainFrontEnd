class Company {
  late String name;
  late String email;
  late String description;
  late String photo;
  late String password;
  late String website;
  late String location;
  late int location_id;
  late String phone;

  Company(
      {
      // required this.password,
      required this.phone,
      required this.name,
      required this.description,
      required this.email,
      required this.photo,
      required this.website,
      required this.location});

  static Company fromJson(json) => Company(
        name: json['cName'],
        // password: json['cPassword'],
        phone: json['cPhone_number'],
        description: json['cDescription'],
        photo: json['cPhoto'],
        email: json['cEmail'],
        website: json['cWebSite'],
        location: json['locationName'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'webSite': website,
        'location_id': location_id,
        // 'password': password,
        'description': description,
        'phone': phone,
        'photo': photo,
      };
}
