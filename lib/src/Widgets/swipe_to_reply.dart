import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipeToReply extends StatefulWidget {
  /// Child widget for which you want to have horizontal swipe action
  /// @required parameter
  final Widget child;

  /// Duration value to define animation duration
  /// if not passed default Duration(milliseconds: 150) will be taken
  final Duration animationDuration;

  /// Icon that will be displayed beneath child widget when swipe right
  final IconData iconOnRightSwipe;

  /// Widget that will be displayed beneath child widget when swipe right
  final Widget? rightSwipeWidget;

  /// Icon that will be displayed beneath child widget when swipe left
  final IconData iconOnLeftSwipe;

  /// Widget that will be displayed beneath child widget when swipe right
  final Widget? leftSwipeWidget;

  /// double value defining size of displayed icon beneath child widget
  /// if not specified default size 26 will be taken
  final double iconSize;

  /// color value defining color of displayed icon beneath child widget
  ///if not specified primaryColor from theme will be taken
  final Color? iconColor;

  /// Double value till which position child widget will get animate when swipe left
  /// or swipe right
  /// if not specified 0.3 default will be taken for Right Swipe &
  /// it's negative -0.3 will bve taken for Left Swipe
  final double offsetDx;

  /// bool value till which indicate whether the it is swip right or left
  /// true for right swipe while false for left
  final bool isRightSwipe;

  /// callback which will be initiated at the end of child widget animation
  /// when swiped right
  /// if not passed swipe to right will be not available
  final GestureDragEndCallback? onRightSwipe;

  /// callback which will be initiated at the end of child widget animation
  /// when swiped left
  /// if not passed swipe to left will be not available
  final GestureDragEndCallback? onLeftSwipe;

  /// callback which will be initiated when user long press or hold
  final VoidCallback? onHold;

  const SwipeToReply({
    Key? key,
    required this.child,
    required this.isRightSwipe,
    this.onRightSwipe,
    this.onLeftSwipe,
    this.onHold,
    this.iconOnRightSwipe = CupertinoIcons.arrowshape_turn_up_left_fill,
    this.rightSwipeWidget,
    this.iconOnLeftSwipe = CupertinoIcons.arrowshape_turn_up_right_fill,
    this.leftSwipeWidget,
    this.iconSize = 22.0,
    this.iconColor = Colors.grey,
    this.animationDuration = const Duration(milliseconds: 130),
    this.offsetDx = 0.2,
  }) : super(key: key);

  @override
  _SwipeToReplyState createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _leftIconAnimation;
  late Animation<double> _rightIconAnimation;
  late GestureDragEndCallback _onSwipeLeft;
  late GestureDragEndCallback _onSwipeRight;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: _controller),
    );
    _leftIconAnimation = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.0),
    );
    _rightIconAnimation = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.0),
    );
    _onSwipeLeft = widget.onLeftSwipe ??
        (details) {
          throw ("Left Swipe Not Provided");
        };

    _onSwipeRight = widget.onRightSwipe ??
        (details) {
          throw ("Left Swipe Not Provided");
        };
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///Run animation for child widget
  ///[onRight] value defines animation Offset direction
  void _runAnimation() {
    //set child animation

    _animation = Tween(
      begin: const Offset(0.0, 0.0),
      end:
          Offset(widget.isRightSwipe ? widget.offsetDx : -widget.offsetDx, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: _controller),
    );
    //set back left/right icon animation
    if (widget.isRightSwipe) {
      _leftIconAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
      _rightIconAnimation = Tween(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
    } else {
      _rightIconAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
      _leftIconAnimation = Tween(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
    }
    //Forward animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onHold,
      onHorizontalDragEnd: ((details) {
        _controller.reverse().whenComplete(() {
          if (widget.isRightSwipe) {
            //keep left icon visibility to 0.0 until onRightSwipe triggers again
            // _leftIconAnimation = _controller.drive(Tween(begin: 0.0, end: 0.0));
            _onSwipeRight(details);
          } else {
            //keep right icon visibility to 0.0 until onLeftSwipe triggers again
            // _rightIconAnimation = _controller.drive(Tween(begin: 0.0, end: 0.0));

            _onSwipeLeft(details);
          }
        });
      }),
      onHorizontalDragStart: (details) {
        if (widget.isRightSwipe) {
          if (details.localPosition.dx > 2) {
            _runAnimation();
          }
        } else {
          if (details.localPosition.dx > -2) {
            _runAnimation();
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _leftIconAnimation.value,
                duration: widget.animationDuration,
                curve: Curves.decelerate,
                child: widget.rightSwipeWidget ??
                    Icon(
                      widget.iconOnRightSwipe,
                      size: widget.iconSize,
                      color:
                          widget.iconColor ?? Theme.of(context).iconTheme.color,
                    ),
              ),
              AnimatedOpacity(
                opacity: _rightIconAnimation.value,
                duration: widget.animationDuration,
                curve: Curves.decelerate,
                child: widget.leftSwipeWidget ??
                    Icon(
                      widget.iconOnLeftSwipe,
                      size: widget.iconSize,
                      color:
                          widget.iconColor ?? Theme.of(context).iconTheme.color,
                    ),
              ),
            ],
          ),
          SlideTransition(
            position: _animation,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
