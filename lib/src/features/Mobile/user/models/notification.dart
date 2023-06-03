class UserNotification {
  int id;
  final String title;
  final String body;

  UserNotification({required this.id, required this.title, required this.body});

  static UserNotification fromJson(json) => UserNotification(
      id: json['id'].toInt(), title: json['title'], body: json['body']);

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body};
}
