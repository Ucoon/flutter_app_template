import 'package:flutter/cupertino.dart';

class SwitchFieldWidget extends StatefulWidget {
  const SwitchFieldWidget(
    this.selected, {
    Key? key,
    this.onChanged,
  }) : super(key: key);

  final ValueChanged<bool>? onChanged;
  final bool selected;

  @override
  _SwitchFieldWidgetState createState() => _SwitchFieldWidgetState();
}

class _SwitchFieldWidgetState extends State<SwitchFieldWidget> {
  bool? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant SwitchFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      _selected = widget.selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: 0.8,
        child: CupertinoSwitch(
          activeColor: const Color(0xFF64C365),
          value: _selected ?? false,
          onChanged: (selected) {
            setState(() {
              _selected = selected;
            });
            widget.onChanged?.call(selected);
          },
        ));
  }
}
