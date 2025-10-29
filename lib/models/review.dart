class ReviewEntity {
  final String id;
  final String userId;
  final String workId;
  final int rating; // 0..10, 0.5 step *2
  final String? reviewText;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewEntity({
    required this.id,
    required this.userId,
    required this.workId,
    required this.rating,
    required this.reviewText,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewEntity.fromMap(Map<String, dynamic> m) => ReviewEntity(
        id: m['id'] as String,
        userId: m['user_id'] as String,
        workId: m['work_id'] as String,
        rating: m['rating'] as int,
        reviewText: m['review_text'] as String?,
        tags: (m['tags'] as List?)?.cast<String>() ?? const [],
        createdAt: DateTime.parse(m['created_at'] as String),
        updatedAt: DateTime.parse(m['updated_at'] as String),
      );
}
