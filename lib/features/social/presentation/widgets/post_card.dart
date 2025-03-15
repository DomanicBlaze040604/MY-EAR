import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            Text(post.content, style: Theme.of(context).textTheme.bodyLarge),
            if (post.mediaUrls.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildMediaPreview(),
            ],
            const SizedBox(height: 8),
            _buildTags(),
            const SizedBox(height: 8),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            'https://api.multiavatar.com/${post.userId}.png',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                timeago.format(post.createdAt),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Show post options
          },
        ),
      ],
    );
  }

  Widget _buildMediaPreview() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: post.mediaUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(post.mediaUrls[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      children:
          post.tags
              .map(
                (tag) => Chip(
                  label: Text('#$tag'),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
              .toList(),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          icon: Icons.thumb_up_outlined,
          label: '${post.likes}',
          onPressed: () {
            // Like post
          },
        ),
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          label: '${post.comments}',
          onPressed: () {
            // Open comments
          },
        ),
        _buildActionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onPressed: () {
            // Share post
          },
        ),
        _buildActionButton(
          icon: Icons.bookmark_border,
          label: 'Save',
          onPressed: () {
            // Save post
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
