import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final SupabaseService _svc = SupabaseService();

  Future<List<WorkEntity>> _load(ContentCategory c) async {
    return _svc.fetchWorksByCategory(categoryToDb(c));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReviewHub'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '웹툰'),
            Tab(text: '웹소설'),
            Tab(text: '애니'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CategoryList(loader: () => _load(ContentCategory.webtoon)),
          _CategoryList(loader: () => _load(ContentCategory.webnovel)),
          _CategoryList(loader: () => _load(ContentCategory.anime)),
        ],
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final Future<List<WorkEntity>> Function() loader;
  const _CategoryList({required this.loader});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WorkEntity>>(
      future: loader(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return const Center(child: Text('작품이 없습니다'));
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final w = items[index];
            final rating = w.communityRating;
            return ListTile(
              leading: w.coverUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        w.coverUrl!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox(width: 48, height: 48),
              title: Text(w.title),
              subtitle: Text([
                if (w.author != null) w.author!,
                if (rating != null) '추천도 ${(rating / 2).toStringAsFixed(1)}★',
              ].join(' · ')),
              onTap: () {
                // TODO: navigate to detail
              },
            );
          },
        );
      },
    );
  }
}
