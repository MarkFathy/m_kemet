/// Represents an in-app notification entity.
class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? actionRoute;
  final String? type; // 'request', 'approval', 'status', 'security', 'tip'
  final String? timeAgo;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    this.actionRoute,
    this.type,
    this.timeAgo,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? actionRoute,
    String? type,
    String? timeAgo,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      type: type ?? this.type,
      timeAgo: timeAgo ?? this.timeAgo,
    );
  }
}
