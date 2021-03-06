import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KCheckBox extends StatefulWidget {
  final bool initValue;
  final bool isRound; //是否圆形
  final double size;
  final BorderSide? side;
  final Function(bool)? onChanged;
  final Widget Function(Widget child)? builder;

  const KCheckBox({
    Key? key,
    required this.initValue,
    this.isRound = false,
    this.size = 16,
    this.side,
    this.onChanged,
    this.builder,
  }) : super(key: key);

  @override
  createState() => _KCheckBoxState();
}

class _KCheckBoxState extends State<KCheckBox> {
  late bool _initValue;
  @override
  void initState() {
    super.initState();
    _initValue = widget.initValue;
  }

  @override
  void didUpdateWidget(covariant KCheckBox oldWidget) {
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
        // visualDensity: VisualDensity(horizontal: 10, vertical: 10),
        onChanged: (value) {
          setState(() {
            _initValue = !_initValue;
          });
          if (widget.onChanged == null) return;
          widget.onChanged!(_initValue);
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
        if (widget.onChanged == null) return;

        widget.onChanged!(_initValue);
      },
      child: child,
    );
  }
}
