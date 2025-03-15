// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../domain/entities/friend.dart';

class FriendRequestCard extends StatelessWidget {
  final Friend friend;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const FriendRequestCard({
    Key? key,
    required this.friend,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  friend.friendAvatar != null
                      ? NetworkImage(friend.friendAvatar!)
                      : null,
              child:
                  friend.friendAvatar == null
                      ? Text(friend.friendUsername[0].toUpperCase())
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.friendUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Sent you a friend request',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: onAccept,
                  style: TextButton.styleFrom(foregroundColor: Colors.green),
                  child: const Text('Accept'),
                ),
                TextButton(
                  onPressed: onDecline,
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
