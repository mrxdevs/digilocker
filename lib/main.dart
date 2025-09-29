import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:digilocker/features/neom/presentation/pages/docs_details_page.dart';
import 'package:digilocker/presentations/homepage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

// 1. Define the GoRouter configuration
final GoRouter _router = GoRouter(
  // Initial path if the app is opened normally
  initialLocation: '/',

  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),

    GoRoute(
      path: '/docs-details',
      builder: (context, state) {
        return MeonDigilockerDocsDetails();
      },
    ),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appLinks = AppLinks();
  StreamSubscription? _sub;
  @override
  void initState() {
    super.initState();
    _sub = appLinks.uriLinkStream.listen((uri) {
      // Debugging message
      debugPrint(
        '------------>Received deep link: ${uri.toString()} and Path: ${uri.path}<---------------',
      );
      //Handling navigation here
      _router.go(uri.path); // This will navigate to the correct page
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}
