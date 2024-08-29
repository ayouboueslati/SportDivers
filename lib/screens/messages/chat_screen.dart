import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footballproject/Provider/ChatProvider/FindMessagesProvider.dart';
import 'package:footballproject/Provider/ChatProvider/SendMsgProvider.dart';
import 'package:footballproject/Provider/ChatProvider/usersChat.dart';
import 'package:footballproject/Provider/UserProvider/userProvider.dart';
import 'package:footballproject/models/ChatModel.dart';
import 'package:footballproject/screens/Service/SocketService.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final User? user;
  final Group? group;
  final bool isGroupChat;

  ChatScreen.forUser({required this.user})
      : group = null,
        isGroupChat = false;

  ChatScreen.forGroup({required this.group})
      : user = null,
        isGroupChat = true;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late User? currentUser;
  String? chatRoomId;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;
    _initializeChat();
    SocketService.socket!.on('new-message', handleNewMessage);
  }

  dynamic handleNewMessage(dynamic data) {
    _onNewMessage(Message.fromJson(data));
  }

  void _initializeChat() async {
    if (widget.isGroupChat) {
      _fetchGroupMessages();
    } else {
      await _fetchPrivateMessages();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userChatProvider =
          Provider.of<usersChatProvider>(context, listen: false);
      await userChatProvider.fetchUsers();
      userChatProvider.debugPrintUsers();
    });
  }

  void _onNewMessage(Message message) {
   if (!mounted) return;
    setState(() {
      Provider.of<MessagesProvider>(context, listen: false).addMessage(message);
    });
    // Scroll to the bottom of the list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _fetchPrivateMessages() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    try {
      chatRoomId = await chatProvider.getChatRoomId('USER', widget.user!.id);
      await Provider.of<MessagesProvider>(context, listen: false)
          .fetchPrivateMessages(chatRoomId!);
    } catch (e) {
      print('Error fetching private messages: $e');
      // Handle the error, maybe show a snackbar to the user
    }
  }

  Future<void> _fetchGroupMessages() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    try {
      String? groupChatId =
          await chatProvider.getChatRoomId('GROUP', widget.group!.id);
      if (groupChatId != null) {
        await Provider.of<MessagesProvider>(context, listen: false)
            .fetchGroupMessages(groupChatId);
      }
    } catch (e) {
      print('Error fetching group messages: $e');
      // Handle the error, maybe show a snackbar to the user
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    SocketService.socket!.off('new-message', handleNewMessage);
    super.dispose();
  }

  void _sendMessage(BuildContext context) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (_messageController.text.isEmpty) return;

    try {
      final message = await chatProvider.sendMessage(
        text: _messageController.text,
        type: 'TEXT',
        targetType: widget.isGroupChat ? 'GROUP' : 'USER',
        target: widget.isGroupChat ? widget.group!.id : widget.user!.id,
        chatRoom: chatRoomId,
      );
      print(message);

      _messageController.clear();

      // Add the sent message to the UI immediately
      _onNewMessage(Message.fromJson(message));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  _chatBubble(Message message, bool isMe, bool isSameUser) {
    final userProvider = Provider.of<usersChatProvider>(context, listen: false);
    final sender = userProvider.getUserById(message.sender.id);

    print('Sender ID: ${message.sender.id}');
    print('Sender: ${sender?.toJson()}');

    // Format the time
    final timeString = DateFormat('HH:mm').format(message.timestamp);

    Widget _senderAvatar() {
      return CircleAvatar(
        radius: 15,
        backgroundImage: sender?.picture != null
            ? NetworkImage(sender!.picture!)
            : AssetImage('assets/images/icons/default_avatar.png')
                as ImageProvider,
        backgroundColor: Colors.grey[300],
        child: sender?.picture == null
            ? Text(sender?.firstName[0].toUpperCase() ?? '')
            : null,
      );
    }

    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      timeString,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _senderAvatar(),
                  ],
                )
              : Container(),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    _senderAvatar(),
                    const SizedBox(width: 10),
                    Text(
                      timeString,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 55,
      margin: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 0.0,
        bottom: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo),
            iconSize: 25,
            color: Colors.blue[900],
            onPressed: () {},
          ),
          Transform.translate(
            offset: const Offset(-12, 0),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.emoji_emotions_outlined),
              iconSize: 25,
              color: Colors.blue[900],
              onPressed: () {},
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25,
            color: Colors.blue[900],
            onPressed: () => _sendMessage(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.7),
        elevation: 8,
        title: Transform.translate(
          offset: const Offset(-12, 0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: widget.isGroupChat
                    ? null
                    : (widget.user!.picture != null
                        ? NetworkImage(widget.user!.picture!)
                        : AssetImage('assets/images/icons/default_avatar.png')
                            as ImageProvider),
                backgroundColor: Colors.grey[300],
                child: widget.isGroupChat
                    ? Text(widget.group!.designation[0])
                    : null,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isGroupChat
                        ? widget.group!.designation
                        : "${widget.user!.firstName} ${widget.user!.lastName}",
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    widget.isGroupChat
                        ? "Group"
                        : widget.user!.type.capitalize(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.blue[900],
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.blue[900],
              size: 30,
            ),
            onSelected: (value) {
              switch (value) {
                case 'search':
                  // Implement search functionality
                  break;
                case 'clear':
                  // Implement clear chat functionality
                  break;
                case 'block':
                  // Implement block user functionality
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'search',
                child: Text('Search'),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear chat'),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Text('Block user'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer2<MessagesProvider, UserProvider>(
              builder: (context, messagesProvider, userProvider, child) {
                final messages = messagesProvider.messages.reversed.toList();

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Message message = messages[index];
                    final bool isMe = message.sender.id == currentUser?.id;
                    final bool isSameUser = index > 0 &&
                        messages[index - 1].sender.id == message.sender.id;
                    return _chatBubble(message, isMe, isSameUser);
                  },
                );
              },
            ),
          ),
          _sendMessageArea(),
        ],
      ),
    );
  }
}

// Add this extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
