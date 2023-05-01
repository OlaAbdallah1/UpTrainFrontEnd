class Collage {
  late String name;
  Collage({required this.name});

  static Collage fromJson(json) => Collage(name: json['name']);

  @override toString() => 'Collage: $name';
}
