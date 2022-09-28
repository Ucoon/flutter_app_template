import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckBoxWidget extends StatefulWidget {
  final bool initValue;
  final bool isRound; //是否圆形
  final double size;
  final BorderSide? side;
  final Function(bool)? onChanged;
  final Widget Function(Widget child)? builder;

  const CheckBoxWidget({
    Key? key,
    required this.initValue,
    this.isRound = false,
    this.size = 16,
    this.side,
    this.onChanged,
    this.builder,
  }) : super(key: key);

  @override
  createState() => _CheckBoxWidget();
}

class _CheckBoxWidget extends State<CheckBoxWidget> {
  late bool _initValue;
  @override
  void initState() {
    super.initState();
    _initValue = widget.initValue;
  }

  @override
  void didUpdateWidget(covariant CheckBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initValue != oldWidget.initValue) {
      _initValue = widget.initValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: widget.size.w,
      height: widget.size.w,
      child: Checkbox(
        value: _initValue,
        activeColor: const Color(0xFFDC593B),
        shape: widget.isRound ? const CircleBorder() : null,
        side: widget.side,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onChanged: (value) {
          setState(() {
            _initValue = !_initValue;
          });
          widget.onChanged?.call(_initValue);
        },
      ),
    );

    if (widget.builder != null) {
      child = widget.builder!(child);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _initValue = !_initValue;
        });
        widget.onChanged?.call(_initValue);
      },
      child: child,
    );
  }
}
