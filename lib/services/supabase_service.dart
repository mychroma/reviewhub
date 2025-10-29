import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/work.dart';
import '../models/platform.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<WorkEntity>> fetchWorksByCategory(String categoryDb) async {
    // Fetch works
    final worksRes = await _client
        .from('works')
        .select()
        .eq('category', categoryDb)
        .order('created_at', ascending: false);

    if (worksRes is List == false) return [];

    final List<dynamic> worksRows = worksRes as List<dynamic>;
    final ids = worksRows.map((e) => e['id'] as String).toList();

    // Ratings
    final ratingsMap = <String, Map<String, dynamic>>{};
    if (ids.isNotEmpty) {
      final ratingsRes = await _client
          .from('work_ratings')
          .select()
          .inFilter('work_id', ids);
      for (final r in (ratingsRes as List<dynamic>)) {
        ratingsMap[r['work_id'] as String] = r as Map<String, dynamic>;
      }
    }

    // Platforms join
    final platformMap = <String, List<Map<String, dynamic>>>{};
    if (ids.isNotEmpty) {
      final rows = await _client
          .from('work_platforms')
          .select('work_id,platforms:platform_id(id,name,category),platform_label')
          .inFilter('work_id', ids);
      for (final row in (rows as List<dynamic>)) {
        final workId = row['work_id'] as String;
        final p = row['platforms'] as Map<String, dynamic>;
        (platformMap[workId] ??= []).add({
          'id': p['id'],
          'name': row['platform_label'] ?? p['name'],
          'category': p['category'],
        });
      }
    }

    return worksRows.map((w) {
      final rating = ratingsMap[w['id'] as String];
      final plats = platformMap[w['id'] as String] ?? const [];
      return WorkEntity.fromMaps(
        work: w as Map<String, dynamic>,
        rating: rating,
        platformRows: plats,
      );
    }).toList();
  }

  Future<void> upsertReview({
    required String workId,
    required int rating,
    String? reviewText,
    List<String>? tags,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }
    await _client.from('reviews').upsert({
      'user_id': user.id,
      'work_id': workId,
      'rating': rating,
      'review_text': reviewText,
      'tags': tags ?? [],
      // updated_at handled by default if trigger exists; otherwise set here
    }, onConflict: 'user_id,work_id');
  }
}
