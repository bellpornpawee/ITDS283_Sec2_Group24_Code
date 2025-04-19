import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'database_helper.dart' ;
class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _locationController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _usernameController = TextEditingController();
  String? imagePath;

  // ฟังก์ชันเลือกภาพจาก gallery
  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });
    }
  }

  // ฟังก์ชันการบันทึกข้อมูลลงในฐานข้อมูล
  void _submit() async {
    if (_nameController.text.isNotEmpty &&
        _brandController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _subtitleController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty) {
      final data = {
        'name': _nameController.text,
        'brand': _brandController.text,
        'location': _locationController.text,
        'subtitle': _subtitleController.text,
        'username': _usernameController.text,
        'imagePath': imagePath,
        'date': DateTime.now().toString().split(' ')[0],
      };

      // Save to SQLite
      await DatabaseHelper.instance.insert(data);

      Navigator.pop(context, data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4A90E2), 
                  Color(0xFF0F1F3D), 
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Upload',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            imagePath != null
                ? Image.file(File(imagePath!), height: 100)
                : const Icon(Icons.image, size: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: 'Subtitle'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
