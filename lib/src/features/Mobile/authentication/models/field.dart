class Field {
  late String name;
  String collage;
  int id;
  String employee;
  Field(
      {required this.name,
      required this.id,
      required this.collage,
      required this.employee});

  static Field fromJson(json) => Field(
      name: json['fName'],
      id: json['id'],
      collage: json['collegeName'],
      employee: json['first_name'] + ' ' + json['last_name']);

  @override
  toString() => 'Field: $name, $id';
}

// class Field {
//   final String name;
//   final int id;

//   Field({
//     required this.name,
//     required this.id,
//   });

//   factory Field.fromJson(Map<String, dynamic> json) {
//     return Field(
//       name: json['name'],
//       id: json['id'],
//     );
//   }
// }
