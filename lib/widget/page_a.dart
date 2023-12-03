import 'package:descending_app_bar/widget/descending_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PageA extends HookWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController();
    final targetGlobalKey = useMemoized(() => GlobalKey());

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: controller,
            slivers: [
              const SliverAppBar(
                pinned: true,
                centerTitle: true,
                title: Text('PageA'),
                backgroundColor: Colors.lightGreen,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 10,
                  (context, index) => ListTile(
                    title: Text('Item $index'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: targetGlobalKey,
                  height: 30,
                  color: Colors.red,
                  child: const Center(
                    child: Text(
                      'Target Widget',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 20,
                  (context, index) => ListTile(
                    title: Text('Item $index'),
                  ),
                ),
              ),
            ],
          ),
          DescendingAppBar(
            controller: controller,
            targetGlobalKey: targetGlobalKey,
          ),
        ],
      ),
    );
  }
}
