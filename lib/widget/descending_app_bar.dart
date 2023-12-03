import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DescendingAppBar extends HookWidget {
  final ScrollController controller;

  // 監視対象WidgetのGlobalKey
  final GlobalKey targetGlobalKey;

  const DescendingAppBar({
    super.key,
    required this.targetGlobalKey,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final safeAreaHeight = MediaQuery.of(context).padding.top;
    final safeAreaAppBarHeight = kToolbarHeight + safeAreaHeight;

    final scrollAreaHeight = useState(0.0);

    final initialPointOffset = useState<double?>(null);
    initialPointOffset.addListener(() {
      if (initialPointOffset.value != null) {
        scrollAreaHeight.value =
            initialPointOffset.value! - safeAreaAppBarHeight;
      }
    });

    final descendingAppBarPosition = useState(-safeAreaAppBarHeight);
    controller.addListener(
      () {
        final renderBox =
            targetGlobalKey.currentContext?.findRenderObject() as RenderBox?;
        final pointOffset = renderBox?.localToGlobal(Offset.zero);
        final monitoredWidgetHeight = renderBox?.size.height;

        if (pointOffset != null && monitoredWidgetHeight != null) {
          // 監視対象Widgetの下限位置の初期位置を保持
          initialPointOffset.value ??= pointOffset.dy + monitoredWidgetHeight;

          // 監視対象Widgetの下限位置（AppBar領域除く）
          final targetPosition =
              pointOffset.dy + monitoredWidgetHeight - safeAreaAppBarHeight;
          if (targetPosition <= 0.0) {
            // targetPositionが0以下ということは、スクロールアップして監視対象WidgetがDescending AppBarに隠れる位置まできている
            descendingAppBarPosition.value = 0.0;
            return;
          }

          if (controller.offset > 0.0 && scrollAreaHeight.value > 0.0) {
            // Descending AppBarを変動させる範囲の割合（スクロール開始当初は1.0、監視対象のWidgetがDescending AppBarにちょうど隠れるところまでスクロールすると0.0）
            final appBarVisibilityRatio =
                (targetPosition / scrollAreaHeight.value).clamp(0.0, 1.0);
            // Descending AppBarの表示位置を更新
            descendingAppBarPosition.value =
                -safeAreaAppBarHeight * appBarVisibilityRatio;
          } else {
            // Descending AppBarの表示位置を初期化
            descendingAppBarPosition.value = -safeAreaAppBarHeight;
          }
        }
      },
    );

    return Positioned(
      top: descendingAppBarPosition.value,
      left: 0,
      right: 0,
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        toolbarHeight: kToolbarHeight,
        title: const Text(
          'Descending AppBar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
