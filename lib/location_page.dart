import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final List<String> locations = ['around me', 'Bangkok', 'Nakhon Pathom'];
  final Map<String, bool> selectedLocations = {
    'around me': false,
    'Bangkok': false,
    'Nakhon Pathom': false,
  };

  String selectedProvince = 'around me'; // ค่า default ที่แสดงก่อนเลือก

  final List<String> provinceOptions = [
    'around me',
    'Bangkok',
    'Nakhon Pathom',
  ];

  void _clearSelection() {
    setState(() {
      selectedProvince = 'Near me';
      selectedLocations.updateAll((key, value) => false);
    });
  }

  void _submit() {
    final selected =
        selectedLocations.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList();
    print('Selected locations: $selected');
    // Do something with the result
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => Navigator.pushNamed(context, '/upload'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => Navigator.pushNamed(context, '/chat_with_admin'),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.location_on, size: 100),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Province', style: TextStyle(fontSize: 16)),
            ),
            DropdownButton<String>(
              value: selectedProvince,
              items:
                  provinceOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedProvince = 'around me';  // ✅ มีอยู่ใน provinceOptions


                });
              },
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Near me', style: TextStyle(fontSize: 16)),
                  ),
                  ...locations.map((loc) {
                    return CheckboxListTile(
                      title: Text(loc),
                      value: selectedLocations[loc],
                      onChanged: (val) {
                        setState(() {
                          selectedLocations[loc] = val!;
                        });
                      },
                    );
                  }).toList(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: _submit,
                        child: const Text('Submit'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: _clearSelection,
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
