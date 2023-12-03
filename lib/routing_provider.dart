import 'package:descending_app_bar/main.dart';
import 'package:descending_app_bar/widget/page_a.dart';
import 'package:descending_app_bar/widget/page_b.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routing_provider.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter routing(RoutingRef ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/a',
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Main(navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _sectionNavigatorKey,
            routes: [
              GoRoute(
                path: '/a',
                pageBuilder: (context, state) {
                  return const MaterialPage(child: PageA());
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/b',
                pageBuilder: (context, state) {
                  return const MaterialPage(child: PageB());
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}
