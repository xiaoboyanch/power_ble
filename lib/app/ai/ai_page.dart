import 'package:cabina_ble/route/rh_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'ai_ctrl.dart';
import 'deepseek_service.dart';

class AiPage extends GetView<AIController> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ai'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.toNamed(RHRoute.aiWorkout);
            },
          ),
        ],
      ),
      body: Obx(() {
        int flag = controller.updateFlag.value;
        return Column(
          children: [
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      return ChatBubble(
                        message: message.text,
                        isUser: message.isUser,
                      );
                    })
            ),
            if (controller.isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.controller,
                      decoration: InputDecoration(
                        hintText: '输入消息...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => controller.sendMessageStream()//sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: controller.sendMessageStream,//sendMessage,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            Gap(40)
          ],
        );
      })
    );
  }

}

class ChatMessage {
   String text;
   bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: isUser ? Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.blue[900] : Colors.grey[900],
          )
        ):
        MarkdownBody(data: message),
      ),
    );
  }
}


