import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // تهيئة الإشعارات الفورية
  static Future<void> initNotifications() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _messaging.subscribeToTopic('all_users');
    }
  }

  // جلب الأخبار بشكل حي ومباشر
  static Stream<QuerySnapshot> getNewsStream() {
    return _db.collection('news').orderBy('createdAt', descending: true).snapshots();
  }

  // إضافة خبر جديد من الآدمن
  static Future<void> addNews({
    required String title,
    required String content,
    required bool isPinned,
    String? fileUrl,
    String? fileType,
  }) async {
    await _db.collection('news').add({
      'title': title,
      'content': content,
      'isPinned': isPinned,
      'fileUrl': fileUrl ?? '',
      'fileType': fileType ?? '', // 'image' أو 'pdf'
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
