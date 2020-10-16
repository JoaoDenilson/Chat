import 'package:flutter/material.dart';
import 'package:chatpdm/ui/text_composer.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        centerTitle: true,
      ),
      body: Column(
        children: [Container(), TextComposer()],
      ),
    );
  }
}
