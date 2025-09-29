import 'package:digilocker/features/decetro/presentation/pages/decentro_main_page.dart';
import 'package:digilocker/features/neom/presentation/pages/neom_main_page.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decentro'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Decentro!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your digital locker for all important documents.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.folder, color: Colors.deepPurple),
                title: const Text('Decetro'),
                subtitle: const Text(
                  'Fetch and verify your docs with digilocker',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DecentroMainPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.cloud_upload,
                  color: Colors.deepPurple,
                ),
                title: const Text('Neom'),
                subtitle: const Text('Pan, Adhar, Rc, Insurance and Licenses'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NeomMainPage()),
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
