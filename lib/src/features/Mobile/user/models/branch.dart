class Branch {
  final String name;

  Branch({
    required this.name,
  });

  static Branch fromJson(json) => Branch(name: json['bName']);

  @override
  toString() => 'Branch: $name';

  Map<String, dynamic> toJson() => {
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
