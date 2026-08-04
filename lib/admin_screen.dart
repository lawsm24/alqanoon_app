import 'package:flutter/material.dart';
import 'firebase_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _fileUrlController = TextEditingController(); // رابط الصورة أو الملف
  bool _isPinned = false;
  bool _isLoading = false;
  String _selectedFileType = 'none';

  void _publishNews() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول المطلوب')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseService.addNews(
        title: _titleController.text,
        content: _contentController.text,
        isPinned: _isPinned,
        fileUrl: _fileUrlController.text.isNotEmpty ? _fileUrlController.text : null,
        fileType: _selectedFileType,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم نشر الخبر للمستخدمين بنجاح!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ في النشر: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الآدمن - النشر'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إضافة خبر أو منشور جديد',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان الخبر',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'تفاصيل الخبر / النص',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _fileUrlController,
              decoration: const InputDecoration(
                labelText: 'رابط الصورة أو المستند (اختياري)',
                hintText: 'https://example.com/image.png',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('نوع الملف المرفق: '),
                DropdownButton<String>(
                  value: _selectedFileType,
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('بدون مرفق')),
                    DropdownMenuItem(value: 'image', child: Text('صورة')),
                    DropdownMenuItem(value: 'pdf', child: Text('مستند/PDF')),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedFileType = val ?? 'none');
                  },
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text('تثبيت الخبر في أعلى القائمة؟'),
              value: _isPinned,
              onChanged: (val) => setState(() => _isPinned = val ?? false),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: _isLoading ? null : _publishNews,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('نشر إلى جميع المستخدمين', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
