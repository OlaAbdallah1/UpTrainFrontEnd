class Location {
  late String name;
  late int id;
  Location({required this.name, required this.id});

  static Location fromJson(json) => Location(name: json['locationName'], id: json['id']);

  @override
  toString() => 'Field: $name, $id';
}