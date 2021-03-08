import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  final Key key;
  final String message;
  final String sender;

  ChatMessageBubble(this.message, this.sender, {this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isSelf = sender == FirebaseAuth.instance.currentUser.uid;

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(sender).get(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final userData = snapshot.data;
          return Row(
            mainAxisAlignment:
                _isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    margin: EdgeInsets.only(
                      top: 15.0,
                      bottom: 4.0,
                      left: _isSelf ? 20.0 : 8.0,
                      right: _isSelf ? 8.0 : 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: _isSelf
                          ? Colors.grey[300]
                          : Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                        bottomLeft: _isSelf
                            ? Radius.circular(12.0)
                            : Radius.circular(0.0),
                        bottomRight: _isSelf
                            ? Radius.circular(0.0)
                            : Radius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: _isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isSelf ? Colors.black : Theme.of(context).accentTextTheme.headline1.color,
                          ),
                        ),
                        Text(
                          message,
                          style: TextStyle(
                            color: _isSelf
                                ? Colors.black
                                : Theme.of(context)
                                    .accentTextTheme
                                    .headline1
                                    .color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 0.0,
                      right: _isSelf ? null : 0.0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userData['imageUrl']),
                      ),
                    ),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
