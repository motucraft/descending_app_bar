import 'package:descending_app_bar/widget/descending_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PageB extends HookWidget {
  const PageB({super.key});

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
                title: Text('PageB'),
                backgroundColor: Colors.lightBlue,
              ),
              SliverToBoxAdapter(
                child: Container(height: 100, color: Colors.black12),
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
              SliverToBoxAdapter(
                child: Container(height: 1000, color: Colors.black12),
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
