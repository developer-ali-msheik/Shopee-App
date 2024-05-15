import 'package:flutter/material.dart';

const blueColor = Colors.blue;
const greyColors = Colors.grey;
final greyColor800 = Colors.grey.shade800;

class ConstantText extends StatelessWidget {
  const ConstantText(this.text, this.fontsize, this.fontweight, this.color,
      {super.key});
  final String text;
  final double fontsize;
  final FontWeight fontweight;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontweight,
        color: color,
      ),
    );
  }
}

class ConstantTextNoFontWeight extends StatelessWidget {
  const ConstantTextNoFontWeight(this.text, this.fontsize, this.color,
      {super.key});
  final String text;
  final double fontsize;

  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        color: color,
      ),
    );
  }
}

class ConstantTextWithAlign extends StatelessWidget {
  const ConstantTextWithAlign(
      this.text, this.fontsize, this.color, this.align, this.fontweight,
      {super.key});
  final String text;
  final double fontsize;
  final TextAlign align;
  final FontWeight fontweight;

  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontweight,
        color: color,
      ),
      textAlign: align,
    );
  }
}
