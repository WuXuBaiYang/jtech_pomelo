import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_notifier.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/widget/banner/banner_item.dart';
import 'package:jtech_pomelo/widget/empty_box.dart';

/*
* 轮播图组件
* @author JTech JH
* @Time 2022/4/6 9:46
*/
class JBanner extends BaseStatefulWidget {
  //轮播图子项集合
  final List<BannerItem> items;

  //页面切换时间间隔
  final Duration pageChangeDuration;

  //是否可滚动
  final bool canScroll;

  //高度
  final double height;

  //外间距
  final EdgeInsetsGeometry? margin;

  //内间距
  final EdgeInsetsGeometry? padding;

  //背景色
  final Color? color;

  //背景形状
  final BorderRadius borderRadius;

  //悬浮高度
  final double? elevation;

  //是否无限滚动
  final bool infinity;

  //是否自动滚动
  final bool auto;

  //自动滚动的时间间隔
  final Duration autoDuration;

  //判断是否展示标题
  final bool showTitle;

  //判断是否展示指示器
  final bool showIndicator;

  //指示器对齐位置
  final BannerAlign indicatorAlign;

  //初始下标
  final int initialIndex;

  //子项点击事件
  final ItemTap<BannerItem>? itemTap;

  //子项长点击事件
  final ItemTap<BannerItem>? itemLongPress;

  //标题项构造器
  final ItemBuilder<BannerItem>? titleBuilder;

  //指示器构造器
  final ItemBuilder<BannerItem>? indicatorBuilder;

  const JBanner({
    Key? key,
    required this.items,
    this.itemTap,
    this.itemLongPress,
    this.titleBuilder,
    this.indicatorBuilder,
    this.margin,
    this.padding,
    this.color,
    this.elevation,
    double? height,
    bool? canScroll,
    BorderRadius? borderRadius,
    bool? infinity,
    bool? auto,
    Duration? autoDuration,
    bool? showTitle,
    bool? showIndicator,
    Duration? pageChangeDuration,
    int? initialIndex,
    BannerAlign? indicatorAlign,
  })  : canScroll = canScroll ?? true,
        height = height ?? 220,
        borderRadius = borderRadius ?? const BorderRadius.all(Radius.zero),
        infinity = infinity ?? true,
        auto = auto ?? true,
        autoDuration = autoDuration ?? const Duration(milliseconds: 3000),
        showTitle = showTitle ?? false,
        showIndicator = showIndicator ?? true,
        pageChangeDuration =
            pageChangeDuration ?? const Duration(milliseconds: 500),
        initialIndex = initialIndex ?? 0,
        indicatorAlign = indicatorAlign ?? BannerAlign.bottom,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _JBannerState();
}

/*
* 轮播图组件-状态
* @author JTech JH
* @Time 2022/4/6 9:46
*/
class _JBannerState extends BaseState<JBanner> {
  //页面控制器
  late PageController pageController =
      PageController(initialPage: widget.initialIndex);

  //下标管理
  late ValueChangeNotifier<int> currentIndex =
      ValueChangeNotifier(widget.initialIndex);

  @override
  void initState() {
    super.initState();
    //监听页面变化，实现无限滚动
    pageController.addListener(() {
      if (_canInfinity) {
        var page = pageController.page ?? 0;
        if (page <= 0.01) {
          Future.delayed(Duration.zero).then(
              (value) => pageController.jumpToPage(_currentItemLength - 2));
        } else if (page >= _currentItemLength - 1.01) {
          Future.delayed(Duration.zero)
              .then((value) => pageController.jumpToPage(1));
        }
      }
    });
    //启动自动切换
    _startAutoChange();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      elevation: widget.elevation,
      margin: widget.margin,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius,
      ),
      child: Container(
        height: widget.height,
        padding: widget.padding,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _buildBannerContent(),
              _buildBannerTitle(context),
              _buildBannerIndicator(context),
            ],
          ),
        ),
      ),
    );
  }

  //构建banner内容
  Widget _buildBannerContent() {
    return PageView.builder(
      physics: widget.canScroll ? null : const NeverScrollableScrollPhysics(),
      itemCount: _currentItemLength,
      controller: pageController,
      itemBuilder: (context, index) => _buildBannerItem(
        context,
        _getCurrentItem(index),
        _getCurrentIndex(index),
      ),
      onPageChanged: (index) {
        if (index < 0 || index >= widget.items.length) index = 0;
        currentIndex.setValue(_getCurrentIndex(index));
      },
    );
  }

  //构建banner子项
  Widget _buildBannerItem(BuildContext context, BannerItem item, int index) {
    return GestureDetector(
      child: item.child,
      onTap: (item.enable && null != widget.itemTap)
          ? () => widget.itemTap!(item, index)
          : null,
      onLongPress: (item.enable && null != widget.itemLongPress)
          ? () => widget.itemLongPress!(item, index)
          : null,
    );
  }

  //构建banner标题
  Widget _buildBannerTitle(BuildContext context) {
    if (!widget.showTitle) return const EmptyBox();
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (_, value, child) {
          return widget.titleBuilder?.call(
                context,
                _getCurrentItem(value),
                value,
              ) ??
              _defTitle(context);
        },
      ),
    );
  }

  //构建默认标题构造器
  Widget _defTitle(BuildContext context) {
    var item = _getCurrentItem(currentIndex.value);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      color: Colors.black38,
      child: Text(
        item.text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  //构建banner指示器
  Widget _buildBannerIndicator(BuildContext context) {
    if (!widget.showIndicator) return const EmptyBox();
    var align = widget.indicatorAlign;
    if (widget.showTitle && align == BannerAlign.bottom) {
      align = BannerAlign.right;
    }
    return Align(
      alignment: align.align,
      child: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (_, value, child) {
          return widget.indicatorBuilder?.call(
                context,
                _getCurrentItem(value),
                value,
              ) ??
              _defIndicator(context, align);
        },
      ),
    );
  }

  //构造默认结构指示器
  Widget _defIndicator(BuildContext context, BannerAlign align) {
    var isVertical = align.isVertical;
    var axis = isVertical ? Axis.vertical : Axis.horizontal;
    return Container(
      width: isVertical ? null : double.infinity,
      height: !isVertical ? null : double.infinity,
      padding: const EdgeInsets.all(8),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        direction: axis,
        children: List.generate(widget.items.length, (index) {
          var isSelected = currentIndex.value == index;
          return Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 1)
                    : Border.all(color: Colors.white, width: 0.2),
                color: isSelected ? Colors.black87 : Colors.black87,
              ),
            ),
          );
        }),
      ),
    );
  }

  //自动切换定时器
  Timer? _timer;

  //启动自动切换功能
  void _startAutoChange() {
    if (!widget.auto) return;
    if (null != _timer && _timer!.isActive) _stopAutoChange();
    _timer = Timer.periodic(
      widget.autoDuration,
      (t) {
        if (_canInfinity) {
          pageController.nextPage(
            duration: widget.pageChangeDuration,
            curve: Curves.ease,
          );
        } else {
          var index = pageController.page?.round() ?? 0;
          if (++index >= widget.items.length) index = 0;
          pageController.animateToPage(
            index,
            duration: widget.pageChangeDuration,
            curve: Curves.ease,
          );
        }
      },
    );
  }

  //停止自动切换
  void _stopAutoChange() {
    _timer?.cancel();
    _timer = null;
  }

  //判断当前是否可以无限滚动
  bool get _canInfinity => widget.infinity && widget.items.length > 1;

  //根据当前滚动状态获取实际数据数量
  int get _currentItemLength {
    var length = widget.items.length;
    if (_canInfinity) length += 2;
    return length;
  }

  //根据当前滚动状态获取真实下标
  int _getCurrentIndex(int index) {
    if (_canInfinity) {
      index -= 1;
      if (index < 0) return widget.items.length - 1;
      if (index >= widget.items.length) return 0;
    }
    return index;
  }

  //根据当前滚动状态获取真实下标的数据对象
  BannerItem _getCurrentItem(int index) {
    index = _getCurrentIndex(index);
    return widget.items[index];
  }

  @override
  void dispose() {
    //销毁控制器
    pageController.dispose();
    super.dispose();
  }
}

/*
* 子项对齐方式
* @author JTech JH
* @Time 2022/4/6 10:26
*/
enum BannerAlign {
  top,
  left,
  right,
  bottom,
}

/*
* 扩展对照alignment
* @author JTech JH
* @Time 2022/4/6 10:26
*/
extension BannerAlignExtension on BannerAlign {
  //获取对齐方式
  Alignment get align {
    switch (this) {
      case BannerAlign.top:
        return Alignment.topCenter;
      case BannerAlign.left:
        return Alignment.centerLeft;
      case BannerAlign.right:
        return Alignment.centerRight;
      case BannerAlign.bottom:
        return Alignment.bottomCenter;
      default:
        return Alignment.bottomCenter;
    }
  }

  //判断是否为垂直方向
  bool get isVertical {
    switch (this) {
      case BannerAlign.top:
      case BannerAlign.bottom:
        return false;
      case BannerAlign.left:
      case BannerAlign.right:
        return true;
      default:
        return false;
    }
  }
}
