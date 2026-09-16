import 'package:intl/intl.dart';
import 'package:m_kemet/src/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.createdAt,
    required super.isRead,
    super.actionRoute,
    super.type,
    super.timeAgo,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // 1. Parse id
    final id = (json['id'] ?? json['_id'] ?? '').toString();

    // 2. Nested data payload (standard in Laravel notifications: json['data'])
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    // 3. Parse title
    final title = (json['title'] ??
            data['title'] ??
            json['subject'] ??
            data['subject'] ??
            'إشعار جديد')
        .toString();

    // 4. Parse body / message
    final body = (json['body'] ??
            json['message'] ??
            data['message'] ??
            data['body'] ??
            json['content'] ??
            data['content'] ??
            '')
        .toString();

    // 5. Parse isRead
    final bool isRead;
    if (json['read_at'] != null || data['read_at'] != null) {
      isRead = true;
    } else if (json['is_read'] != null) {
      isRead = json['is_read'] == true ||
          json['is_read'] == 1 ||
          json['is_read'] == '1';
    } else if (data['is_read'] != null) {
      isRead = data['is_read'] == true ||
          data['is_read'] == 1 ||
          data['is_read'] == '1';
    } else {
      isRead = false;
    }

    // 6. Parse createdAt
    final rawDate = json['created_at'] ?? data['created_at'];
    DateTime createdAt = DateTime.now();
    if (rawDate != null) {
      createdAt = DateTime.tryParse(rawDate.toString())?.toLocal() ?? DateTime.now();
    }

    // 7. Parse type
    final type = (json['type'] ?? data['type'] ?? _inferType(title, body))?.toString();

    // 8. Parse action route
    final actionRoute = (json['action_route'] ??
            data['action_route'] ??
            json['route'] ??
            data['route'])
        ?.toString();

    // 9. Relative time
    final timeAgo = _formatTimeAgo(createdAt);

    return NotificationModel(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead,
      actionRoute: actionRoute,
      type: type,
      timeAgo: timeAgo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'action_route': actionRoute,
      'type': type,
    };
  }

  static String _inferType(String title, String body) {
    final text = '$title $body'.toLowerCase();
    if (text.contains('طلب') || text.contains('تواصل') || text.contains('request') || text.contains('interview')) {
      return 'request';
    }
    if (text.contains('اعتماد') || text.contains('تفعيل') || text.contains('موافقة') || text.contains('approved')) {
      return 'approval';
    }
    if (text.contains('حالة') || text.contains('رفض') || text.contains('status') || text.contains('rejected')) {
      return 'status';
    }
    if (text.contains('أمان') || text.contains('دخول') || text.contains('كلمة المرور') || text.contains('security')) {
      return 'security';
    }
    return 'tip';
  }

  static String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    final isEn = Intl.getCurrentLocale().toLowerCase().startsWith('en');

    if (diff.inSeconds < 60) {
      return isEn ? 'Just now' : 'الآن';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      if (isEn) {
        return m == 1 ? '1 min ago' : '$m mins ago';
      }
      if (m == 1) return 'منذ دقيقة';
      if (m == 2) return 'منذ دقيقتين';
      if (m <= 10) return 'منذ $m دقائق';
      return 'منذ $m دقيقة';
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      if (isEn) {
        return h == 1 ? '1 hour ago' : '$h hours ago';
      }
      if (h == 1) return 'منذ ساعة';
      if (h == 2) return 'منذ ساعتين';
      if (h <= 10) return 'منذ $h ساعات';
      return 'منذ $h ساعة';
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      if (isEn) {
        return d == 1 ? 'Yesterday' : '$d days ago';
      }
      if (d == 1) return 'أمس';
      if (d == 2) return 'منذ يومين';
      if (d <= 10) return 'منذ $d أيام';
      return 'منذ $d يوم';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
