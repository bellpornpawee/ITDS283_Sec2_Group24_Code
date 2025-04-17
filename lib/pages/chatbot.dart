import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatWithAdminPage extends StatefulWidget {
  const ChatWithAdminPage({super.key});

  @override
  State<ChatWithAdminPage> createState() => _ChatWithAdminPageState();
}

class _ChatWithAdminPageState extends State<ChatWithAdminPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages =
      []; // ใช้ Map เพื่อแยกข้อความผู้ใช้/บอท

  final String _botApiUrl = 'https://api.openai.com/v1/chat/completions';

  final String _openAiApikey =
      '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'; // แทนที่ด้วย API key ของคุณ
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_openAiApikey',
  };

  bool _isBotThinking = false; // ตัวแปรแสดงสถานะว่าบอทกำลังประมวลผล

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty && !_isBotThinking) {
      setState(() {
        _messages.add({'sender': 'user', 'text': text});
        _messageController.clear();
        _isBotThinking = true; // แสดงว่ากำลังรอการตอบกลับจากบอท
      });

      try {
        final response = await http.post(
          Uri.parse(_botApiUrl),
          headers: _headers,
          body: jsonEncode({
            'model':
                'gpt-3.5-turbo', // หรือเลือกรุ่นโมเดลอื่น ๆ เช่น 'gpt-4' (อาจมีค่าใช้จ่ายสูงกว่า)
            'messages': [
              {'role': 'user', 'content': text},
            ],
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final botReply = _extractBotReply(
            responseData,
          ); // ฟังก์ชันแยกข้อความตอบกลับจาก JSON

          setState(() {
            _messages.add({'sender': 'My BOT', 'text': botReply});
            _isBotThinking = false;
          });
        } else {
          setState(() {
            _messages.add({
              'sender': 'bot',
              'text':
                  'เกิดข้อผิดพลาดในการสื่อสารกับบอท (${response.statusCode})',
            });
            _isBotThinking = false;
          });
          print(
            'Error communicating with bot: ${response.statusCode}, ${response.body}',
          );
        }
      } catch (error) {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'text': 'ไม่สามารถเชื่อมต่อกับบอทได้',
          });
          _isBotThinking = false;
        });
        print('Error connecting to bot: $error');
      }
    }
  }

  // ฟังก์ชันสำหรับแยกข้อความตอบกลับจาก JSON ที่บอทส่งมา
  // คุณจะต้องปรับ logic นี้ตามโครงสร้าง JSON ของ Bot API ของคุณ
  String _extractBotReply(Map<String, dynamic> responseData) {
    if (responseData.containsKey('choices') &&
        responseData['choices'] is List &&
        responseData['choices'].isNotEmpty) {
      final firstChoice = responseData['choices'][0];
      if (firstChoice.containsKey('message') &&
          firstChoice['message'] is Map &&
          firstChoice['message'].containsKey('content')) {
        return firstChoice['message']['content'];
      }
    }
    return 'บอทไม่สามารถประมวลผลการตอบกลับได้';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), 
                  Color(0xFF0F1F3D), ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.android,
                color: Colors.green,
              ), // เปลี่ยนไอคอนเป็นบอท
            ),
            SizedBox(height: 4),
            Text(
              'BOT', // เปลี่ยนชื่อเป็น BOT
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.indigo[800] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isBotThinking) // แสดงตัวโหลดเมื่อบอทกำลังคิด
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty && !_isBotThinking) {
                        _sendMessage();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.purple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}