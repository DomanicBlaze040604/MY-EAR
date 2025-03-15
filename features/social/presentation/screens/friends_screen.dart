import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/friends_bloc.dart';
import '../widgets/friend_request_card.dart';
import '../widgets/friend_list_item.dart';
import '../../domain/entities/friend.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<FriendsBloc>().add(const LoadFriends());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Friends'),
            Tab(text: 'Requests'),
            Tab(text: 'Find Friends'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search friends...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onChanged: (value) {
                context.read<FriendsBloc>().add(
                  SearchFriends(searchQuery: value),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(),
                _buildFriendRequests(),
                _buildFindFriends(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFriendDialog();
        },
        child: const Icon(Icons.person_add),
        tooltip: 'Add Friend',
      ),
    );
  }

  Widget _buildFriendsList() {
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (context, state) {
        if (state is FriendsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FriendsLoaded) {
          final acceptedFriends =
              state.friends
                  .where((friend) => friend.status == FriendshipStatus.accepted)
                  .toList();

          if (acceptedFriends.isEmpty) {
            return const Center(
              child: Text('No friends yet. Start adding friends!'),
            );
          }

          return ListView.builder(
            itemCount: acceptedFriends.length,
            itemBuilder: (context, index) {
              return FriendListItem(
                friend: acceptedFriends[index],
                onTap: () => _showFriendOptions(acceptedFriends[index]),
              );
            },
          );
        }

        if (state is FriendsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFriendRequests() {
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (context, state) {
        if (state is FriendsLoaded) {
          final pendingRequests =
              state.friends
                  .where((friend) => friend.status == FriendshipStatus.pending)
                  .toList();

          if (pendingRequests.isEmpty) {
            return const Center(child: Text('No pending friend requests'));
          }

          return ListView.builder(
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              return FriendRequestCard(
                friend: pendingRequests[index],
                onAccept: () {
                  context.read<FriendsBloc>().add(
                    AcceptFriendRequest(friendId: pendingRequests[index].id),
                  );
                },
                onDecline: () {
                  context.read<FriendsBloc>().add(
                    DeclineFriendRequest(friendId: pendingRequests[index].id),
                  );
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFindFriends() {
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (context, state) {
        if (state is FriendsSearching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FriendsSearchResults) {
          return ListView.builder(
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final user = state.searchResults[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      user.avatar != null ? NetworkImage(user.avatar!) : null,
                  child:
                      user.avatar == null
                          ? Text(user.username[0].toUpperCase())
                          : null,
                ),
                title: Text(user.username),
                trailing: TextButton(
                  onPressed: () {
                    context.read<FriendsBloc>().add(
                      SendFriendRequest(userId: user.id),
                    );
                  },
                  child: const Text('Add Friend'),
                ),
              );
            },
          );
        }

        return const Center(
          child: Text('Search for friends using the search bar above'),
        );
      },
    );
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Friend'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Enter username or email',
              labelText: 'Username / Email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  context.read<FriendsBloc>().add(
                    SendFriendRequest(username: textController.text),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Send Request'),
            ),
          ],
        );
      },
    );
  }

  void _showFriendOptions(Friend friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Send Message'),
                onTap: () {
                  // Navigate to chat screen
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: Text(
                  friend.isFavorite
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                ),
                onTap: () {
                  context.read<FriendsBloc>().add(
                    ToggleFavoriteFriend(friendId: friend.id),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text(
                  'Block User',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  context.read<FriendsBloc>().add(
                    BlockFriend(friendId: friend.id),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
