// TODO Implement this library.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/friend.dart';

// Events
abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFriends extends FriendsEvent {
  const LoadFriends();
}

class SearchFriends extends FriendsEvent {
  final String searchQuery;

  const SearchFriends({required this.searchQuery});

  @override
  List<Object> get props => [searchQuery];
}

class SendFriendRequest extends FriendsEvent {
  final String? userId;
  final String? username;

  const SendFriendRequest({this.userId, this.username});

  @override
  List<Object?> get props => [userId, username];
}

class AcceptFriendRequest extends FriendsEvent {
  final String friendId;

  const AcceptFriendRequest({required this.friendId});

  @override
  List<Object> get props => [friendId];
}

class DeclineFriendRequest extends FriendsEvent {
  final String friendId;

  const DeclineFriendRequest({required this.friendId});

  @override
  List<Object> get props => [friendId];
}

class BlockFriend extends FriendsEvent {
  final String friendId;

  const BlockFriend({required this.friendId});

  @override
  List<Object> get props => [friendId];
}

class ToggleFavoriteFriend extends FriendsEvent {
  final String friendId;

  const ToggleFavoriteFriend({required this.friendId});

  @override
  List<Object> get props => [friendId];
}

// States
abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props =>