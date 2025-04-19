import 'package:flutter/material.dart';
import 'database_helper.dart';  // Make sure to import your database helper
import 'detail_page.dart'; // Import your product detail page
import 'location_page.dart'; // Import your location filter page

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  // Function to handle the search logic
  void _searchItems() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final results = await DatabaseHelper.instance.searchItems(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            'Search Items',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search field and filter button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search for items',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.location_pin, color: Colors.red),
                  tooltip: 'Filter by location',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationPage(), // เปลี่ยนเป็น LocationPage
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Results display
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: ListTile(
                            title: Text(item['name'] ?? 'No Name'),
                            subtitle: Text(item['subtitle'] ?? 'No Subtitle'),
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
            ),
          ],
        ),
      ),
    );
  }
}
