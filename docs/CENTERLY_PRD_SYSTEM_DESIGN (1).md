# Centerly — PRD & System Design (Final Reference)
### Unified technical reference for building the Backend and Mobile App

**Version:** v6.0 — All accounts are managed fully manually + Teacher has a "My Secretaries" tab (view + request removal only)
**Date:** August 2026
**Based on:** Business Source of Truth (MVP v1.0) + UI screens review + all final product decisions.

---

## 0. Decision Log — Final

| # | Decision |
|---|---|
| 1 | Tenant = **Teacher** (not Center). No Owner/Admin role exists. |
| 2 | No Sign Up, no Payment Gateway, no OTP — subscriptions and accounts are **managed entirely manually by the Centerly team**, outside the app. |
| 3 | The **Exams, Assignments, and Payments** tabs are actually inside MVP scope. |
| 4 | Attendance can be marked **starting before the session begins**, up until **30 minutes after the session start time** (`attendance_lock_at`); after that it locks. |
| 5 | **Only the Secretary** enters exam scores and assignment statuses. |
| 6 | **Cancelling a session** is available to **both the Teacher and the Secretary**. |
| 7 | The "Create Account" button on the Login screen is replaced with **"Contact Us"**. |
| 8 | ❌ **There is no in-app screen or API to create/manage Secretary accounts.** The subscription comes with a fixed number of Secretary seats (e.g. 2). The Centerly team creates the accounts manually and sends the credentials directly by email. If the Teacher wants an extra Secretary beyond the plan's quota, they use the same **"Contact Us"** link. |
| 9 | Sessions are auto-generated from the Schedule with a **rolling 1-week-ahead window**. |
| 10 | Students left as `not_marked` when the attendance edit window closes **are automatically converted to `absent`**. |
| 11 | 🆕 The Teacher has a **"My Secretaries"** tab in the dashboard: a read-only list of their secretaries, plus the ability to **submit a removal request** for any of them. This request is **not a direct deactivation** — it reaches the Centerly team as a notification/ticket, and they handle it manually (either through the same "Contact Us" channel or a simple internal ticketing system). |

---

## 1. Overview

Centerly is a system that helps **the Teacher who owns the learning center** run their day-to-day operations. **The Secretary enters and manages the data, and the Teacher monitors everything from a Dashboard.**

**All user accounts (Teacher and Secretary) are created 100% manually by the Centerly team.** The app itself **has no account creation/management flow whatsoever** — no Sign Up, no OTP, no "add secretary" screen, nothing. This is a deliberate simplification for the MVP.

**The real customer is the Teacher, not the "Center."** Each teacher = an independent subscription = fully isolated data.

---

## 2. Tenant Model

```
Teacher (= Tenant / subscription owner)
   │
   ├── Secretaries   (fixed count per subscription, created manually by the Centerly team)
   ├── Students
   ├── Groups
   ├── Schedules
   ├── Sessions
   ├── Attendance
   ├── Exams
   ├── Assignments
   ├── Invoices
   └── Teacher Notes
```

- **Teacher = Tenant.** All data is linked directly to `teacher_id`.
- **There is no** `Center` / `center_id` / `Owner` / `Admin` entity.
- **A Secretary belongs to exactly one Teacher.**
- **Isolation is enforced exclusively in the Backend.**
- **JWT Token** carries: `{ user_id, role: "teacher"|"secretary", teacher_id }`.

---

## 3. Subscription & Account Model (fully manual)

```
Teacher contacts the Centerly team (via "Contact Us" button on Login, or entirely outside the app)
        ↓
Agree on a subscription plan — includes a fixed number of Secretary accounts (e.g. plan = 1 Teacher + 2 Secretaries)
        ↓
Payment is handled manually (outside the app)
        ↓
The Centerly team creates the Teacher account + the agreed Secretary accounts (Internal Admin Tool / Script / direct DB seed)
        ↓
The Centerly team sends the credentials (Email + Password) directly to the Teacher and to each Secretary
        ↓
Everyone starts using the app with their own account
```

**Explicit rules:**
- ❌ There is **no** endpoint to create a Teacher or Secretary account from within the app itself.
- ❌ There is no OTP or any additional verification step during account creation — the account is simply created and ready, and the credentials are sent complete.
- ❌ There is no "Manage Secretaries" screen or "Add Secretary" button inside the app.
- ✅ If the Teacher wants to add a Secretary beyond the number agreed upon in their subscription, they use the same **"Contact Us"** link/button (the same one on the Login screen), and the Centerly team handles it manually as well (agree on additional pricing, create the account, send the email).
- ✅ The Backend needs a **simple Internal Admin Tool** (even if it's just a script or a basic internal panel) so the Centerly team can create accounts quickly — this is not part of the Mobile App and does not need polish right now.

---

## 4. Users & Permissions

### 4.1 Teacher
One per Tenant. Owner of the subscription and the data. Permissions are **read-only**, except for:
- ✏️ Their own personal notes on any student.
- ✏️ Cancelling a session + specifying the reason.

### 4.2 Secretary
A fixed number per subscription (managed manually). Responsible for **all write/operations**:
- Adding/editing student data, managing groups, and the schedule.
- Recording attendance and editing it (within the defined time window — Section 6).
- Entering exam scores and assignment statuses — Secretary only.
- Recording payment collection.
- Cancelling a session + reason (exact same permission as the Teacher).

### 4.3 Permission Matrix (final)

| Item | Teacher | Secretary |
|---|---|---|
| View groups, students, sessions, attendance, exams, assignments, payments | ✅ | ✅ |
| Create/edit/delete a group | ❌ | ✅ |
| Add/edit student data | ❌ | ✅ |
| Create/edit the Schedule | ❌ | ✅ |
| Record attendance (within the window) | ❌ | ✅ |
| Edit attendance after the window closes | ❌ | ❌ |
| Enter exam scores / assignment statuses | ❌ | ✅ |
| Record payment collection / create invoice | ❌ | ✅ |
| Cancel session + reason | ✅ | ✅ |
| Teacher notes on a student | ✅ (their own only) | 👁️ read only |
| **Create/edit/deactivate any account (Teacher or Secretary)** | ❌ | ❌ |
| **View list of their secretaries ("My Secretaries" tab)** | ✅ 👁️ read only | — |
| **Submit a secretary removal request** | ✅ (request only, not a direct action) | — |

---

## 5. Data Model (Entities) — final

```
Teacher   (= Tenant)
 ├─ id, name, phone, email, password_hash, avatar_url
 ├─ subscription_status: enum[active, inactive]
 ├─ secretary_seats: integer   (number of secretary accounts agreed on in the subscription — reference only, managed manually)
 ├─ created_at   (created only via the Internal Admin Tool, not via a public API)

Secretary
 ├─ id, teacher_id (FK)
 ├─ name, phone, email, password_hash
 ├─ status: enum[active, inactive]
 ├─ created_at   (created only via the Internal Admin Tool)

GradeLevel
 ├─ id, teacher_id, name, sort_order

Group
 ├─ id, teacher_id, grade_level_id
 ├─ name, subject_name, capacity
 ├─ created_at

GroupSchedule
 ├─ id, group_id, weekday, start_time, end_time

Student
 ├─ id, teacher_id
 ├─ name, avatar_url, phone, guardian_phone
 ├─ level_tag
 ├─ qr_code_value (unique)
 ├─ created_at

GroupEnrollment
 ├─ id, group_id, student_id, status: enum[active, inactive], joined_at

Session
 ├─ id, teacher_id, group_id
 ├─ date, start_time, end_time
 ├─ status: enum[upcoming, ongoing, completed, cancelled]
 ├─ expected_students_count
 ├─ attendance_lock_at   (= start_time + 30 min)
 ├─ cancel_reason_type: enum[low_attendance, technical_issue, other, null]
 ├─ cancel_reason_text
 ├─ cancelled_by_type: enum[teacher, secretary], cancelled_by_id, cancelled_at
 ├─ created_at

Attendance
 ├─ id, session_id, student_id
 ├─ status: enum[not_marked, present, absent, excused]
 ├─ marked_by_type: enum[secretary, system]
 ├─ marked_by_id (nullable if system), marked_at, updated_at
 ├─ is_locked: boolean   (computed: now() > session.attendance_lock_at)

Exam
 ├─ id, teacher_id, student_id, group_id
 ├─ title, date, score_percent (0–100)
 ├─ entered_by (FK Secretary)
 ├─ created_at, updated_at

Assignment
 ├─ id, teacher_id, student_id, group_id
 ├─ title, date, status: enum[submitted, late, pending]
 ├─ entered_by (FK Secretary)
 ├─ created_at, updated_at

TeacherNote
 ├─ id, student_id, teacher_id, content, updated_at

Invoice
 ├─ id, teacher_id, student_id, group_id (nullable)
 ├─ invoice_number, amount
 ├─ due_date, status: enum[due, paid]
 ├─ paid_amount, paid_at, paid_by (FK Secretary)
 ├─ created_at

Notification
 ├─ id, recipient_type: enum[teacher, secretary], recipient_id
 ├─ type, payload_json, read_at, created_at

SecretaryRemovalRequest   🆕 — request to remove a secretary (not a direct action)
 ├─ id, teacher_id, secretary_id
 ├─ status: enum[pending, handled]   (set to handled manually by the Centerly team after acting on it)
 ├─ requested_at, handled_at
```

---

## 6. Critical Rule: Attendance Edit Window

```
                    Session start time (start_time)
                             │
   Marking allowed before   │   ┌── 30 minutes ──┐
  this (early-arriving      │───┤                │
  students) ─────────────── │   └────────────────┘
                                          │
                                  attendance_lock_at
                                          │
                     Any student still not_marked ─────▶ auto-converted to absent (system)
                     Any PATCH attempt after this  ─────▶ 423 Locked
```

**Implementation details:**
- There is no restriction on the earliest time attendance can be marked — it's allowed **at any time before** `attendance_lock_at`.
- `attendance_lock_at = session.start_time + 30 minutes`.
- After the lock: any `PATCH` → **423 Locked**, regardless of role.
- **Mandatory background job:** at the exact moment `attendance_lock_at` is reached, any `Attendance` still `not_marked` is automatically converted:
  ```
  status = "absent", marked_by_type = "system", marked_by_id = null, marked_at = attendance_lock_at
  ```
  This must be a real scheduled job (Cron/Queue), not just computed on read.
- The Session response must include `attendance_lock_at` and `is_attendance_locked: boolean`.

---

## 7. State Machines

### 7.1 Session Status
```
upcoming → [auto] → ongoing → [auto] → completed
upcoming / ongoing → [Teacher or Secretary + reason] → cancelled
```

### 7.2 Attendance Status
```
not_marked → (Secretary, before the lock) → present | absent | excused
not_marked → (Auto job at lock time) → absent [system]
```

### 7.3 Invoice Status
```
due → (Secretary records manual collection) → paid
```

### 7.4 User Account Status (Teacher/Secretary.status)
```
active → (Centerly team, manually) → inactive
```
> **There is no in-app endpoint to change this status.** Deactivation happens directly on the database / via the Internal Admin Tool. If the status is `inactive`, any `/auth/login` attempt or any request with an old token → `403`.

---

## 8. Secretary Flows

### 8.1 Login
`POST /auth/login` → `{ email, password }` → `{ token, user: { id, name, role: "secretary", teacher_id } }`.
If `status == inactive` → `403`.

### 8.2 Entering Students and Groups
```
POST /students                  { name, phone, guardian_phone, level_tag }
POST /groups                    { grade_level_id, name, subject_name, capacity, schedule[] }
POST /groups/{id}/enrollments   { student_id }
```

### 8.3 Managing the Schedule
```
POST/PATCH/DELETE /groups/{id}/schedule[/{id}]
```
> Sessions are auto-generated with a **rolling 1-week-ahead window** (daily cron).

### 8.4 Recording Attendance
```
GET   /sessions/{id}/attendance
PATCH /sessions/{id}/attendance/{student_id}   { status }
GET   /students/search?q=...&group_id=...
GET   /students/by-qr/{qr_code_value}
```
Allowed at any time before `attendance_lock_at`; rejected with 423 after it.

### 8.5 Entering Exam Scores and Assignments
```
POST/PATCH  /students/{id}/exams, /exams/{id}
POST/PATCH  /students/{id}/assignments, /assignments/{id}
```

### 8.6 Payments
```
POST/PATCH  /students/{id}/invoices, /invoices/{id}
```

### 8.7 Cancelling a Session
```
POST /sessions/{id}/cancel   { reason_type, reason_text? }
```
`cancelled_by_type: "secretary"` + Notification to the Teacher.

---

## 9. Teacher Flows

### 9.1 Login
`POST /auth/login` → `role: "teacher"`.

### 9.2 Home Screen
```
GET /teacher/dashboard?date=today
```
Working hours, today's sessions, financial summary — exactly as in the original design.

### 9.3 Groups
```
GET /teacher/groups?search=...
```

### 9.4 Sessions (Day/Week/Month)
```
GET /teacher/sessions?view=day|week|month&date=...
```

### 9.5 Session Details
```
GET /sessions/{id}
GET /sessions/{id}/attendance?filter=present|absent
```
Two buttons: open attendance sheet, cancel session.

### 9.6 Attendance Sheet (Read-only)
```
GET /sessions/{id}/attendance?status=all|present|absent|excused&search=...
```
Banner: "Attendance is recorded by the Secretary."

### 9.7 Cancelling a Session
```
POST /sessions/{id}/cancel   { reason_type, reason_text? }
```
`cancelled_by_type: "teacher"` + Notification to the Secretary.

### 9.8 Student Profile (4 Tabs)

| Tab | Content | Teacher permission |
|---|---|---|
| Student Data | Contact info + teacher notes (editable) + QR Code | ✏️ notes only |
| Academic | Exams + assignments | 👁️ read-only |
| Attendance | Summary + log | 👁️ read-only |
| Payments | Summary + invoice log | 👁️ read-only |

```
PUT /students/{id}/teacher-note
```

### 9.9 🆕 "My Secretaries" Tab (Read-only + removal request)

New screen in the Teacher dashboard (standalone tab or under Settings):
- A list of all secretaries belonging to them: name, email, status (active/inactive).
- A **"Request Removal"** button next to each active secretary.
- On tap: a confirmation ("Are you sure? We will contact you to complete the removal.") → creates a `SecretaryRemovalRequest` with status `pending`.
- **Important:** tapping the button **does not deactivate the secretary's account immediately** — the system gives the Teacher no ability to directly deactivate accounts (per the fully-manual-management decision). This is purely a notification/ticket for the Centerly team to review and act on (they may also confirm with the Teacher directly).
- The request status can be shown on the same screen ("Removal request under review") until it's marked `handled`.

```
GET  /teacher/secretaries                       (Read-only)
POST /teacher/secretaries/{id}/removal-request   → creates a SecretaryRemovalRequest (status: pending)
```

> **Note:** this is not the same as the "Manage Secretaries" feature that was cancelled earlier — here the Teacher **cannot create or actually deactivate** an account, they can only view and request. Actual execution remains 100% manual by the Centerly team, consistent with Decision #8.

---

## 10. Login Screen — "Contact Us"

The "New here? Create Account" button is **fully replaced** with:

> A **"Contact Us"** link/button — opens WhatsApp or a direct call to a Centerly support number (`wa.me/{number}` or `tel:{number}` — a static link in the mobile app, **no backend required**).

**This link covers two cases:**
1. A new teacher who wants to subscribe from scratch.
2. An existing subscribed teacher who wants to add a secretary beyond the number agreed upon in their subscription.

There is no distinction between the two cases inside the app — both reach the same channel (WhatsApp/phone), and the distinction is made manually by the Centerly team.

---

## 11. Edge Cases & Additional Business Rules

### 11.1 Session Generation from Schedule (rolling window)
A daily cron job ensures there are always 7 days generated ahead. If the schedule is edited, outdated `upcoming` sessions are deleted and regenerated from the new schedule. `completed`/`cancelled` sessions remain unchanged (fixed historical record).

### 11.2 A Session Cancelled After Partial Attendance Was Recorded
Historical data remains intact; only the session status changes to `cancelled`.

### 11.3 QR Code
Fixed for the student's entire lifetime with the Teacher, not tied to a specific group.

### 11.4 Both Sides Trying to Cancel the Same Session Simultaneously (Race Condition)
Row-level locking or optimistic locking is required — the first request succeeds, the second returns `409 Conflict`.

### 11.5 Attendance Edit Window and Timezone
All times are computed and stored in a fixed local timezone, and any `now()` comparison in the backend always relies on server time.

### 11.6 Reaching the Maximum Number of Secretary Seats in the Subscription
`secretary_seats` on `Teacher` is reference-only for the Internal Admin Tool (the Centerly team checks it before manually adding a new account) — **there is no automatic enforcement in any public API**, since there is no public API for creating accounts in the first place.

---

## 12. Non-Functional Requirements

- **Offline resilience for attendance recording:** local queue + sync, relying on server time at sync time (not device time) to correctly evaluate `attendance_lock_at`.
- **Auth:** short-lived JWT + Refresh Token, must carry `teacher_id` mandatorily, plus a `status == active` check on every sensitive request (not just at login).
- **Internal Admin Tool:** a simple internal tool (not part of the Mobile App) for the Centerly team to manually create/deactivate Teacher and Secretary accounts — must be built from day one, even if it's just a basic script or CLI panel.
- **No email/SMS gateway is required from the Backend for the MVP** — credentials are sent manually by the Centerly team, not as automated system messages.

---

## 13. Full API Map

| Method | Endpoint | Who calls it | Note |
|---|---|---|---|
| POST | /auth/login | Everyone | No Sign Up. 403 if account is `inactive` |
| GET | /teacher/dashboard | Teacher | |
| GET | /teacher/groups | Teacher | |
| GET | /teacher/secretaries | Teacher | Read-only, list of their secretaries |
| POST | /teacher/secretaries/{id}/removal-request | Teacher | Creates a request only, not an actual deactivation |
| POST/PATCH/DELETE | /groups[/{id}] | Secretary | |
| POST/PATCH/DELETE | /groups/{id}/schedule[/{id}] | Secretary | |
| POST/DELETE | /groups/{id}/enrollments | Secretary | |
| POST/PATCH | /students | Secretary | |
| GET | /students/search, /students/by-qr/{code} | Secretary | |
| GET | /sessions?view=day\|week\|month | Both | |
| GET | /sessions/{id} | Both | Returns `attendance_lock_at`, `is_attendance_locked` |
| POST | /sessions/{id}/cancel | Teacher and Secretary, both | Records `cancelled_by_type` |
| GET | /sessions/{id}/attendance | Both (read) | |
| PATCH | /sessions/{id}/attendance/{student_id} | Secretary only | 423 after lock |
| GET | /students/{id}/profile | Both (read) | |
| GET | /students/{id}/exams, /students/{id}/assignments | Both (read) | |
| POST/PATCH | /students/{id}/exams, /exams/{id} | Secretary only | |
| POST/PATCH | /students/{id}/assignments, /assignments/{id} | Secretary only | |
| GET | /students/{id}/attendance-summary | Both (read) | |
| GET | /students/{id}/invoices | Both (read) | |
| POST/PATCH | /students/{id}/invoices, /invoices/{id} | Secretary | |
| PUT | /students/{id}/teacher-note | Teacher (their own only) | |
| GET/PATCH | /notifications | Both | |

> **There is no public endpoint for creating or managing user accounts (Teacher/Secretary) in this map — this is intentional, since account management is entirely manual, handled by the Centerly team.**

---

## 14. Summary of Required UI Changes (for the design team)

| Screen | Required change |
|---|---|
| Login | "Create Account" → "Contact Us" (WhatsApp/call), covering both new subscriptions and adding secretaries |
| ~~Manage Secretaries (full CRUD)~~ | ❌ Fully cancelled — no need to design it |
| 🆕 "My Secretaries" (Teacher dashboard) | New, simple screen: read-only list + "Request Removal" button per secretary + request status |
| Attendance Sheet (Secretary version) | Recommended: add an indicator/countdown for the remaining time in the 30-minute window before it locks |

---

*End of document. Version v6.0 is the final approved reference for starting work on the Backend and the Mobile App. Any new decision should be appended as version v6.1 and onward.*
