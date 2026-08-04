import 'package:flutter/material.dart';
import 'sections/books_library.dart';
import 'sections/books_market.dart';
import 'sections/students_forum.dart';
import 'sections/students_contributions.dart';
import 'sections/law_colleges.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mainSections = [
      {
        'title': 'مكتبة الكتب',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFF1A1A1A),
        'screen': const BooksLibraryScreen(),
      },
      {
        'title': 'سوق الكتب',
        'icon': Icons.storefront_rounded,
        'color': const Color(0xFF1A1A1A),
        'screen': const BooksMarketScreen(),
      },
      {
        'title': 'منتدى الطلبة',
        'icon': Icons.forum_rounded,
        'color': const Color(0xFF1A1A1A),
        'screen': const StudentsForumScreen(),
      },
      {
        'title': 'مساهمات الطلبة',
        'icon': Icons.school_rounded,
        'color': const Color(0xFF1A1A1A),
        'screen': const StudentsContributionsScreen(),
      },
      {
        'title': 'تجمع كليات القانون',
        'icon': Icons.groups_rounded,
        'color': const Color(0xFF1A1A1A),
        'screen': const LawCollegesScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('منصة القانون'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'admin') {
                // دخول الآدمن مستقبلاً
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'admin',
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings, color: Color(0xFFD4AF37)),
                    SizedBox(width: 8),
                    Text('لوحة النشر (الآدمن)'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: mainSections.length,
          itemBuilder: (context, index) {
            final section = mainSections[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFD4AF37),
                  radius: 25,
                  child: Icon(section['icon'], color: Colors.black, size: 28),
                ),
                title: Text(
                  section['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => section['screen']),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
