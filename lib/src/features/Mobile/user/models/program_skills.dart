import '../../authentication/models/skills.dart';
import 'program.dart';

class ProgramSkills {
  late final Program program;
  late List<Skill> skills;

  ProgramSkills({required this.program, required this.skills});

  // factory ProgramSkills.fromJson(json) {
    
  //   return ProgramSkills(program: Program.fromJson(json),
  //   skills: Skill.fromJson(json) 
  //   );
  // }
}
