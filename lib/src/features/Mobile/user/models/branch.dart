class Branch {
  final String title;

  Branch({
    required this.title,
  });

   static Branch fromJson(json) => Branch(title: json['name']);

  @override
  toString() => 'Branch: $title';

     Map<String, dynamic> toJson() => {
       'name':title,
      
      };
}

// class Branch {
//   final String title;

//   Branch({required this.title});

//   factory Branch.fromJson(Map json) {
//     return Branch(
//       title: json['title'],
//     );
//   }
// }
