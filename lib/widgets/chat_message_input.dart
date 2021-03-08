import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessageInput extends StatefulWidget {
  @override
  _ChatMessageInputState createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  final TextEditingController _messageController = TextEditingController();
  String _message = '';

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('chat').add({
      'text': _message,
      'sentAt': Timestamp.now(),
      'userId': user.uid,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Nova mensagem...',
              ),
              onChanged: (value) => setState(() => _message = value),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
