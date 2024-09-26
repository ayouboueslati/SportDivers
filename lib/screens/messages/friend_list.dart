// import 'package:flutter/material.dart';
// import 'package:sportdivers/models/ChatModel.dart';
// import 'package:provider/provider.dart';
// import 'package:sportdivers/Provider/ChatProvider/usersChat.dart';
// import 'package:sportdivers/models/user_model.dart';
// import 'package:sportdivers/screens/Service/SocketService.dart';
// import 'chat_screen.dart';
//
// class FriendScreen extends StatefulWidget {
//   static String id = 'friend_screen';
//
//   const FriendScreen({Key? key}) : super(key: key);
//
//   @override
//   _FriendScreenState createState() => _FriendScreenState();
// }
//
// class _FriendScreenState extends State<FriendScreen> {
//   late SocketService _socketService;
//
//   @override
//   void initState() {
//     super.initState();
//     _socketService = Provider.of<SocketService>(context, listen: false);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => usersChatProvider()..fetchUsers(),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF6F6F6),
//         appBar: AppBar(
//           toolbarHeight: 60,
//           shadowColor: Colors.grey.withOpacity(0.3),
//           elevation: 5,
//           iconTheme: const IconThemeData(color: Colors.white),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           backgroundColor: Colors.blue[900],
//           title: const Text(
//             'Chats',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 28,
//             ),
//           ),
//         ),
//         body: Consumer2<usersChatProvider, SocketService>(
//           builder: (context, userProvider, socketService, child) {
//             if (userProvider.isLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (userProvider.errorMessage.isNotEmpty) {
//               return Center(child: Text('Error: ${userProvider.errorMessage}'));
//             } else if (userProvider.users.isNotEmpty || userProvider.groups.isNotEmpty) {
//               return Column(
//                 children: [
//                   _buildSearchBar(),
//                   _buildStoriesRow(userProvider.users),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: userProvider.users.length + userProvider.groups.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         if (index < userProvider.users.length) {
//                           final User user = userProvider.users[index];
//                           return _buildChatItem(context, user);
//                         } else {
//                           final Group group = userProvider.groups[index - userProvider.users.length];
//                           return _buildGroupItem(context, group);
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return Center(child: Text('No users or groups found'));
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: 'Search',
//           prefixIcon: const Icon(Icons.search),
//           filled: true,
//           fillColor: Colors.grey[200],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStoriesRow(List<User> users) {
//     return Container(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           final User user = users[index];
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundImage: user.picture != null
//                       ? NetworkImage(user.picture!)
//                       : AssetImage('assets/images/icons/default_avatar.png') as ImageProvider,
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   user.firstName,
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildChatItem(BuildContext context, User user) {
//     final chatRoom = Provider.of<usersChatProvider>(context, listen: false).getChatRoomForUser(user);
//     print('User: ${user.id}, ChatRoom: ${chatRoom?.id}'); // Debugging
//
//     return InkWell(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => ChatScreen.forUser(user: user)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           children: <Widget>[
//             CircleAvatar(
//               radius: 30,
//               backgroundImage: user.picture != null
//                   ? NetworkImage(user.picture!)
//                   : AssetImage('assets/images/icons/default_avatar.png') as ImageProvider,
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     '${user.firstName} ${user.lastName}',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     user.type,
//                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                   ),
//                   if (chatRoom != null) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       chatRoom.lastMessage.text,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Text(
//                       _formatTimestamp(chatRoom.lastMessage.timestamp),
//                       style: TextStyle(color: Colors.grey[400], fontSize: 10),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGroupItem(BuildContext context, Group group) {
//     final groupChatRoom = Provider.of<usersChatProvider>(context, listen: false).getGroupChatRoomForGroup(group);
//
//     return InkWell(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => ChatScreen.forGroup(group: group)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           children: <Widget>[
//             CircleAvatar(
//               radius: 30,
//               child: Text(group.designation[0]),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     group.designation,
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Group',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                   ),
//                   if (groupChatRoom != null) ...[
//                     const SizedBox(height: 4),
//                     // Text(
//                     //   groupChatRoom.lastMessage.text,
//                     //   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                     //   maxLines: 1,
//                     //   overflow: TextOverflow.ellipsis,
//                     // ),
//                     // Text(
//                     //   _formatTimestamp(groupChatRoom.lastMessage.timestamp),
//                     //   style: TextStyle(color: Colors.grey[400], fontSize: 10),
//                     // ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);
//
//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m ago';
//     } else {
//       return 'Just now';
//     }
//   }
// }
//
// // Extension to capitalize the first letter of a string
// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${this.substring(1)}";
//   }
// }
