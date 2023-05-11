class Field {
  late String name;
  late int id;
  Field({required this.name, required this.id});

  static Field fromJson(json) => Field(name: json['fName'], id: json['id']);

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
