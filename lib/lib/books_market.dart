import 'package:flutter/material.dart';

class BooksMarketScreen extends StatelessWidget {
  const BooksMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سوق الكتب'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('قسم سوق الكتب - قيد الإعداد', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
