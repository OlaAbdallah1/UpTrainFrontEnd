import 'trainer.dart';

import '../../authentication/models/skills.dart';
import 'program.dart';

class ProgramSkills {
  late final Program program;
  late List<Skill> skills;
  // late final Trainer trainer;

  ProgramSkills({
    required this.program,
    required this.skills,
  });
}
