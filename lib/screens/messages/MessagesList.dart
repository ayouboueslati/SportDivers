import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/Provider/ChatProvider/ChatRoomsProvider.dart';
import 'package:sportdivers/Provider/UserProvider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/models/ChatModel.dart';
import 'package:sportdivers/models/user_model.dart';
import 'package:sportdivers/Provider/ChatProvider/usersChat.dart';
import 'package:sportdivers/screens/Service/SocketService.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'chat_screen.dart';

class MessagesList extends StatefulWidget {
  static String id = 'friend_screen';
  final String role;

  const MessagesList({Key? key, required this.role}) : super(key: key);

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  late SocketService _socketService;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _socketService = Provider.of<SocketService>(context, listen: false);
    _initializeSocket();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatRoomsProvider>(context, listen: false).fetchChatRooms();
    });
  }

  void _initializeSocket() async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final token = authProvider.token;
    if (token != null) {
      _socketService.connect(token);
      _setupSocketListeners();
    } else {
      print('No token available. Unable to connect to socket.');
    }
  }

  void _setupSocketListeners() {
    SocketService.socket?.on('new-message', (data) {
      // Handle new message event
      Provider.of<ChatRoomsProvider>(context, listen: false).fetchChatRooms();
    });

    SocketService.socket?.on('user-status-changed', (data) {
      // Handle user status change event
      Provider.of<usersChatProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  void dispose() {
    SocketService.socket?.off('new-message');
    SocketService.socket?.off('user-status-changed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => usersChatProvider()..fetchUsers(),
      child: Scaffold(
        backgroundColor: DailozColor.white,
        // appBar: AppBar(
        //   leading: Padding(
        //     padding: const EdgeInsets.all(10),
        //     child: InkWell(
        //       splashColor: DailozColor.transparent,
        //       highlightColor: DailozColor.transparent,
        //       onTap: () {
        //         Navigator.pop(context);
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(5),
        //             color: DailozColor.white,
        //             boxShadow: const [
        //               BoxShadow(color: DailozColor.textgray, blurRadius: 5)
        //             ]
        //         ),
        //         child: const Padding(
        //           padding: EdgeInsets.only(left: 8),
        //           child: Icon(
        //             Icons.arrow_back_ios,
        //             size: 18,
        //             color: DailozColor.black,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        //   title: const Text(
        //     'Chats',
        //     style: TextStyle(
        //       color: DailozColor.black,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 22,
        //     ),
        //   ),
        //   backgroundColor: DailozColor.white,
        //   elevation: 0,
        // ),
        body: Consumer2<usersChatProvider, SocketService>(
          builder: (context, userProvider, socketService, child) {
            if (userProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (userProvider.errorMessage.isNotEmpty) {
              return Center(child: Text('Erreur: ${userProvider.errorMessage}'));
            } else if (userProvider.users.isNotEmpty ||
                userProvider.groups.isNotEmpty) {
              List<User> filteredUsers = _filterUsers(userProvider.users);
              List<Group> filteredGroups = _filterGroups(userProvider.groups);

              return Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            cursorColor: DailozColor.black,
                            style: const TextStyle(fontSize: 16, color: DailozColor.black),
                            decoration: InputDecoration(
                              hintText: 'Rechercher une discussion',
                              filled: true,
                              fillColor: DailozColor.bggray,
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 22,
                                color: DailozColor.grey,
                              ),
                              hintStyle: const TextStyle(fontSize: 16, color: DailozColor.textgray),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                        //const SizedBox(width: 10),
                        // Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(14),
                        //       color: DailozColor.bggray,
                        //     ),
                        //     child: const Padding(
                        //       padding: EdgeInsets.all(13),
                        //       child: Icon(Icons.filter_list, color: DailozColor.grey),
                        //     )
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length + filteredGroups.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < filteredUsers.length) {
                          final User user = filteredUsers[index];
                          return _buildChatItem(context, user);
                        } else {
                          final Group group = filteredGroups[index - filteredUsers.length];
                          return _buildGroupItem(context, group);
                        }
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Aucun utilisateur ou groupe trouvé'));
            }
          },
        ),
      ),
    );
  }

  List<User> _filterUsers(List<User> users) {
    List<User> filteredUsers = users.where((user) {
      if (widget.role == 'TEACHER') {
        return user.type == 'student';
      } else if (widget.role == 'STUDENT') {
        return user.type == 'teacher';
      }
      return false;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) =>
          '${user.firstName} ${user.lastName}'.toLowerCase().contains(_searchQuery)
      ).toList();
    }

    return filteredUsers;
  }

  List<Group> _filterGroups(List<Group> groups) {
    if (_searchQuery.isNotEmpty) {
      return groups.where((group) =>
          group.designation.toLowerCase().contains(_searchQuery)
      ).toList();
    }
    return groups;
  }

  Widget _buildChatItem(BuildContext context, User user) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        User? currentUser = userProvider.currentUser;

        if (currentUser == null || currentUser.id == user.id) {
          return const SizedBox();
        }

        return Consumer<ChatRoomsProvider>(
          builder: (context, chatRoomsProvider, child) {
            ChatRoom? chatRoom;
            try {
              chatRoom = chatRoomsProvider.chatRooms.firstWhere(
                    (room) =>
                (room.firstUser.id == user.id && room.secondUser.id == currentUser.id) ||
                    (room.secondUser.id == user.id && room.firstUser.id == currentUser.id),
              );
            } catch (e) {
              // If no matching room is found, chatRoom remains null
            }

            return InkWell(
              splashColor: DailozColor.transparent,
              highlightColor: DailozColor.transparent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen.forUser(user: user)),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: DailozColor.bgpurple,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: user.picture != null
                            ? NetworkImage(user.picture!)
                            : const AssetImage('assets/images/icons/default_avatar.png') as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${user.firstName} ${user.lastName}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DailozColor.black)),
                            const SizedBox(height: 4),
                            Text(
                              chatRoom?.lastMessage?.text ?? 'Pas encore de messages',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, color: DailozColor.textgray),
                            ),
                          ],
                        ),
                      ),
                      if (chatRoom?.lastMessage != null)
                        Text(_formatTimestamp(chatRoom!.lastMessage!.timestamp),
                            style: const TextStyle(fontSize: 12, color: DailozColor.textgray)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGroupItem(BuildContext context, Group group) {
    return Consumer<ChatRoomsProvider>(
      builder: (context, chatRoomsProvider, child) {
        GroupChatRoom? groupChatRoom;
        try {
          groupChatRoom = chatRoomsProvider.groupChatRooms.firstWhere(
                (room) => room.group.id == group.id,
          );
        } catch (e) {
          // If no matching room is found, groupChatRoom remains null
        }

        return InkWell(
          splashColor: DailozColor.transparent,
          highlightColor: DailozColor.transparent,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatScreen.forGroup(group: group)),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: DailozColor.bgpurple,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: group.photo != null
                        ? NetworkImage(group.photo!)
                        : const AssetImage('assets/images/icons/default_avatar.png') as ImageProvider,
                    child: group.photo == null
                        ? Text(
                      group.designation[0].toUpperCase(),
                      style: const TextStyle(color: DailozColor.white),
                    )
                        : null,
                    backgroundColor: DailozColor.appcolor,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.designation,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DailozColor.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          groupChatRoom?.lastMessage?.text ?? 'Pas encore de messages',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, color: DailozColor.textgray),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (groupChatRoom?.lastMessage != null)
                        Text(
                          _formatTimestamp(groupChatRoom!.lastMessage!.timestamp),
                          style: const TextStyle(fontSize: 12, color: DailozColor.textgray),
                        ),
                      const SizedBox(height: 4),
                      if (groupChatRoom != null && groupChatRoom.unseenMsgs > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: DailozColor.appcolor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            groupChatRoom.unseenMsgs.toString(),
                            style: const TextStyle(color: DailozColor.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Maintenant';
    }
  }
}
