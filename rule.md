# MASTER PROJECT PROMPT — EduManage Flutter Application v2
# AI Agent & Developer Constitution
# ⚠️ API STATUS: PARTIALLY DOCUMENTED — SEE SECTION "API CONTRACT" BELOW

---

## ANTI-HALLUCINATION RULE — READ FIRST

All code, class names, file paths, and patterns must be derived ONLY from what is explicitly stated in this document.
Do NOT invent endpoints, fields, or responses beyond what is documented here.
Do NOT assume the contents of files not shown to you.
For any undocumented API section: implement a local mock — never guess real endpoints.
If uncertain — say so. Never fill gaps with assumptions.

---

## PROJECT OVERVIEW

- Name: EduManage — School Management System
- Type: Multi-role Flutter mobile application
- Current state: UI-only demo (hardcoded mock data, setState only)
- Goal: Migrate to full Clean Architecture with real API integration
- Deadline: Next week delivery
- Team: 1 Flutter dev + 1 Web frontend dev + 1 Backend dev

---

## API STATUS — CRITICAL

⚠️ The backend API is NOT fully complete yet. The sections below show what is currently documented and ready.

### READY endpoints (use real Dio calls for these):
- Auth: login, logout, get current user
- Users: CRUD
- Students: CRUD + search
- Teachers: CRUD + search
- Parents: CRUD + search
- File Upload: single, multiple, delete
- Notifications: list, unread count, mark read, delete

### NOT YET READY (backend in progress — use mock data layer):
- Grades / Report Cards
- Attendance
- Exams / Online Exams
- Assignments / Study Materials
- Schedules / Timetables
- Fees / Payments
- School Bus / Transport / GPS
- AI Insights / Reports
- Class & Subject Management
- Analytics

### HANDLING STRATEGY FOR INCOMPLETE API:
For every NOT-YET-READY feature, implement a MockRemoteDataSource that:
1. Implements the same abstract DataSource interface as the real one
2. Returns hardcoded realistic data with a 500ms artificial delay
3. Can be swapped for a real datasource by changing ONE LINE in injection_container.dart
4. Is clearly marked with // TODO: Replace with RealRemoteDataSource when API is ready

Example pattern:
  abstract class GradesRemoteDataSource {
    Future> getGrades(int studentId);
  }

  class MockGradesRemoteDataSource implements GradesRemoteDataSource {
    Future> getGrades(int studentId) async {
      await Future.delayed(const Duration(milliseconds: 500));
      return [ /* hardcoded realistic data */ ];
    }
  }

  // In injection_container.dart:
  // TODO: Replace with RealGradesRemoteDataSource when API is ready
  sl.registerLazySingleton(() => MockGradesRemoteDataSource());

---

## CURRENT PROJECT STRUCTURE (as-is)

lib/
├── main.dart
└── view/
    └── screens/
        ├── login_screen.dart
        ├── admin_dashboard.dart
        ├── teacher_dashboard.dart
        ├── student_dashboard.dart
        ├── parent_dashboard.dart
        └── widgets/
            └── bottom_nav.dart

Current screens and routes:
- LoginScreen       → route: "/"
- AdminDashboard    → route: "/admin"
- TeacherDashboard  → route: "/teacher"
- StudentDashboard  → route: "/student"
- ParentDashboard   → route: "/parent"

---

## TARGET ARCHITECTURE

Pattern: Clean Architecture + Feature-first folder structure
State management: flutter_bloc (Bloc with Events — NOT Cubit)
DI: get_it
Networking: dio
Navigation: go_router
Storage: flutter_secure_storage (JWT), shared_preferences (non-sensitive)
Equality: equatable

Target folder structure:
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── router/
│   ├── di/
│   ├── network/
│   └── errors/
└── features/
    ├── auth/
    ├── admin/
    ├── teacher/
    ├── student/
    └── parent/

Each feature follows:
feature/
├── data/
│   ├── models/
│   ├── datasources/         ← real AND mock datasources live here
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── screens/
    └── widgets/

---

## REQUIRED PACKAGES

flutter_bloc       → State management (Bloc + Events)
dio                → HTTP client
go_router          → Navigation
get_it             → Dependency injection
flutter_secure_storage → Store JWT token securely
equatable          → Compare states and events

---

## API CONTRACT (CONFIRMED — BACKEND READY)

Base URL: http://your-domain.com/api
Auth: Laravel Sanctum — Bearer token in Authorization header

### AUTH ENDPOINTS

POST /auth/login
  Request:  { "email": string, "password": string }
  Response 200:
    { "success": true, "data": { "token": string, "user": UserModel } }
  Response 401:
    { "success": false, "message": "Invalid credentials" }

POST /auth/logout
  Headers: Authorization Bearer
  Response 200: { "success": true, "message": "Logged out successfully" }

GET /auth/me
  Headers: Authorization Bearer
  Response 200: { "success": true, "data": UserModel }

### USER MODEL (returned in auth and user endpoints)
{
  "id": int,
  "name": string,
  "email": string,
  "role": "admin" | "teacher" | "student" | "parent" | "super_admin",
  "email_verified_at": string | null,
  "created_at": string,
  "updated_at": string
}

### USER ENDPOINTS (admin/super_admin only)

GET    /users               → List
POST   /users               → Create user → UserModel
GET    /users/{id}          → UserModel
PUT    /users/{id}          → Update user → UserModel
DELETE /users/{id}          → { "success": true, "message": string }

Create/Update fields: name, email, password, role
Roles allowed: admin, teacher, student, parent, super_admin
Forbidden: admin cannot create/delete admin or super_admin

### STUDENT MODEL
{
  "id": int,
  "user_id": int,
  "student_id": string,       ← e.g. "STU001"
  "date_of_birth": string | null,
  "gender": "male" | "female" | "other" | null,
  "address": string | null,
  "phone": string | null,
  "enrollment_date": string | null,
  "created_at": string,
  "updated_at": string,
  "user": UserModel           ← nested
}

### STUDENT ENDPOINTS (admin/super_admin only)
GET    /students?search=     → List
POST   /students             → Create student + user → StudentModel
GET    /students/{id}        → StudentModel
PUT    /students/{id}        → Update student → StudentModel
DELETE /students/{id}        → success message

Create required: name, email, password, student_id
Create optional: date_of_birth, gender, address, phone, enrollment_date

### TEACHER MODEL
{
  "id": int,
  "user_id": int,
  "teacher_id": string,
  "date_of_birth": string | null,
  "gender": "male" | "female" | "other" | null,
  "address": string | null,
  "phone": string | null,
  "hire_date": string | null,
  "qualification": string | null,
  "subject_specialization": string | null,
  "created_at": string,
  "updated_at": string,
  "user": UserModel
}

### TEACHER ENDPOINTS (admin/super_admin only)
GET    /teachers?search=     → List
POST   /teachers             → TeacherModel
GET    /teachers/{id}        → TeacherModel
PUT    /teachers/{id}        → TeacherModel
DELETE /teachers/{id}        → success message

### PARENT MODEL
{
  "id": int,
  "user_id": int,
  "parent_id": string,
  "phone": string | null,
  "address": string | null,
  "occupation": string | null,
  "created_at": string,
  "updated_at": string,
  "user": UserModel
}

### PARENT ENDPOINTS (admin/super_admin only)
GET    /parents?search=      → List
POST   /parents              → ParentModel
GET    /parents/{id}         → ParentModel
PUT    /parents/{id}         → ParentModel
DELETE /parents/{id}         → success message

### FILE UPLOAD ENDPOINTS
POST /files/upload
  Body: multipart/form-data, field: "file"
  Max: 10MB, types: jpg, jpeg, png, gif, pdf, doc, docx, xls, xlsx, txt
  Response: { path, url, size, mime_type, original_name }

POST /files/upload-multiple
  Body: multipart/form-data, field: "files[]", max 10 files
  Response: List of file objects above

DELETE /files/delete
  Body: { "path": string }
  Response: success message

### NOTIFICATION MODEL
{
  "id": int,
  "user_id": int,
  "type": "info" | "alert" | "warning",
  "title": string,
  "message": string,
  "data": object | null,
  "link": string | null,
  "is_read": bool,
  "read_at": string | null,
  "created_at": string,
  "updated_at": string
}

### NOTIFICATION ENDPOINTS
GET    /notifications                         → List
GET    /notifications/unread-count            → { "unread_count": int }
POST   /notifications/mark-all-read          → { "marked_count": int }
GET    /notifications/{id}                    → NotificationModel
POST   /notifications/{id}/mark-read         → NotificationModel updated
DELETE /notifications/{id}                    → success message

### ERROR RESPONSE FORMAT (all endpoints)
{
  "success": false,
  "message": string,
  "errors": { "field": ["error message"] }   ← only on 422
}

HTTP Status codes used: 200, 201, 401, 403, 404, 422, 500

### ROLE-BASED ACCESS
super_admin → full access to everything
admin       → manage teachers, students, parents (cannot touch admins/super_admins)
teacher     → no user management access
student     → no user management access
parent      → no user management access

Special rules:
- User cannot delete their own account
- Only super_admin can delete admins or super_admins

---

## SYSTEM FEATURES PER ROLE

### Admin
- Add / Edit / Delete users (students, teachers, parents, staff)
- Manage roles and permissions
- Manage classes, subjects, schedules        ← API NOT READY: use mock
- Manage exams and publish results           ← API NOT READY: use mock
- Manage fees and payments                   ← API NOT READY: use mock
- Generate reports (attendance, grades)      ← API NOT READY: use mock
- View analytics and AI reports              ← API NOT READY: use mock
- Send notifications                         ← use /notifications
- Manage transport assignments               ← API NOT READY: use mock
- Backup and restore                         ← API NOT READY: use mock

### Teacher
- Record attendance                          ← API NOT READY: use mock
- Manage grades and exams                    ← API NOT READY: use mock
- Upload assignments/materials               ← use /files/upload
- Communicate with students/parents          ← API NOT READY: use mock
- View AI insights                           ← API NOT READY: use mock
- View class schedules                       ← API NOT READY: use mock

### Student
- View timetable and attendance              ← API NOT READY: use mock
- View grades and report cards               ← API NOT READY: use mock
- Download assignments                       ← API NOT READY: use mock
- Submit homework                            ← use /files/upload
- View notifications                         ← use /notifications
- Take online exams                          ← API NOT READY: use mock
- Track school bus status                    ← API NOT READY: use mock

### Parent
- Track child attendance and grades          ← API NOT READY: use mock
- Communicate with teachers                  ← API NOT READY: use mock
- Pay school fees                            ← API NOT READY: use mock
- View payment history                       ← API NOT READY: use mock
- View notifications                         ← use /notifications
- Track school bus location                  ← API NOT READY: use mock

---

## DEVELOPER PROFILE

- Knows: Clean Architecture concept, Bloc (50%), REST APIs (60%), Routing (40%)
- Learning: DI (new), Bloc event wiring, go_router
- Goal: Understand the WHY behind every decision, not just copy code
- Preference: Explain reasoning before code whenever introducing a new concept

---

## EXECUTION PHASES — FOLLOW IN ORDER

PHASE 1 — Analyze:  Read current structure and all provided code. Understand before touching.
PHASE 2 — Architect: Design full feature-first Clean Architecture. Document every decision with rationale.
PHASE 3 — Generate RULES.md: Write project constitution following all 20 sections below.
PHASE 4 — Implement: Generate production-ready code per layer. Start with core/, then auth feature, then remaining features.

For each feature, state clearly at the top:
  // API STATUS: READY — uses RealRemoteDataSource
  // API STATUS: PENDING — uses MockRemoteDataSource (swap when API is ready)

---

## RULES.md — 20 REQUIRED SECTIONS

Generate a single complete RULES.md with ALL sections below.
Every rule must trace to this document.
Every code example: copy-paste ready, syntactically valid Dart, real class names.

SECTION 0  — Section Index
SECTION 1  — Project Architecture (folder tree, responsibilities, extension rules)
SECTION 2  — Architectural Decisions & Rationale (decision + one-line why)
SECTION 3  — State Management: Bloc + Events pattern, full triple example
SECTION 4  — Dependency Injection: get_it setup, registration types, order rule
SECTION 5  — Networking: Dio setup, JWT interceptor, ApiResult, error handling
SECTION 6  — Routing: go_router setup, named routes, auth redirect, role routing
SECTION 7  — Data Models: serialization pattern, entity vs model, request/response examples
SECTION 8  — Domain Layer: UseCase pattern, repository interface, entity rules
SECTION 9  — Storage: flutter_secure_storage (JWT) vs shared_preferences (prefs)
SECTION 10 — Theming: color/text conventions, no inline styles rule
SECTION 11 — UI Conventions: widget types, BlocListener/BlocBuilder patterns, spacing
SECTION 12 — Naming Conventions: full table covering all file and class types
SECTION 13 — Authentication Flow: JWT storage, token injection, role-based routing, logout
SECTION 14 — Error Handling: AppFailure hierarchy, repo return types, UI display
SECTION 15 — Extensions: location, available extensions, extension-only rule
SECTION 16 — Technical Debt Register: all known violations (setState, hardcoded data, no DI, no routing, no error handling)
SECTION 17 — Forbidden Patterns: DO/DON'T Dart examples for every banned pattern
SECTION 18 — How to Add a New Feature: numbered checklist, one file per step
SECTION 19 — Golden Path Example: "Student Grades" feature — end-to-end, every file, real class names, mock datasource since API is not ready
SECTION 20 — Code Review Checklist: architecture, state, networking, DI, routing, models, UI, storage

---

## CONFIDENCE LEVELS (required on every major section)

[HIGH]   — clear and consistent across the document
[MEDIUM] — inferred from partial evidence
[LOW]    — one occurrence or uncertain — explain why, mark rules as [Proposed Standard]

---

## CONFLICT RESOLUTION RULE

Dominant pattern = project standard.
Minority pattern = Technical Debt entry in Section 16.
Never document a minority pattern as the rule.

---

## FINAL OUTPUT REQUIREMENTS

- Single file: RULES.md
- All 20 sections present and complete
- Copy-paste ready Dart throughout — no pseudo-code, no placeholder names
- Strict and specific — no vague language
- Complete enough that a new developer can work on this project without a single clarifying question