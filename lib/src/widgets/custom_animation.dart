import 'dart:async';
import 'package:flutter/material.dart';

class CustomAnimation extends StatefulWidget {
  final Widget child;

  const CustomAnimation({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _CustomAnimationState createState() => _CustomAnimationState();
}

class _CustomAnimationState extends State<CustomAnimation>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  );
  late final _curve = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOutQuad,
  );
  late final Animation<double> _smallDiscAnimation = Tween(
    begin: (60 * 2) / 6,
    end: (60 * 2) * (3 / 4),
  ).animate(_curve);
  late final Animation<double> _bigDiscAnimation = Tween(
    begin: 0.0,
    end: (60.0 * 2),
  ).animate(_curve);
  late final Animation<double> _alphaAnimation = Tween(
    begin: 0.30,
    end: 0.0,
  ).animate(controller);

  late void Function(AnimationStatus status) statusListener = (_) async {
    if (controller.status == AnimationStatus.completed) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      );
      if (mounted) {
        controller.reset();
        controller.forward();
      }
    }
  };

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    controller.addStatusListener(statusListener);
    if (mounted) {
      controller.reset();
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _alphaAnimation,
      child: widget.child,
      builder: (context, widgetChild) {
        final decoration = BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary.withOpacity(
                _alphaAnimation.value.clamp(
                  0.0,
                  1.0,
                ),
              ),
        );
        return SizedBox(
          height: 30 * 2,
          width: 30 * 2,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _bigDiscAnimation,
                builder: (context, widget) {
                  final num size = _bigDiscAnimation.value.clamp(
                    0.0,
                    double.infinity,
                  );
                  return Container(
                    height: size as double?,
                    width: size as double?,
                    decoration: decoration,
                  );
                },
              ),
              AnimatedBuilder(
                animation: _smallDiscAnimation,
                builder: (context, widget) {
                  final num size = _smallDiscAnimation.value.clamp(
                    0.0,
                    double.infinity,
                  );

                  return Container(
                    height: size as double?,
                    width: size as double?,
                    decoration: decoration,
                  );
                },
              ),
              widgetChild!,
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
