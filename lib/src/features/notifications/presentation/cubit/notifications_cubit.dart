import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/services/notification_service.dart';
import 'package:m_kemet/src/features/notifications/domain/entities/notification_entity.dart';
import 'package:m_kemet/src/features/notifications/domain/usecases/delete_all_notifications_usecase.dart';
import 'package:m_kemet/src/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:m_kemet/src/features/notifications/domain/usecases/get_notification_status_usecase.dart';
import 'package:m_kemet/src/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:m_kemet/src/features/notifications/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:m_kemet/src/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:m_kemet/src/features/notifications/domain/usecases/set_notification_status_usecase.dart';
import 'package:m_kemet/src/features/notifications/presentation/cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final DeleteAllNotificationsUseCase deleteAllNotificationsUseCase;
  final GetNotificationStatusUseCase getNotificationStatusUseCase;
  final SetNotificationStatusUseCase setNotificationStatusUseCase;

  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
    required this.deleteNotificationUseCase,
    required this.deleteAllNotificationsUseCase,
    required this.getNotificationStatusUseCase,
    required this.setNotificationStatusUseCase,
  }) : super(NotificationsState(
          notificationsEnabled: NotificationService().isNotificationsEnabled(),
        ));

  Future<void> loadNotifications() async {
    if (isClosed) return;
    emit(state.copyWith(status: NotificationListStatus.loading));

    final result = await getNotificationsUseCase();
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: NotificationListStatus.failure,
          errorMessage: () => failure.serverException.message,
        ));
      },
      (notifications) {
        emit(state.copyWith(
          status: NotificationListStatus.success,
          notifications: notifications,
          errorMessage: () => null,
        ));
      },
    );

    // Also fetch status quietly
    loadNotificationStatus();
  }

  Future<void> loadNotificationStatus() async {
    // 1. Check local preference - in normal state (null or true), default is TRUE (ON).
    // If the user explicitly disabled it (false), it stays FALSE (OFF).
    final localVal = CacheStorage.read(NotificationService.notificationSettingKey);
    final isExplicitlyDisabled = localVal == false;

    if (isExplicitlyDisabled) {
      emit(state.copyWith(notificationsEnabled: false));
    } else {
      // Normal state: default to enabled (true)
      emit(state.copyWith(notificationsEnabled: true));
      if (localVal == null) {
        await CacheStorage.write(NotificationService.notificationSettingKey, true);
      }
    }

    // 2. Fetch backend status
    final result = await getNotificationStatusUseCase();
    if (isClosed) return;

    result.fold(
      (_) {
        // Keep current state on error
      },
      (backendEnabled) {
        final currentLocal = CacheStorage.read(NotificationService.notificationSettingKey);
        if (currentLocal == false) {
          // User explicitly disabled it: keep it OFF, and sync backend to OFF if needed
          emit(state.copyWith(notificationsEnabled: false));
          if (backendEnabled) {
            setNotificationStatusUseCase(false);
          }
        } else {
          // Normal state: keep enabled, and sync backend to ON if needed
          emit(state.copyWith(notificationsEnabled: true));
          if (!backendEnabled) {
            setNotificationStatusUseCase(true);
          }
        }
      },
    );
  }

  Future<bool> toggleNotificationStatus(bool enable) async {
    if (isClosed) return state.notificationsEnabled;
    final previous = state.notificationsEnabled;

    // 1. Save local preference immediately
    await NotificationService().setNotificationsEnabled(enable: enable);

    // 2. Optimistic update — immediate state change with 0 delay
    emit(state.copyWith(
      notificationsEnabled: enable,
      isTogglingStatus: true,
      errorMessage: () => null,
    ));

    // 3. Call backend in background
    final result = await setNotificationStatusUseCase(enable);
    if (isClosed) return enable;

    return result.fold(
      (failure) {
        // Rollback on failure
        NotificationService().setNotificationsEnabled(enable: previous);
        emit(state.copyWith(
          notificationsEnabled: previous,
          isTogglingStatus: false,
          errorMessage: () => failure.serverException.message,
        ));
        return previous;
      },
      (newStatus) {
        emit(state.copyWith(
          notificationsEnabled: newStatus,
          isTogglingStatus: false,
        ));
        return newStatus;
      },
    );
  }

  void setFilter(int index) {
    emit(state.copyWith(selectedFilterIndex: index));
  }

  Future<void> markAsRead(String id) async {
    // 1. Optimistic update
    final updated = state.notifications.map((n) {
      if (n.id == id && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    emit(state.copyWith(notifications: updated));

    // 2. Call backend
    await markNotificationAsReadUseCase(id);
  }

  Future<void> markAllAsRead() async {
    // 1. Optimistic update
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(state.copyWith(
      notifications: updated,
      successMessage: () => S.current.notificationsMarkAllSuccess,
    ));

    // 2. Call backend
    final result = await markAllNotificationsAsReadUseCase();
    result.fold(
      (failure) {
        // We do not roll back to avoid jarring UX, but notify error if needed
      },
      (_) {},
    );
  }

  Future<void> deleteNotification(String id) async {
    // 1. Optimistic removal
    final updated = List<NotificationEntity>.from(state.notifications)
      ..removeWhere((n) => n.id == id);
    emit(state.copyWith(notifications: updated));

    // 2. Call backend
    await deleteNotificationUseCase(id);
  }

  void restoreNotification(int index, NotificationEntity item) {
    final updated = List<NotificationEntity>.from(state.notifications);
    if (index >= 0 && index <= updated.length) {
      updated.insert(index, item);
    } else {
      updated.add(item);
    }
    emit(state.copyWith(notifications: updated));
  }

  Future<void> deleteAllNotifications() async {
    // 1. Optimistic clear
    emit(state.copyWith(
      notifications: [],
      successMessage: () => S.current.notificationsDeleteAllSuccess,
    ));

    // 2. Call backend
    await deleteAllNotificationsUseCase();
  }
}
