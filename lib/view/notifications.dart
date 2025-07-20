import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('created_at', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty)
            return const Center(child: Text('Belum ada notifikasi'));

          return ListView(
            children:
                docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return ListTile(
                    leading: Icon(
                      data['type'] == 'booking_success'
                          ? Icons.check_circle
                          : Icons.timer,
                      color: Colors.amber,
                    ),
                    title: Text(data['title'] ?? ''),
                    subtitle: Text(data['body'] ?? ''),
                    onTap: () => doc.reference.update({'read': true}),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
