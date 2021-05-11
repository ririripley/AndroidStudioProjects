import 'package:TencentDocsApp/model/CooperationModel.dart';
import 'package:TencentDocsApp/provider/cooperation/FriendPickerProvider.dart';
import 'package:TencentDocsApp/util/app_style.dart';
import 'package:TencentDocsApp/util/split_utils.dart';
import 'package:TencentDocsApp/widget/base/mouse_keyboard_adapter/hover_widget.dart';
import 'package:TencentDocsApp/widget/base/mouse_keyboard_adapter/touch_pad_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:xlog/xlog.dart';
import 'dart:math' as math;

import '../../AppPageRoute.dart';
import 'FriendComponents.dart';
import 'FriendSearchBar.dart';

class FriendListPage extends StatefulWidget {
  final FriendPickerProvider provider;
  static AppPageBuilder pageBuilder =
      (context, args) => FriendListPage(provider: args);

  FriendListPage({this.provider});

  @override
  _FriendListState createState() => _FriendListState(this.provider);
}

class _FriendListState extends State<FriendListPage> {
  Set expandedIndexSet = Set()..add(UserCategories.RecentID); // 最近列表默认展开
  final FriendPickerProvider provider;
  final TextEditingController _textController = TextEditingController();
  _FriendListState(this.provider);
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getFriendChain().then((value) {
        if (mounted) {
          setState(() {
            Log.d(this, '拉取好友结果 $value');
          });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        backgroundColor: Colors.white,
        leading: HoverWidget(
            child: CupertinoButton(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: AppStyle.backIcon,
                onPressed: () => Navigator.pop(context)),
            hoverWidth: 48,
            hoverHeight: 42),
        middle: Text('选择QQ/TIM好友'),
      ),
      child: SafeArea(
          child: ChangeNotifierProvider.value(
              value: provider,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FriendSearchBar(
                    provider: this.provider,
                    pickedProvider: provider,
                    canSelectItem: (item) => !(provider.isFriendExisted(item)),
                    isItemSelected: (item) => provider.isFriendSelected(item),
                    didTouchItem: (item) => updateCollaborator(item),
                    textController: _textController,
                  ),
                  FlatButton(
                    key: const Key("QGroup"),
                    child: Row(
                      children: <Widget>[
                        Text("选择群聊"),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pushSplit(SplitStyle(
                          '/ChatGroupList',
                          arguments: provider,
                          size: CooperationModel.BoxSize(),
                          replaceRoute: false));
                    },
                  ),

                  /// -- 好友列表 --
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 36,
                    color: Color(0xfff3f5f7),
                    padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "QQ好友",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xff939393)),
                      ),
                    ),
                  ),
                  Expanded(
                      child: TouchPadWidget(
                          scrollController: _scrollController,
                          child: ListView.builder(
                            itemCount: provider.categories.length,
                            physics: BouncingScrollPhysics(),
                            controller: _scrollController,
                            cacheExtent: 10,
                            itemBuilder: (context, cIndex) {
                              UserCategories currentCate =
                                  provider.categories[cIndex];
                              return Material(
                                child: Theme(
                                    data: Theme.of(context),
                                    child: ExpansionTile(
                                      expandedCrossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      trailing: Icon(Icons.keyboard,
                                          color: Colors.transparent),
                                      leading: expandedIndexSet.
                                      contains(currentCate.index)
                                          ? SvgPicture.asset(
                                              'assets/images/icon_thirdary_arrow_fill_down_grey.svg',
                                              width: 15,
                                              height: 15,
                                              color: Color(0xFF81868f),
                                            )
                                          : Transform.rotate(
                                              angle: -math.pi / 2,
                                              child: SvgPicture.asset(
                                                'assets/images/icon_thirdary_arrow_fill_down_grey.svg',
                                                width: 15,
                                                height: 15,
                                                color: Color(0xFF81868f),
                                              ),
                                            ),
                                      title: Transform.translate(
                                        offset: Offset(-36, -5),
                                        child: Text("${currentCate.name}",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.88),
                                                fontSize: 13.8)),
                                      ),
                                      initiallyExpanded: expandedIndexSet
                                          .contains(currentCate.index),
                                      onExpansionChanged: (value) {
                                        setState(() {
                                          value
                                              ? expandedIndexSet
                                                  .add(currentCate.index)
                                              : expandedIndexSet
                                                  .remove(currentCate.index);
                                        });
                                      },
                                      children: <Widget>[
                                        Container(
                                          height: FriendCell.CellHeight *
                                              (provider.categories[cIndex].users
                                                  .length),
                                          child: Consumer<FriendPickerProvider>(
                                              builder:
                                                  (context, provider, child) {
                                            return ListView.builder(
                                              itemCount: (provider
                                                  .categories[cIndex]
                                                  .users
                                                  .length),
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return itemCell(cIndex, index);
                                              },
                                            );
                                          }),
                                        ),
                                      ],
                                    )),
                              );
                            },
                          ))),

                  Consumer<FriendPickerProvider>(
                      builder: (context, provider, child) {
                    final friends = provider.pickedFriends();
                    return FriendPickerBar(
                      hideCheckbox: provider.hideSendDocItem,
                      badge: friends != null ? friends.length : 0,
                      checkboxValue: provider.shouldSendDocToFriend(),
                      friendCanEdit: provider.coordinatorCanEdit,
                      onCheckboxChanged: (value) {
                        provider.sendDocAsInvited(value);
                      },
                      onPermissionChanged: provider.docsPermissionOption
                          ? (value) => provider.setCoordinatorCanEdit(value)
                          : null,
                      onAddTap: () {
                        _textController.clear();
                        provider.addedFriendsAsCollaborator();
                      },
                      title: provider.confirmText,
                    );
                  }),
                ],
              ))),
    );
  }

  Widget itemCell(int cIndex, int userIndex) {
    CMember friend = provider.member(cIndex, userIndex);
    if (friend == null) {
      return null;
    }

    return FriendCell(
      title: friend.displayName,
      icon: friend.avatarWidget(context: context),
      selected: provider.isFriendSelected(friend),
      disable: provider.isFriendExisted(friend),
      onPressed: () {
        updateCollaborator(friend);
      },
    );
  }

  void updateCollaborator(MemberModel friend) {
    provider.isFriendSelected(friend)
        ? provider.removeCollaborator(friend)
        : provider.addCollaborator(friend);
  }
}
