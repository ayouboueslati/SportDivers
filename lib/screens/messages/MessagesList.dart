import 'package:flutter/material.dart';
import 'package:footballproject/Provider/ChatProvider/ChatRoomsProvider.dart';
import 'package:footballproject/Provider/UserProvider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/models/ChatModel.dart';
import 'package:footballproject/models/user_model.dart';
import 'package:footballproject/Provider/ChatProvider/usersChat.dart';
import 'package:footballproject/screens/Service/SocketService.dart';
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

  @override
  void initState() {
    super.initState();
    _socketService = Provider.of<SocketService>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatRoomsProvider>(context, listen: false).fetchChatRooms();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => usersChatProvider()..fetchUsers(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: AppBar(
          toolbarHeight: 60,
          shadowColor: Colors.grey.withOpacity(0.3),
          elevation: 5,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.blue[900],
          title: const Text(
            'Chats',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
        body: Consumer2<usersChatProvider, SocketService>(
          builder: (context, userProvider, socketService, child) {
            if (userProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (userProvider.errorMessage.isNotEmpty) {
              return Center(child: Text('Error: ${userProvider.errorMessage}'));
            } else if (userProvider.users.isNotEmpty ||
                userProvider.groups.isNotEmpty) {
              // Filter users and groups based on the role
              List<User> filteredUsers;
              print("111111111111111111111111111111");
              print(widget.role);
              if (widget.role == 'TEACHER') {
                filteredUsers = userProvider.users
                    .where((user) => user.type == 'student')
                    .toList(); // Teachers can chat with students
              } else if (widget.role == 'STUDENT') {
                filteredUsers = userProvider.users
                    .where((user) => user.type == 'teacher')
                    .toList(); // Students can chat with teachers
              } else {
                filteredUsers = []; // Empty if role doesn't match
              }
              return Column(
                children: [
                  //_buildSearchBar(),
                  //_buildStoriesRow(userProvider.users),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Discussions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length +
                          userProvider.groups.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < filteredUsers.length) {
                          final User user = filteredUsers[index];
                          return _buildChatItem(context, user);
                        } else {
                          final Group group = userProvider
                              .groups[index - filteredUsers.length];
                          return _buildGroupItem(context, group);
                        }
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('Aucun utilisateur ou groupe trouvé'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, User user) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        User? currentUser = userProvider.currentUser;

        if (currentUser == null || currentUser.id == user.id) {
          return SizedBox(); // Hide the item if it's the current user
        }

        return Consumer<ChatRoomsProvider>(
          builder: (context, chatRoomsProvider, child) {
            ChatRoom? chatRoom;
            try {
              chatRoom = chatRoomsProvider.chatRooms.firstWhere(
                (room) =>
                    (room.firstUser.id == user.id && room.secondUser.id == currentUser.id) ||
                    (room.secondUser.id == user.id && room.firstUser.id == currentUser.id),


                    // ((room.firstUser.id == user.id &&
                    //         room.secondUser.id != currentUser.id) ||
                    //     (room.secondUser.id == user.id &&
                    //         room.firstUser.id != currentUser.id)),
              );
            } catch (e) {
              // If no matching room is found, chatRoom remains null
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.picture != null
                    ? NetworkImage(user.picture!)
                    : AssetImage('assets/images/icons/default_avatar.png')
                as ImageProvider,
              ),
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text(
                chatRoom?.lastMessage?.text ?? 'Pas encore de messages',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: chatRoom?.lastMessage != null
                  ? Text(_formatTimestamp(chatRoom!.lastMessage!.timestamp))
                  : null,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen.forUser(user: user)),
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
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: group.photo != null
                ? NetworkImage(group.photo!)
                : AssetImage('assets/images/icons/default_avatar.png')
             as ImageProvider,
            // child: Text(group.designation[0].toUpperCase()),
            // backgroundColor: Colors.blue[700],
          ),
          title: Text(group.designation),
          subtitle: groupChatRoom != null && groupChatRoom.lastMessage != null
              ? Text(
                  groupChatRoom.lastMessage!.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : Text('Pas encore de messages'),
          trailing: groupChatRoom != null && groupChatRoom.lastMessage != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTimestamp(groupChatRoom.lastMessage!.timestamp),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    if (groupChatRoom.unseenMsgs > 0)
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          groupChatRoom.unseenMsgs.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                )
              : null,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatScreen.forGroup(group: group)),
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
