import 'package0/flutter/material.dart';

class StudentsContributionsScreen extends StatelessWidget {
  const StudentsContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مساهمات الطلبة'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('قسم مساهمات الطلبة - قيد الإعداد', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
