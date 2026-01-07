import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'ai_page.dart';
import 'deepseek_service.dart';

class AIController extends GetxController {

  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> messages = [];
  bool isLoading = false;
  late DeepSeekService deepSeekService;
  RxInt updateFlag = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    String key = dotenv.get('DEEPSEEK_API_KEY');
    deepSeekService = DeepSeekService(key);
  }

  void sendMessage() async {
    final message = controller.text.trim();
    if (message.isEmpty || isLoading) return;

      messages.add(ChatMessage(text: message, isUser: true));
      controller.clear();
      isLoading = true;
      updateFlag.value++;
    try {
      // 普通响应版本
      final response = await deepSeekService.chatCompletion(
        message: message,
      );

        messages.add(ChatMessage(text: response, isUser: false));
        isLoading = false;
        updateFlag.value++;
    } catch (e) {
        messages.add(ChatMessage(text: '错误: $e', isUser: false));
        isLoading = false;
        updateFlag.value++;
    }
  }

  // 流式响应版本（可选）
  void sendMessageStream() async {
    final message = controller.text.trim();
    if (message.isEmpty || isLoading) return;

    messages.add(ChatMessage(text: message, isUser: true));
    controller.clear();
    isLoading = true;
    updateFlag.value++;

    try {
      // 使用流式响应
      final stream = deepSeekService.streamChatCompletion(message: message);

      String fullResponse = '';
      await for (String chunk in stream) {
        fullResponse += chunk;
        // 更新最后一条消息的文本
        if (messages.isNotEmpty && !messages.last.isUser) {
          messages.last.text = fullResponse;
        } else {
          messages.add(ChatMessage(text: fullResponse, isUser: false));
        }
        updateFlag.value++;
      }

      isLoading = false;
      updateFlag.value++;
    } catch (e) {
      messages.add(ChatMessage(text: '错误: $e', isUser: false));
      isLoading = false;
      updateFlag.value++;
    }
  }
}