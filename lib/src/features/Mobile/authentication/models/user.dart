class User {
  String email;
  String password;
  String firstName;
  String lastName;
  String phone;
  String picture;
  int field_id;
  String skills;


  User(
      {
      required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.picture,
      required this.field_id,
      required this.skills});

  static User fromJson(json) => User(
        firstName: json['firstName'],
        lastName: json['lastName'],
        phone: json['phone'],
        picture: json['picture'],
        field_id: json['field_id'],
        skills: json['skills'],
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phone': phone,
        'picture': picture,
        'field': field_id,
        'skills': skills
      };
}
