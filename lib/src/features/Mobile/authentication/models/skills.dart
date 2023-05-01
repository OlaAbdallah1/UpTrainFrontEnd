class Skill {
  String name;

  int id;
  Skill({required this.name , required this.id});
  static Skill fromJson(json) => Skill(name: json['name'], id: json['id']);

  @override
  toString() => 'Skill: $id, $name';
  // toString() => ';
}
