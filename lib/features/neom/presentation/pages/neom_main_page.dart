import 'package:flutter/material.dart';

class NeomMainPage extends StatelessWidget {
  const NeomMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neom Main Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FetchButton(
              label: 'Fetch RC',
              onPressed: () {
                // TODO: Implement fetch RC logic
              },
            ),
            const SizedBox(height: 16),
            FetchButton(
              label: 'Fetch Licences',
              onPressed: () {
                // TODO: Implement fetch Licences logic
              },
            ),
            const SizedBox(height: 16),
            FetchButton(
              label: 'Fetch Insurance',
              onPressed: () {
                // TODO: Implement fetch Insurance logic
              },
            ),
            const SizedBox(height: 16),
            FetchButton(
              label: 'Fetch Challan',
              onPressed: () {
                // TODO: Implement fetch Challan logic
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FetchButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const FetchButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
