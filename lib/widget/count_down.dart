import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef FormatDurationFunction = String Function(Duration timeDiff);

class CountDown extends StatefulWidget {
  @override
  _CountDownState createState() => _CountDownState();
  final DateTime endTime;
  final String labelPrefixStart;
  final String labelPrefix;
  final String labelPrefixEnd;
  final FormatDurationFunction formatter;
  final TextStyle labelStyle;
  final VoidCallback? timeoutCallback;
  final Function? timeCallback;
  final Function? timeFinishCallback;

  const CountDown(this.endTime, this.labelStyle, this.formatter,
      {Key? key,
      this.labelPrefix = '',
      this.labelPrefixStart = '',
      this.labelPrefixEnd = '',
      this.timeoutCallback,
      this.timeCallback,
      this.timeFinishCallback})
      : super(key: key);
}

class _CountDownState extends State<CountDown> {
  Duration timeDiff = Duration.zero;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        timeDiff = widget.endTime.difference(DateTime.now());
      });
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final diff = widget.endTime.difference(DateTime.now());
      if (mounted) {
        setState(() {
          timeDiff = diff;
        });
      }
      if (widget.timeCallback != null) widget.timeCallback!(_timer.tick);
      if (diff <= Duration.zero) {
        timer.cancel();
        if (widget.timeFinishCallback != null) widget.timeFinishCallback!(true);
        widget.timeoutCallback?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (timeDiff <= Duration.zero) return const SizedBox();
    final _label = widget.formatter.call(timeDiff);
    final left = widget.labelPrefix.isEmpty ? '' : '${widget.labelPrefix} ';
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text.rich(
          TextSpan(
            text: widget.labelPrefixStart,
            style: TextStyle(
              color: const Color(0xFF84858A),
              fontSize: 10.sp,
            ),
            children: <InlineSpan>[
              TextSpan(
                text: '$left$_label',
                style: widget.labelStyle,
              ),
              TextSpan(
                text: widget.labelPrefixEnd,
                style: TextStyle(
                  color: const Color(0xFF84858A),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
