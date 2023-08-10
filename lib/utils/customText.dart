import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class customText extends StatelessWidget {
  const customText({super.key,this.weight=FontWeight.normal,this.size=16,required this.text,this.color=Colors.black});
  final String  text;
  final Color color;
  final FontWeight weight;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(fontWeight: weight,color: color,fontSize: size),);
  }
}