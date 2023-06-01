class User {
  late int id;
  late String email;
  late String password;
  late String firstName;
  late String lastName;
  late String location;
  late int location_id;
  late String phone;
  late String photo;
  late int field_id;
  late String skills;
  late String field;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.photo,
    required this.location,
    required this.location_id,
    required this.field_id,
    required this.field,
  });

  static User fromJson(json) {
    return User(
      id: json['id'].toInt(),
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['sPhone_number'],
      photo: json['sPhoto'],
      location: json['locationName'],
      location_id: json['location_id'],
      field_id: json['field_id'],
      email: json['email'],
      field: json['fName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phone': phone,
        'photo': photo,
        'field_id': field_id,
        'location_id': location_id,
      };
 
}
