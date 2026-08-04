import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منصة القانون'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.getNewsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('لا توجد أخبار أو تبليغات حصرية حالياً'),
            );
          }

          final newsDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: newsDocs.length,
            itemBuilder: (context, index) {
              final data = newsDocs[index].data() as Map<String, dynamic>;
              final isPinned = data['isPinned'] ?? false;
              final fileUrl = data['fileUrl'] as String?;
              final fileType = data['fileType'] as String?;

              return Card(
                color: isPinned ? Colors.amber.shade50 : Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isPinned ? Icons.push_pin : Icons.article,
                            color: isPinned ? Colors.amber : Colors.indigo,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              data['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(data['content'] ?? ''),
                      if (fileUrl != null && fileUrl.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        if (fileType == 'image')
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              fileUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        else if (fileType == 'pdf')
                          ElevatedButton.icon(
                            onPressed: () {
                              // إتاحة فتح المستند
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('عرض المستند / الملف المرفق'),
                          ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
