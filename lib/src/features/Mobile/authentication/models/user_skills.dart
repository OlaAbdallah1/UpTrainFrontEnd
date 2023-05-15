import 'skills.dart';

import 'user.dart';

class UserSkills {
  final User user;
  late List<Skill> skills;

  UserSkills({required this.user, required this.skills});
}