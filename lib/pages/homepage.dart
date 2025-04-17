import 'dart:io';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'database_helper.dart';
import 'search.dart';
import 'upload.dart';
import 'chatbot.dart'; // เพิ่ม import chatbot
import 'detail_page.dart'; // Import the DetailPage

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> uploadedData = [];

  void _loadData() async {
    final data = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      uploadedData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _navigateToChatPage(Map<String, dynamic> item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(item: item),
      ),
    );
  }

  void _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchPage(),
      ),
    );
  }

  void _navigateToChatbot() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatWithAdminPage(),
      ),
    );
  }

  void _deleteItem(Map<String, dynamic> item) async {
    await DatabaseHelper.instance.delete(item['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item deleted')),
    );
    _loadData();
  }

  void _showEditDialog(Map<String, dynamic> item) {
    final _nameController = TextEditingController(text: item['name']);
    final _brandController = TextEditingController(text: item['brand']);
    final _locationController = TextEditingController(text: item['location']);
    final _subtitleController = TextEditingController(text: item['subtitle']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: _brandController, decoration: const InputDecoration(labelText: 'Brand')),
              TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location')),
              TextField(controller: _subtitleController, decoration: const InputDecoration(labelText: 'Subtitle')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedItem = {
                  'id': item['id'],
                  'name': _nameController.text,
                  'brand': _brandController.text,
                  'location': _locationController.text,
                  'subtitle': _subtitleController.text,
                  'imagePath': item['imagePath'],
                  'date': item['date'],
                };
                await DatabaseHelper.instance.update(updatedItem);
                Navigator.pop(context);
                _loadData();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToUploadPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UploadPage()),
    );

    if (result != null) {
      _loadData();
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
            'Homepage',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _navigateToSearchPage,
            ),
            IconButton(
              icon: const Icon(Icons.upload),
              onPressed: _navigateToUploadPage,
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _navigateToChatbot,
            ),
          ],
        ),
      ),
      body: uploadedData.isEmpty
          ? const Center(child: Text('No uploaded data available.'))
          : ListView.builder(
              itemCount: uploadedData.length,
              itemBuilder: (context, index) {
                final item = uploadedData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: item['imagePath'] != null
                        ? Image.file(File(item['imagePath']), width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.image),
                    title: Text(item['name'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['subtitle'] ?? 'No Subtitle'),
                        Text('Date: ${item['date']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chat),
                          onPressed: () => _navigateToChatPage(item), // Corrected here
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _navigateToChatbot(),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(product: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
