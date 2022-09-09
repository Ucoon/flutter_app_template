import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget.dart';

class RoundCheckBox extends StatefulWidget {
  final bool initValue;

  final Function(bool)? onChanged;

  const RoundCheckBox({
    Key? key,
    required this.initValue,
    this.onChanged,
  }) : super(key: key);

  @override
  createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  late bool _initValue;
  @override
  void initState() {
    super.initState();
    _initValue = widget.initValue;
  }

  @override
  void didUpdateWidget(covariant RoundCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initValue != oldWidget.initValue) {
      _initValue = widget.initValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _initValue = !_initValue;
        });
        if (widget.onChanged == null) return;
        widget.onChanged!(_initValue);
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.transparent,
        child: _initValue
            ? getIconPng('ic_check_selected', iconSize: 18.w)
            : getIconPng('ic_check_unselected', iconSize: 18.w),
      ),
    );
  }
}
