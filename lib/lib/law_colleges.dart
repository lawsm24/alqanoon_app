import 'package:flutter/material.dart';

class LawCollegesScreen extends StatelessWidget {
  const LawCollegesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تجمع كليات القانون'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('قسم تجمع كليات القانون - قيد الإعداد', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
