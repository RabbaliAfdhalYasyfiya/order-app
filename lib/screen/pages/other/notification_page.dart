import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../widget/button.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  List<Map<String, dynamic>> notifications = [];

  Future<void> _fetchNotifications() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('time', descending: true)
        .get();
    setState(() {
      notifications = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: ButtonBack(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: const Text('Notification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/Mobile testing-bro.svg',
                        height: 175,
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        'No notifications found.',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification = notifications[index];
                    return ListTile(
                      title: Text(notification['title']),
                      subtitle: Text(notification['message']),
                      trailing: Text(
                        (notification['time'] as Timestamp).toDate().toString(),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
