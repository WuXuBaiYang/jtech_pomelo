import 'dart:async';
import 'package:flutter/material.dart';

import '../base/base_manage.dart';

//弹层内容构造器
typedef OverlayBuilder<T> = Widget Function(
    BuildContext context, void Function(T? result) dismiss);

/*
* 弹层组件管理
* @author JTech JH
* @Time 2022/3/18 14:29
*/
class JOverlay extends BaseManage {
  static final JOverlay _instance = JOverlay._internal();

  factory JOverlay() => _instance;

  JOverlay._internal();

  //缓存当前启用的弹层对象
  final Map<Key, OverlayEntry> _entries = {};

  //根据某个组件的GlobalKey展示弹层
  Future<T?> showByKey<T>(
    BuildContext context, {
    required GlobalKey key,
    required OverlayBuilder<T> builder,
    Size? size,
    Rect? rect,
    double? targetSpace,
  }) {
    var renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var rect = Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
    return show<T>(
      context,
      key: key,
      builder: builder,
      size: size,
      rect: rect,
      targetSpace: targetSpace,
    );
  }

  //显示基础弹层组件
  Future<T?> show<T>(
    BuildContext context, {
    required Key key,
    required OverlayBuilder<T> builder,
    Size? size,
    Rect? rect,
    double? targetSpace,
  }) {
    //赋默认值
    size ??= Size.zero;
    rect ??= Rect.zero;
    targetSpace ??= 6;
    var c = Completer<T>();
    var offset = _getOffset(
      context,
      rect: rect,
      size: size,
      targetSpace: targetSpace,
    );
    _entries[key] = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
              ),
              onTapDown: (_) => c.complete(),
            ),
            Positioned(
              child: builder(
                context,
                (result) => c.complete(result),
              ),
              width: size?.width,
              height: size?.height,
              left: offset.dx,
              top: offset.dy,
            ),
          ],
        ),
      ),
    );
    Overlay.of(context)?.insert(_entries[key]!);
    return c.future..whenComplete(() => removeOverlay([key]));
  }

  //移除弹层
  void removeOverlay(List<Key> keys) {
    for (var key in keys) {
      _entries.remove(key)?.remove();
    }
  }

  //获取实际位置偏移量
  Offset _getOffset(
    BuildContext context, {
    required Rect rect,
    required Size size,
    required double targetSpace,
  }) {
    var screenSize = MediaQuery.of(context).size;
    double dx = rect.left + rect.width / 2.0 - size.width / 2.0;
    if (dx < 10) dx = 10;
    if (dx + size.width > screenSize.width && dx > 10) {
      double tempDx = screenSize.width - size.width - 10;
      if (tempDx > 10) dx = tempDx;
    }

    var paddingTop = MediaQuery.of(context).padding.top;
    double dy = rect.top - size.height;
    if (dy <= paddingTop + targetSpace) {
      dy = targetSpace + rect.height + rect.top;
    } else {
      dy -= targetSpace;
    }
    return Offset(dx, dy);
  }
}

//单例调用
final jOverlay = JOverlay();
