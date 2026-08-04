import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LawApp());
}

class LawApp extends StatelessWidget {
  const LawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'منصة القانون',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const NewsHomeScreen(),
    );
  }
}

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  State<NewsHomeScreen> createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  // رمز السر الخاص بالآدمن للنشر
  final String adminPasscode = "1234";

  // قائمة الأخبار المنشورة
  final List<Map<String, dynamic>> _newsList = [
    {
      'title': 'تنبيه هام للمستخدمين',
      'content': 'أهلاً بكم في تطبيق منصة القانون. يمكنك الآن متابعة التحديثات أولاً بأول.',
      'isPinned': true,
    },
  ];

  // دالة للتحقق من كلمة سر الآدمن
  void _checkAdminAccess() {
    final TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('دخول الآدمن'),
        content: TextField(
          controller: passController,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'أدخل رمز الآدمن للنشر',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (passController.text == adminPasscode) {
                Navigator.pop(context);
                _openAddNewsSheet();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('رمز السر غير صحيح!')),
                );
              }
            },
            child: const Text('دخول'),
          ),
        ],
      ),
    );
  }

  // نافذة إضافة خبر جديد
  void _openAddNewsSheet() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    bool isPinned = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'نشر خبر جديد (الآدمن)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان الخبر',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'تفاصيل الخبر',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('تثبيت الخبر في الأعلى؟'),
                value: isPinned,
                onChanged: (val) {
                  setSheetState(() {
                    isPinned = val ?? false;
                  });
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        contentController.text.isNotEmpty) {
                      setState(() {
                        final newArticle = {
                          'title': titleController.text,
                          'content': contentController.text,
                          'isPinned': isPinned,
                        };
                        if (isPinned) {
                          _newsList.insert(0, newArticle);
                        } else {
                          _newsList.add(newArticle);
                        }
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم نشر الخبر بنجاح!')),
                      );
                    }
                  },
                  child: const Text('نشر الآن'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأخبار والتبليغات - منصة القانون'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          final data = _newsList[index];
          final isPinned = data['isPinned'] ?? false;
          return Card(
            color: isPinned ? Colors.amber.shade50 : Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: isPinned
                  ? const Icon(Icons.push_pin, color: Colors.amber)
                  : const Icon(Icons.article, color: Colors.indigo),
              title: Text(
                data['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data['content'] ?? ''),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _checkAdminAccess,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('نشر خبر'),
      ),
    );
  }
}
