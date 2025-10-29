class PlatformEntity {
  final String id;
  final String name;
  final String category; // DB enum string

  PlatformEntity({required this.id, required this.name, required this.category});

  factory PlatformEntity.fromMap(Map<String, dynamic> m) => PlatformEntity(
        id: m['id'] as String,
        name: m['name'] as String,
        category: m['category'] as String,
      );
}
