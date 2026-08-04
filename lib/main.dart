import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منصة القانون',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A1A1A),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

// ------------------- نموذج البيانات -------------------
class PostItem {
  final String title;
  final String content;
  final String category;
  final String date;
  final bool isPinned;
  final String? attachmentUrl;

  PostItem({
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    this.isPinned = false,
    this.attachmentUrl,
  });
}

// قائمة المنشورات الحالية (قاعدة بيانات محلية)
List<PostItem> globalPosts = [
  PostItem(
    title: 'تنويه هام بشأن اللائحة الجديدة',
    content: 'أهلاً بك في تطبيق منصة القانون. تم تحديث الواجهات بنجاح واستعادة كافة الأقسام المخصصة لنشر الأخبار والمستندات القانونية.',
    category: 'تنبيهات',
    date: 'الآن',
    isPinned: true,
  ),
  PostItem(
    title: 'تعديلات قانون العمل لسنة 2026',
    content: 'يتضمن هذا الجزء تفاصيل التعديلات الأخيرة التي تمت على قانون العمل والإجراءات القانونية المتبعة.',
    category: 'التشريعات',
    date: 'اليوم',
    attachmentUrl: 'https://example.com/law.pdf',
  ),
];

// ------------------- الشاشة الترحيبية -------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.gavel,
                size: 90,
                color: Color(0xFFD4AF37),
              ),
              const SizedBox(height: 24),
              const Text(
                'منصة القانون',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'سيدعباس عقيل الحسيني',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Color(0xFFD4AF37),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- الشاشة الرئيسية والأقسام -------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = 'الكل';

  final List<String> categories = ['الكل', 'تنبيهات', 'التشريعات', 'أخبار قانونية', 'استشارات'];

  @override
  Widget build(BuildContext context) {
    List<PostItem> filteredPosts = _selectedCategory == 'الكل'
        ? globalPosts
        : globalPosts.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('منصة القانون'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // زر دخول الآدمن للنشر
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Color(0xFFD4AF37)),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPublishScreen()),
              );
              setState(() {}); // تحديث الشاشة بعد إضافة منشور
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط الأقسام
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: const Color(0xFFD4AF37),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: const Color(0xFF2A2A2A),
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // قائمة المنشورات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text(post.category, style: const TextStyle(fontSize: 12)),
                              backgroundColor: const Color(0xFFE0E0E0),
                            ),
                            if (post.isPinned)
                              const Row(
                                children: [
                                  Icon(Icons.push_pin, color: Colors.amber, size: 18),
                                  SizedBox(width: 4),
                                  Text('مثبت', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Text(
                          post.content,
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                        if (post.attachmentUrl != null) ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                            label: const Text('عرض المستند المرفق'),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          post.date,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- لوحة نشر الآدمن -------------------
class AdminPublishScreen extends StatefulWidget {
  const AdminPublishScreen({super.key});

  @override
  State<AdminPublishScreen> createState() => _AdminPublishScreenState();
}

class _AdminPublishScreenState extends State<AdminPublishScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _attachmentController = TextEditingController();
  String _selectedCategory = 'تنبيهات';
  bool _isPinned = false;

  final List<String> categories = ['تنبيهات', 'التشريعات', 'أخبار قانونية', 'استشارات'];

  void _publishPost() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة العنوان والمحتوى')),
      );
      return;
    }

    final newPost = PostItem(
      title: _titleController.text,
      content: _contentController.text,
      category: _selectedCategory,
      date: 'الآن',
      isPinned: _isPinned,
      attachmentUrl: _attachmentController.text.isNotEmpty ? _attachmentController.text : null,
    );

    setState(() {
      if (_isPinned) {
        globalPosts.insert(0, newPost);
      } else {
        globalPosts.add(newPost);
      }
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة النشر - الآدمن'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان المنشور',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'القسم',
                border: OutlineInputBorder(),
              ),
              items: categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'محتوى الخبر أو النص القانوني',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _attachmentController,
              decoration: const InputDecoration(
                labelText: 'رابط ملف مرفق (PDF / صورة) - اختياري',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('تثبيت المنشور في الأعلى'),
              value: _isPinned,
              onChanged: (val) => setState(() => _isPinned = val),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                ),
                onPressed: _publishPost,
                child: const Text('نشر الآن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
