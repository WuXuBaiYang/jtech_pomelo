import 'package:flutter/cupertino.dart';
import 'base_widget.dart';

/*
* 有状态页面基类
* @author JTech JH
* @Time 2022/3/17 9:41
*/
abstract class BaseStatefulPage extends BaseStatefulWidget {
  const BaseStatefulPage({
    Key? key,
  }) : super(key: key);
}

/*
* 页面状态基类
* @author JTech JH
* @Time 2022/3/17 14:08
*/
abstract class BaseStatePage<T extends StatefulWidget> extends BaseState<T> {}

/*
* 无状态页面基类
* @author JTech JH
* @Time 2022/3/17 14:08
*/
abstract class BaseStatelessPage extends BaseStatelessWidget {
  const BaseStatelessPage({
    Key? key,
  }) : super(key: key);
}
