enum UserRole {
  teacher,
  secretary;

  String get label => switch (this) {
    UserRole.teacher => 'Teacher',
    UserRole.secretary => 'Secretary',
  };

  static UserRole fromName(String? value) => UserRole.values.firstWhere(
    (role) => role.name == value,
    orElse: () => UserRole.teacher,
  );
}

enum SessionStatus { upcoming, ongoing, completed, cancelled }

enum AttendanceStatus { notMarked, present, absent, excused }

enum MarkedByType { secretary, system }

enum InvoiceStatus { due, paid }

enum AssignmentStatus { submitted, late, pending }

enum SecretaryStatus { active, inactive }

enum RemovalRequestStatus { pending, handled }

class Student {
  const Student({
    required this.id,
    required this.teacherId,
    required this.groupId,
    required this.name,
    required this.phone,
    required this.guardianPhone,
    required this.levelTag,
    required this.qrCodeValue,
    required this.createdAt,
    this.avatarUrl,
    this.teacherNote,
  });

  final String id;
  final String teacherId;
  final String groupId;
  final String name;
  final String? avatarUrl;
  final String phone;
  final String guardianPhone;
  final String levelTag;
  final String qrCodeValue;
  final DateTime createdAt;
  final String? teacherNote;
}

class Group {
  const Group({
    required this.id,
    required this.teacherId,
    required this.gradeLevelId,
    required this.gradeLevelName,
    required this.name,
    required this.subjectName,
    required this.capacity,
    required this.scheduleLabel,
    required this.nextSessionAt,
    required this.createdAt,
  });

  final String id;
  final String teacherId;
  final String gradeLevelId;
  final String gradeLevelName;
  final String name;
  final String subjectName;
  final int capacity;
  final String scheduleLabel;
  final DateTime nextSessionAt;
  final DateTime createdAt;
}

class Session {
  const Session({
    required this.id,
    required this.teacherId,
    required this.groupId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.expectedStudentsCount,
    required this.attendanceLockAt,
    required this.createdAt,
    this.cancelReasonType,
    this.cancelReasonText,
    this.cancelledByType,
    this.cancelledById,
    this.cancelledAt,
  });

  final String id;
  final String teacherId;
  final String groupId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final SessionStatus status;
  final int expectedStudentsCount;
  final DateTime attendanceLockAt;
  final String? cancelReasonType;
  final String? cancelReasonText;
  final UserRole? cancelledByType;
  final String? cancelledById;
  final DateTime? cancelledAt;
  final DateTime createdAt;

  bool get isAttendanceLocked => DateTime.now().isAfter(attendanceLockAt);
}

class Attendance {
  const Attendance({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.status,
    required this.markedByType,
    required this.markedAt,
    required this.updatedAt,
    this.markedById,
  });

  final String id;
  final String sessionId;
  final String studentId;
  final AttendanceStatus status;
  final MarkedByType markedByType;
  final String? markedById;
  final DateTime markedAt;
  final DateTime updatedAt;
}

class Invoice {
  const Invoice({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.invoiceNumber,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.paidAmount,
    required this.createdAt,
    this.groupId,
    this.paidAt,
    this.paidBy,
  });

  final String id;
  final String teacherId;
  final String studentId;
  final String? groupId;
  final String invoiceNumber;
  final double amount;
  final DateTime dueDate;
  final InvoiceStatus status;
  final double paidAmount;
  final DateTime? paidAt;
  final String? paidBy;
  final DateTime createdAt;
}

class Exam {
  const Exam({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.groupId,
    required this.title,
    required this.date,
    required this.scorePercent,
    required this.enteredBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String teacherId;
  final String studentId;
  final String groupId;
  final String title;
  final DateTime date;
  final int scorePercent;
  final String enteredBy;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class Assignment {
  const Assignment({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.groupId,
    required this.title,
    required this.date,
    required this.status,
    required this.enteredBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String teacherId;
  final String studentId;
  final String groupId;
  final String title;
  final DateTime date;
  final AssignmentStatus status;
  final String enteredBy;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class SecretaryProfile {
  const SecretaryProfile({
    required this.id,
    required this.teacherId,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
  });

  final String id;
  final String teacherId;
  final String name;
  final String phone;
  final String email;
  final SecretaryStatus status;
}

class SecretaryRemovalRequest {
  const SecretaryRemovalRequest({
    required this.id,
    required this.teacherId,
    required this.secretaryId,
    required this.status,
    required this.requestedAt,
    this.handledAt,
  });

  final String id;
  final String teacherId;
  final String secretaryId;
  final RemovalRequestStatus status;
  final DateTime requestedAt;
  final DateTime? handledAt;
}
