class Branch {
  int id;
  final String name;

  Branch({
    required this.id,
    required this.name,
  });

  static Branch fromJson(json) =>
      Branch(id: json['id'].toInt(), name: json['bName']);

 

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

// class Branch {
//   final String name;

//   Branch({required this.name});

//   factory Branch.fromJson(Map json) {
//     return Branch(
//       name: json['name'],
//     );
//   }
// }
