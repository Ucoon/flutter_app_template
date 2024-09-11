import 'package:flutter/material.dart';

class FirstAnimationWidget extends StatefulWidget {
  const FirstAnimationWidget({
    Key? key,
    required this.child,
    required this.callback,
  }) : super(key: key);
  final Widget child;
  final VoidCallback callback;

  @override
  State<FirstAnimationWidget> createState() => _FirstAnimationWidgetState();
}

class _FirstAnimationWidgetState extends State<FirstAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _startAnimated();
  }

  void _startAnimated() {
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final opacity = CurveTween(curve: Curves.easeInOut).animate(controller);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        widget.callback();
        return;
      },
      child: FadeTransition(
        opacity: opacity,
        child: GestureDetector(
          onTap: widget.callback,
          child: Material(
            color: Colors.black54,
            child: SizedBox.expand(
                child: GestureDetector(onTap: () {}, child: widget.child)),
          ),
        ),
      ),
    );
  }
}
