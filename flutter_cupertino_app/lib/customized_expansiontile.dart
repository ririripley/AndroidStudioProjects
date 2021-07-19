import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);
const double _angleEnd = 0.25;
const double _angelBegin = 0.0;

/// This widget is adapted from ExpansionTile of Flutter. It differs from the original version in the following aspects:
/// (1) Customized divider color
/// (2) Customized divider display time
/// (3) Customized title color when expanded
/// (4) Customized rotated leading widget

enum DividerDisplayTime {
  always,
  expanded,
  collapsed,
}

class CustomizedExpansionTile extends StatefulWidget {
  const CustomizedExpansionTile({
    Key key,
    this.leading,
    @required this.title,
    this.subtitle,
    this.trailing,
    this.backgroundColor = Colors.transparent,
    this.titleBarColor = Colors.transparent,
    this.dividerDisplayTime = DividerDisplayTime.expanded,
    this.dividerColor,
    this.enableBottomDivider = true,
    this.enableTopDivider = true,
    this.iconColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding = EdgeInsets.zero,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.leadingIconInitialAngle,
    this.leadingIconFinalAngle,
    this.headerColor,
  })  : assert(initiallyExpanded != null),
        assert(maintainState != null),
        assert(
        expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
        'CrossAxisAlignment.baseline is not supported since the expanded children '
            'are aligned in a column, not a row. Try to use another constant.',
        ),
        super(key: key);

  /// Specifies the color of the divider.
  final Color dividerColor;

  /// Specifies when to display the divider (only works when divider is enabled).
  /// Set to display when the tile expanded by default.
  final DividerDisplayTime dividerDisplayTime;

  /// The color of leading widget.
  final Color iconColor;

  /// Specifies if the top and bottom divider is enabled (true, by default).
  final bool enableBottomDivider;
  final bool enableTopDivider;

  /// The rotation angle of the leading widget when the tile collapses.
  final double leadingIconInitialAngle;

  /// The rotation angle of the leading widget when the tile expands.
  final double leadingIconFinalAngle;

  /// The color of the text in the title when expanded.
  final Color headerColor;

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget subtitle;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// The color of title bar.
  final Color titleBarColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  /// Specifies whether the state of the children is maintained when the tile expands and collapses.
  ///
  /// When true, the children are kept in the tree while the tile is collapsed.
  /// When false (default), the children are removed from the tree when the tile is
  /// collapsed and recreated upon expansion.
  final bool maintainState;

  /// Specifies padding for the [ListTile].
  ///
  /// Analogous to [ListTile.contentPadding], this property defines the insets for
  /// the [leading], [title], [subtitle] and [trailing] widgets. It does not inset
  /// the expanded [children] widgets.
  ///
  /// When the value is null, the tile's padding is `EdgeInsets.symmetric(horizontal: 16.0)`.
  final EdgeInsetsGeometry tilePadding;

  /// Specifies the alignment of [children], which are arranged in a column when
  /// the tile is expanded.
  ///
  /// The internals of the expanded tile make use of a [Column] widget for
  /// [children], and [Align] widget to align the column. The `expandedAlignment`
  /// parameter is passed directly into the [Align].
  ///
  /// Modifying this property controls the alignment of the column within the
  /// expanded tile, not the alignment of [children] widgets within the column.
  /// To align each child within [children], see [expandedCrossAxisAlignment].
  ///
  /// The width of the column is the width of the widest child widget in [children].
  ///
  /// When the value is null, the value of `expandedAlignment` is [Alignment.center].
  final Alignment expandedAlignment;

  /// Specifies the alignment of each child within [children] when the tile is expanded.
  ///
  /// The internals of the expanded tile make use of a [Column] widget for
  /// [children], and the `crossAxisAlignment` parameter is passed directly into the [Column].
  ///
  /// Modifying this property controls the cross axis alignment of each child
  /// within its [Column]. Note that the width of the [Column] that houses
  /// [children] will be the same as the widest child widget in [children]. It is
  /// not necessarily the width of [Column] is equal to the width of expanded tile.
  ///
  /// To align the [Column] along the expanded tile, use the [expandedAlignment] property
  /// instead.
  ///
  /// When the value is null, the value of `expandedCrossAxisAlignment` is [CrossAxisAlignment.center].
  final CrossAxisAlignment expandedCrossAxisAlignment;

  /// Specifies padding for [children].
  ///
  /// When the value is null, the value of `childrenPadding` is [EdgeInsets.zero].
  final EdgeInsetsGeometry childrenPadding;

  @override
  _CustomizedExpansionTileState createState() => _CustomizedExpansionTileState();
}

class _CustomizedExpansionTileState extends State<CustomizedExpansionTile> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _sublistBackgroundColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _sublistBackgroundColor;
  Animatable<double> _rotationTween;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _rotationTween = Tween<double>(
        begin: widget.leadingIconInitialAngle ?? _angelBegin, end: widget.leadingIconFinalAngle ?? _angleEnd);
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_rotationTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _sublistBackgroundColor = _controller.drive(_sublistBackgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)?.readState(context) as bool ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _sublistBackgroundColor.value,
        border: Border(
          top: BorderSide(color: widget.enableTopDivider ? borderSideColor : widget.titleBarColor),
          bottom: BorderSide(color: widget.enableBottomDivider ? borderSideColor : widget.titleBarColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            tileColor: widget.titleBarColor,
            iconColor: _iconColor.value,
            textColor: _headerColor.value,
            child: ListTile(
                onTap: _handleTap,
                contentPadding: EdgeInsets.zero,
                title: widget.title,
                subtitle: widget.subtitle,
                leading: (widget.leading != null
                    ? SizedBox(
                  width: 30,
                  height: 80,
                  child: RotationTransition(turns: _iconTurns, child: widget.leading),
                )
                    : null),
                trailing: widget.trailing),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    setupHeaderColorTween();
    setupDidvierColorTween();
    setupIconColorTween();
    setupBackgroundColor();
  }

  void setupHeaderColorTween() {
    final ThemeData theme = Theme.of(context);

    _headerColorTween
      ..begin = theme.textTheme.subtitle1.color
      ..end = widget.headerColor ?? theme.accentColor;
  }

  void setupDidvierColorTween() {
    final ThemeData theme = Theme.of(context);

    Color beginColor = this.widget.dividerColor ?? theme.dividerColor;
    Color endColor = beginColor;

    switch (widget.dividerDisplayTime) {
      case DividerDisplayTime.always:
        break;
      case DividerDisplayTime.collapsed:
        endColor = Colors.transparent;
        break;
      case DividerDisplayTime.expanded:
        beginColor = Colors.transparent;
        break;
      default:
    }
    _borderColorTween
      ..begin = beginColor
      ..end = endColor;
  }

  void setupIconColorTween() {
    final ThemeData theme = Theme.of(context);

    Color beginColor = this.widget.iconColor ?? theme.unselectedWidgetColor;
    Color endColor = beginColor;

    _iconColorTween
      ..begin = beginColor
      ..end = endColor;
  }

  void setupBackgroundColor() {
    _sublistBackgroundColorTween
      ..begin = Colors.transparent
      ..end = widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
        child: TickerMode(
          child: Padding(
            padding: widget.childrenPadding ?? EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
              children: widget.children,
            ),
          ),
          enabled: !closed,
        ),
        offstage: closed);

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
