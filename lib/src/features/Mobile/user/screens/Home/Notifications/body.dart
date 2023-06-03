import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/notification.dart';

class Body extends StatefulWidget {
  List<UserNotification> notifications = [];
  Body({super.key, required this.notifications});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.notifications.length,
      itemBuilder: (context, index) {
        UserNotification notification = widget.notifications[index];
        return ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.body),
        );
      },
    );
  }
}
