import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

/*
* 有状态组件基类
* @author JTech JH
* @Time 2022/3/17 9:40
*/
abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({
    Key? key,
  }) : super(key: key);
}

/*
* 有状态组件-状态基类
* @author JTech JH
* @Time 2022/3/17 9:41
*/
abstract class BaseState<T extends StatefulWidget> extends State<T> {}

/*
* 无状态组件基类
* @author jtechjh
* @Time 2021/8/12 5:27 下午
*/
abstract class BaseStatelessWidget extends StatelessWidget {
  const BaseStatelessWidget({
    Key? key,
  }) : super(key: key);
}
