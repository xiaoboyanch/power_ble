import 'dart:io';

import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef OnRefresh = void Function(bool isHeader, RefreshController refreshCtrl);

class RHRefresher extends StatelessWidget {
  RefreshController refreshCtrl;
  ScrollController? scrollCtrl;
  bool enableRefresh;
  OnRefresh? onRefresh;
  Widget? child;
  bool onlyHeader;
  bool showFooterWidget;
  RHRefresher({
    required this.refreshCtrl,
    this.child,
    this.onRefresh,
    this.enableRefresh = true,
    this.onlyHeader = false,
    this.showFooterWidget = true,
    this.scrollCtrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      scrollController: scrollCtrl,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          String text = 'Release to load more';
          switch (mode) {
            // case LoadStatus.idle:
            // case LoadStatus.canLoading:
            //   text = 'Release to load more';
            //   break;
            case LoadStatus.loading:
              text = 'Loading';
              break;
            case LoadStatus.noMore:
              text =  'No more data';
              break;

            default: {}
          }
          return showFooterWidget ? RHText(
            bigHeight: 60,
            fontColor: RHColor.black,
            text: text,
          ): const SizedBox.shrink();
        },
      ),
      header: WaterDropHeader(
        refresh: SizedBox(
          width: 25.0,
          height: 25.0,
          child: Platform.isIOS ? const CupertinoActivityIndicator()
              : const CircularProgressIndicator(color: Colors.grey),
        ),
        complete: RHText(
          bigHeight: 60,
          fontColor: RHColor.black,
          textKey: "refresh_completed",
        ),
      ),
      enablePullDown: (enableRefresh && onRefresh != null),
      enablePullUp: (onRefresh != null && !onlyHeader),
      controller: refreshCtrl,
      onRefresh: () {
        onRefresh?.call(true, refreshCtrl);
      },
      onLoading: () {
        onRefresh?.call(false, refreshCtrl);
      },
      child: child
    );
  }
}
