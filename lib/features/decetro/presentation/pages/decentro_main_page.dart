import 'package:flutter/material.dart';

class DecentroMainPage extends StatelessWidget {
  const DecentroMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fetch Documents')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FetchDocumentTile(title: 'Fetch PAN'),
          FetchDocumentTile(title: 'Fetch Aadhaar'),
          FetchDocumentTile(title: 'Fetch RC'),
          FetchDocumentTile(title: 'Fetch Licence'),
          FetchDocumentTile(title: 'Fetch Insurance'),
          FetchDocumentTile(title: 'Fetch Challan'),
        ],
      ),
    );
  }
}

class FetchDocumentTile extends StatelessWidget {
  final String title;

  const FetchDocumentTile({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        trailing: ElevatedButton(
          onPressed: () {
            // TODO: Implement fetch logic
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$title requested')));
          },
          child: const Text('Fetch'),
        ),
      ),
    );
  }
}
