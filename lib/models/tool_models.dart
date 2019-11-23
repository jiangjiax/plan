import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

Widget myProgress(double percent, double r) {
  var p = percent * 100;
  p = double.parse(p.toStringAsExponential(2));
  return new CircularPercentIndicator(
    radius: r,
    lineWidth: 3.0,
    animation: true,
    percent: percent,
    center: new Text(
      p.toString() + "%",
      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
    ),
    circularStrokeCap: CircularStrokeCap.round,
    progressColor: Colors.blue,
  );
}