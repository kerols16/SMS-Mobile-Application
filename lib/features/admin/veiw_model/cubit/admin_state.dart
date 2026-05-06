part of 'admin_cubit.dart';

abstract class AdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminLoaded extends AdminState {
  final List<AdminUserModel>         users;
  final List<AdminStudentModel>      students;
  final List<AdminTeacherModel>      teachers;
  final List<AdminParentModel>       parents;
  final List<AdminNotificationModel> notifications;
  final int                          unreadCount;

  AdminLoaded({
    required this.users,
    required this.students,
    required this.teachers,
    required this.parents,
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [users, students, teachers, parents, notifications, unreadCount];

  // used for partial updates without reloading everything
  AdminLoaded copyWith({
    List<AdminUserModel>?         users,
    List<AdminStudentModel>?      students,
    List<AdminTeacherModel>?      teachers,
    List<AdminParentModel>?       parents,
    List<AdminNotificationModel>? notifications,
    int?                          unreadCount,
  }) {
    return AdminLoaded(
      users:         users         ?? this.users,
      students:      students      ?? this.students,
      teachers:      teachers      ?? this.teachers,
      parents:       parents       ?? this.parents,
      notifications: notifications ?? this.notifications,
      unreadCount:   unreadCount   ?? this.unreadCount,
    );
  }
}

// operation states — for create / update / delete
class AdminOperationLoading extends AdminState {}

class AdminOperationSuccess extends AdminState {
  final String message;
  AdminOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminOperationError extends AdminState {
  final String message;
  AdminOperationError(this.message);

  @override
  List<Object?> get props => [message];
}
// User Details States
class AdminUserDetailsLoading extends AdminState {}

class AdminUserDetailsLoaded extends AdminState {
  final AdminUserModel         user;
  final AdminStudentModel?     student;
  final AdminTeacherModel?     teacher;
  final AdminParentModel?      parent;

  AdminUserDetailsLoaded({
    required this.user,
    this.student,
    this.teacher,
    this.parent,
  });

  @override
  List<Object?> get props => [user, student, teacher, parent];
}

class AdminUserDetailsError extends AdminState {
  final String message;
  AdminUserDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}