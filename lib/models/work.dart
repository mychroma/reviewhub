import 'platform.dart';

class WorkEntity {
  final String id;
  final String title;
  final String? author;
  final String? coverUrl;
  final String category; // DB enum string
  final List<String> genres;
  final String status; // DB enum string
  final double? communityRating; // computed (rating_sum / rating_count)
  final List<PlatformEntity> platforms;

  WorkEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.category,
    required this.genres,
    required this.status,
    required this.communityRating,
    required this.platforms,
  });

  factory WorkEntity.fromMaps({
    required Map<String, dynamic> work,
    Map<String, dynamic>? rating,
    List<Map<String, dynamic>> platformRows = const [],
  }) {
    final double? avg = (rating != null && (rating['rating_count'] ?? 0) > 0)
        ? (rating['rating_sum'] as int) / (rating['rating_count'] as int)
        : null;
    return WorkEntity(
      id: work['id'] as String,
      title: work['title'] as String,
      author: work['author'] as String?,
      coverUrl: work['cover_url'] as String?,
      category: work['category'] as String,
      genres: (work['genres'] as List?)?.cast<String>() ?? const [],
      status: work['status'] as String,
      communityRating: avg,
      platforms: platformRows.map((e) => PlatformEntity.fromMap(e)).toList(),
    );
  }
}
