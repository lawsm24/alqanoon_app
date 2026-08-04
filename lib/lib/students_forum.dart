import 'package:flutter/material.dart';

class StudentsForumScreen extends StatelessWidget {
  const StudentsForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منتدى الطلبة'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('قسم منتدى الطلبة - قيد الإعداد', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
