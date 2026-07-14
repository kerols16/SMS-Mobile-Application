# EduManage — School Management System

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-API-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![BLoC](https://img.shields.io/badge/State-BLoC%2FCubit-8C4FFF?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**A full-scale multi-role school management mobile app built with Flutter.**  
Admin · Teacher · Student · Parent — each with a dedicated, API-connected dashboard.

</div>

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure-highlights)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
- [API](#api)
- [Team](#team)

---

## Overview

EduManage replaces manual school management (paper records, Excel sheets, WhatsApp groups) with a centralized digital platform. The app serves four distinct roles with tailored dashboards and role-based access control — all powered by a Laravel REST API with Sanctum token authentication.

---

## Features

### 🛡️ Admin / Super Admin
- Full CRUD for users, students, teachers, and parents
- Classroom management — create, edit, delete classrooms
- Classroom relationships — enroll students, assign teachers with roles (homeroom / subject teacher / assistant), assign subjects with weekly hours
- Inline role change and weekly hours update without removing and re-assigning
- Subject and schedule management
- Notifications center with unread badge and mark-as-read
- Real-time profile loaded from `GET /api/auth/me`

### 👨‍🏫 Teacher
- View assigned classrooms and enrolled students
- Mark and update daily attendance with status: present / absent / late / excused
- Parent messaging system — compose, send, and read messages by type (academic / behavioral / attendance / urgent / general)
- Unread message badge on notification bell
- Dashboard with today's attendance summary

### 🎒 Student *(UI ready)*
- View grades, schedule, assignments
- Submit assignments

### 👪 Parent *(UI ready)*
- View child progress, grades, and attendance
- Message teachers directly

---

## Architecture

```
lib/
├── core/
│   ├── constants/        # ApiConstants, Routes, StorageKeys
│   ├── di/               # GetIt dependency injection
│   ├── network/          # DioClient with Bearer token interceptor
│   ├── router/           # go_router with role-based redirect
│   ├── storage/          # LocalStorage (SharedPreferences wrapper)
│   ├── bloc/             # Shared base states (BaseOperationSuccess, etc.)
│   ├── utils/            # handleDioError() — shared error handler
│   └── widgets/          # BottomNav, reusable components
├── features/
│   ├── auth/             # Login, token storage, role routing
│   ├── admin/            # Full CRUD + classroom relationships
│   ├── teacher/          # Attendance, messaging, classes
│   ├── student/          # Grades, schedule, assignments (UI)
│   └── parent/           # Child progress, messaging (UI)
└── main.dart
```

Each feature follows a strict **3-layer pattern**:

```
feature/
├── data/
│   ├── models/           # fromJson / toJson models
│   └── *_service.dart    # Dio API calls
├── view_model/
│   └── cubit/            # Cubit + State (BLoC pattern)
└── view/
    ├── pages/            # Dashboard pages
    ├── tabs/             # Individual tab widgets
    ├── sheets/           # Modal bottom sheets / forms
    └── utils/            # Helper widgets
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | Flutter 3.x + Dart |
| State Management | BLoC / Cubit (flutter_bloc) |
| HTTP Client | Dio with interceptor |
| Navigation | go_router (role-based redirect) |
| Local Storage | SharedPreferences |
| Dependency Injection | get_it |
| Backend | Laravel + Sanctum (REST API) |
| Authentication | Bearer token |

---

## Project Structure Highlights

### Role-based routing
```dart
// app_router.dart
redirect: (context, state) async {
  final token = await LocalStorage.getToken();
  if (token == null) return Routes.login;
  final role = await LocalStorage.getRole();
  if (role == 'admin' || role == 'super_admin') return Routes.admin;
  return '/$role';
}
```

### Shared error handler
```dart
// core/utils/dio_error_handler.dart
String handleDioError(DioException e) {
  switch (e.response?.statusCode) {
    case 401: return 'Unauthorized access';
    case 403: return 'You do not have permission';
    case 422: return 'Invalid data, please check your input';
    // ...
  }
}
```

### Classroom relationships
The app supports full classroom relationship management via dedicated endpoints:
- `POST /classroom-relationships/enroll-student`
- `POST /classroom-relationships/assign-teacher`
- `POST /classroom-relationships/assign-subject`
- `PUT /classroom-relationships/update-teacher-role`
- `PUT /classroom-relationships/change-subject-teacher`
- `PUT /classroom-relationships/update-subject-hours`

---

## Screenshots
#### Admin UI
| Login | Admin Dashboard | Academics Details | Users |
|--------|--------|--------|--------|
| <img src="https://github.com/user-attachments/assets/c477fc82-4369-45d9-a546-088a40e38c24" height="500"> | <img src="https://github.com/user-attachments/assets/4c081041-e171-45b1-8b5d-461f00383d80" height="500"> | <img src="https://github.com/user-attachments/assets/5b0e4ec3-b882-4860-b3da-7a93232140df" height="500"> | <img  height="500" alt="image" src="https://github.com/user-attachments/assets/55d82c98-9a7c-4add-8b6b-7f4f00959440" />

---
#### Teacher UI
| Teacher Dashboard | Classes | Messages | Exams |
|--------|--------|--------|--------|
| <img src="https://github.com/user-attachments/assets/ed12b64b-0747-4b32-8f87-2825eed06e6d" height="500"> | <img src="https://github.com/user-attachments/assets/2f9ad745-411e-4fc8-8cfa-e46fbd0bb47a" height="500"> | <img src="https://github.com/user-attachments/assets/a8e6ab2d-7920-4bdc-b0d0-6cc757da3e77" height="500"> | <img height="500" alt="image" src="https://github.com/user-attachments/assets/9cb5c621-756b-4967-a044-1c32afb92c3b" />

---
#### Student UI
| Student Dashboard | Student Grades | Assignments | Academics |
|--------|--------|--------|--------|
| <img  height="500" alt="image" src="https://github.com/user-attachments/assets/19b98949-6c1d-4444-8ac5-f3664b784090" /> | <img  height="500" alt="image" src="https://github.com/user-attachments/assets/9b625c87-7b85-43ec-b10e-f31b7856459a" /> | <img height="500" alt="image" src="https://github.com/user-attachments/assets/7a694f74-6027-4b46-93ad-e3b81c54d046" /> |<img  height="500" alt="image" src="https://github.com/user-attachments/assets/e7ce56a5-6b9b-4e97-adb7-3f8c34a5f649" />
  



## Getting Started

### Prerequisites
- Flutter 3.x
- Dart 3.x
- A running instance of the Laravel backend

### Installation

```bash
# Clone the repo
git clone https://github.com/your-username/edumanage.git
cd edumanage

# Install dependencies
flutter pub get

# Set your API base URL in:
# lib/core/constants/api_constants.dart
static const String baseUrl = 'https://your-domain.com';

# Run the app
flutter run
```

### Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.x
  dio: ^5.x
  go_router: ^13.x
  get_it: ^7.x
  shared_preferences: ^2.x
  equatable: ^2.x
  shimmer: ^3.x
```

---

## API

The app connects to a Laravel REST API with the following key endpoint groups:

| Group | Base Path |
|---|---|
| Auth | `/api/auth/login`, `/api/auth/me`, `/api/auth/logout` |
| Users | `/api/users` |
| Students | `/api/students` |
| Teachers | `/api/teachers`, `/api/teachers/me/classrooms` |
| Parents | `/api/parents` |
| Classrooms | `/api/classrooms` |
| Classroom Relationships | `/api/classroom-relationships/*` |
| Subjects | `/api/subjects` |
| Schedules | `/api/schedules` |
| Attendance | `/api/attendances` |
| Assignments | `/api/assignments` |
| Messages | `/api/messages` |
| Notifications | `/api/notifications` |

All endpoints require `Authorization: Bearer {token}` header.

---

## Team

| Name | ID |
|---|---|
| Kerols Hany Rauf | 202220035 |
| Youssef Ayman Sayed | 202220169 |
| Anas Khaled Ahmed | 202220003 |
| Khaled Alaa Mohamed | 202220041 |
| Youssef Khaled Hussein | 202220084 |
| Pola Fleem Mekhael | 202220005 |

**Supervisor:** Dr. Rasha Elnemr

---

<div align="center">
  Made with ❤️ using Flutter
</div>
