import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/notifications/domain/entities/notification_entity.dart';

enum NotificationListStatus { initial, loading, success, failure }

class NotificationsState extends Equatable {
  final NotificationListStatus status;
  final List<NotificationEntity> notifications;
  final int selectedFilterIndex; // 0: All, 1: Unread
  final bool notificationsEnabled;
  final bool isTogglingStatus;
  final String? errorMessage;
  final String? successMessage;

  const NotificationsState({
    this.status = NotificationListStatus.initial,
    this.notifications = const [],
    this.selectedFilterIndex = 0,
    this.notificationsEnabled = true,
    this.isTogglingStatus = false,
    this.errorMessage,
    this.successMessage,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationEntity> get filteredNotifications {
    if (selectedFilterIndex == 1) {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications;
  }

  NotificationsState copyWith({
    NotificationListStatus? status,
    List<NotificationEntity>? notifications,
    int? selectedFilterIndex,
    bool? notificationsEnabled,
    bool? isTogglingStatus,
    String? Function()? errorMessage,
    String? Function()? successMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isTogglingStatus: isTogglingStatus ?? this.isTogglingStatus,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage: successMessage != null ? successMessage() : this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        notifications,
        selectedFilterIndex,
        notificationsEnabled,
        isTogglingStatus,
        errorMessage,
        successMessage,
      ];
}
