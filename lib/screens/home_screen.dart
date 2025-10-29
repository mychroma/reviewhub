import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
        children: const [
          _CategoryPlaceholder(title: '웹툰 목록'),
          _CategoryPlaceholder(title: '웹소설 목록'),
          _CategoryPlaceholder(title: '애니 목록'),
        ],
      ),
    );
  }
}

class _CategoryPlaceholder extends StatelessWidget {
  final String title;
  const _CategoryPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
