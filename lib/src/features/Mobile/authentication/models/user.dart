class User {
  String email;
  String password;
  String firstName;
  String lastName;
  String phone;
  String picture;
  int field;
  String skills;

  int id;

  User(
      {required this.id,
      required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.picture,
      required this.field,
      required this.skills});

  static User fromJson(json) => User(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phone: json['phone'],
        picture: json['picture'],
        field: json['field'],
        skills: json['skills'],
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phone': phone,
        'picture': picture,
        'field': field,
        'skills': skills
      };
}
