import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarWidget extends StatefulWidget {
  final double itemPadding;
  final double itemSize;
  final Color itemColor;
  final bool showRatingText;
  final double initialRating;
  final ValueChanged<double>? onRatingUpdate;

  const RatingBarWidget({
    Key? key,
    this.itemPadding = 5,
    this.itemSize = 22,
    this.itemColor = Colors.amber,
    this.showRatingText = true,
    this.onRatingUpdate,
    this.initialRating = 5,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: widget.initialRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: widget.itemSize,
          itemPadding: EdgeInsets.symmetric(horizontal: widget.itemPadding),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: widget.itemColor,
          ),
          updateOnDrag: false,
          onRatingUpdate: (double value) {
            if (widget.onRatingUpdate != null) {
              widget.onRatingUpdate!(value);
            }
          },
        ),
      ],
    );
  }
}
