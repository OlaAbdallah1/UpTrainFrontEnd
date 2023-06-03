import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'task.dart';
class UserTasks {
  late final User user;
  late List<Task> tasks;

  UserTasks({required this.user, required this.tasks});
}
