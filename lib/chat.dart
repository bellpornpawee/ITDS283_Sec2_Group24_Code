
// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   final Map<String, dynamic> item; // รับข้อมูลจาก Homepage

//   const ChatScreen({Key? key, required this.item}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();
//   List<String> _messages = [];

//   // ฟังก์ชันสำหรับการส่งข้อความ
//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         _messages.add(_controller.text); // เพิ่มข้อความใหม่ในรายการ
//       });
//       _controller.clear(); // ล้างข้อความหลังจากส่ง
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${widget.item['name']}'), // ใช้ชื่อที่ส่งมาจาก Homepage
//       ),
//       body: Column(
//         children: [
//           // แสดงข้อความที่ส่ง
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_messages[index]),
//                 );
//               },
//             ),
//           ),
//           // ช่องกรอกข้อความ
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(hintText: 'Enter your message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _sendMessage, // ส่งข้อความ
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
