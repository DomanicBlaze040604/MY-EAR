import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/social_bloc.dart';
import '../widgets/post_card.dart';
import '../widgets/community_suggestions.dart';
import '../../../core/widgets/loading_indicator.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<SocialBloc>().add(const LoadSocialFeed());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SocialBloc>().add(const LoadMorePosts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
            },
            semanticLabel: 'Search posts and communities',
          ),
          IconButton(
            icon: const Icon(Icons.create),
            onPressed: () {
              // Navigate to create post screen
            },
            semanticLabel: 'Create new post',
          ),
        ],
      ),
      body: BlocBuilder<SocialBloc, SocialState>(
        builder: (context, state) {
          if (state is SocialInitial) {
            return const LoadingIndicator();
          }

          if (state is SocialError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is SocialLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SocialBloc>().add(const RefreshSocialFeed());
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  const SliverToBoxAdapter(child: CommunitySuggestions()),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = state.posts[index];
                      return PostCard(post: post);
                    }, childCount: state.posts.length),
                  ),
                  if (state.isLoading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LoadingIndicator(),
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create post screen
        },
        child: const Icon(Icons.add),
        tooltip: 'Create new post',
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
