import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportdivers/Provider/ChatProvider/FindMessagesProvider.dart';
import 'package:sportdivers/Provider/ChatProvider/SendMsgProvider.dart';
import 'package:sportdivers/Provider/ChatProvider/usersChat.dart';
import 'package:sportdivers/Provider/UserProvider/userProvider.dart';
import 'package:sportdivers/models/ChatModel.dart';
import 'package:sportdivers/screens/Service/SocketService.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/messages/FullScreenImageViewer.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  final ImagePicker _picker = ImagePicker();

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
    Provider.of<MessagesProvider>(context, listen: false).clearMessages();

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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      _sendImageMessage(imageFile);
    }
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
    Provider.of<MessagesProvider>(context, listen: false).clearMessages();
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

  void _sendImageMessage(File imageFile) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    try {
      final message = await chatProvider.sendMessage(
        text: 'une pièce jointe',
        type: 'IMAGE',
        targetType: widget.isGroupChat ? 'GROUP' : 'USER',
        target: widget.isGroupChat ? widget.group!.id : widget.user!.id,
        chatRoom: chatRoomId,
        file: imageFile,
      );
      print(message);
      // Add the sent message to the UI immediately
      _onNewMessage(Message.fromJson(message));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send image: $e')),
      );
    }
  }

  Widget _chatBubble(Message message, bool isMe, bool isSameUser) {
    final userProvider = Provider.of<usersChatProvider>(context, listen: false);
    final sender = userProvider.getUserById(message.sender.id);
    final timeString = DateFormat('HH:mm').format(message.timestamp);

    Widget _senderAvatar() {
      return CircleAvatar(
        radius: 15,
        backgroundImage: sender?.picture != null
            ? NetworkImage(sender!.picture!)
            : AssetImage('assets/images/icons/default_avatar.png') as ImageProvider,
        backgroundColor: DailozColor.grey,
        child: sender?.picture == null
            ? Text(sender?.firstName[0].toUpperCase() ?? '', style: TextStyle(color: DailozColor.white))
            : null,
      );
    }

    Widget _messageContent() {
      if (message.type == 'IMAGE' && message.fileName != null) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FullScreenImageViewer(imageUrl: message.fileName!),
            ));
          },
          child: Hero(
            tag: message.fileName!,
            child: Image.network(
              message.fileName!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      color: DailozColor.appcolor,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $error');
                return Container(
                  width: 200,
                  height: 200,
                  color: DailozColor.bggray,
                  child: Icon(Icons.error, color: DailozColor.purple),
                );
              },
            ),
          ),
        );
      } else {
        return Text(
          message.text,
          style: TextStyle(
            color: isMe ? DailozColor.white : DailozColor.black,
            fontSize: 15,
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isMe ? DailozColor.appcolor : DailozColor.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: DailozColor.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: _messageContent(),
        ),
        if (!isSameUser)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Row(
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                if (!isMe) _senderAvatar(),
                SizedBox(width: 8),
                Text(
                  timeString,
                  style: TextStyle(
                    fontSize: 12,
                    color: DailozColor.textgray,
                  ),
                ),
                if (isMe) SizedBox(width: 8),
                if (isMe) _senderAvatar(),
              ],
            ),
          ),
      ],
    );
  }

  Widget _sendMessageArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: DailozColor.white,
        boxShadow: [
          BoxShadow(
            color: DailozColor.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo, color: DailozColor.appcolor),
            onPressed: _pickImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Envoyer un message...',
                hintStyle: TextStyle(color: DailozColor.textgray),
                border: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: DailozColor.appcolor),
            onPressed: () => _sendMessage(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DailozColor.bggray,
      appBar: AppBar(
        backgroundColor: DailozColor.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: DailozColor.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.isGroupChat
                  ? null
                  : (widget.user!.picture != null
                  ? NetworkImage(widget.user!.picture!)
                  : AssetImage('assets/images/icons/default_avatar.png') as ImageProvider),
              backgroundColor: DailozColor.grey,
              child: widget.isGroupChat
                  ? Text(widget.group!.designation[0], style: TextStyle(color: DailozColor.white))
                  : null,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isGroupChat
                      ? widget.group!.designation
                      : "${widget.user!.firstName} ${widget.user!.lastName}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: DailozColor.black,
                  ),
                ),
                Text(
                  widget.isGroupChat ? "Groupe" : "",
                  style: TextStyle(
                    fontSize: 12,
                    color: DailozColor.textgray,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: DailozColor.black),
            onSelected: (value) {
              if (value == 'Réclamation') {
                // Implement réclamation functionality
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'Réclamation',
                child: Text('Réclamation'),
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
