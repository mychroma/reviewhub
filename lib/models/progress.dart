class UserProgressEntity {
  final String userId;
  final String workId;
  final String? progressText;
  final DateTime updatedAt;

  UserProgressEntity({
    required this.userId,
    required this.workId,
    required this.progressText,
    required this.updatedAt,
  });

  factory UserProgressEntity.fromMap(Map<String, dynamic> m) => UserProgressEntity(
        userId: m['user_id'] as String,
        workId: m['work_id'] as String,
        progressText: m['progress_text'] as String?,
        updatedAt: DateTime.parse(m['updated_at'] as String),
      );
}
