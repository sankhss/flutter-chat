import 'package:chat/widgets/chat_message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('sentAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> documents = chatSnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (ctx, i) => ChatMessageBubble(
            documents[i].get('text'),
            documents[i].get('userId'),
            key: ValueKey(documents[i].id),
          ),
        );
      },
    );
  }
}
