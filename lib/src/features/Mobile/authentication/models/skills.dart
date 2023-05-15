class Skill {
  late String name;
  late int id;
  
  Skill({required this.name, required this.id});
  static Skill fromJson(json) => Skill(name: json['skName'], id: json['id']);

  Skill.fromMap(Map<String, dynamic> map) {
    name = map['skName'];
    id = map['id'];
  }

  @override
  toString() => 'Skill: $id, $name';
  // toString() => ';
}
