import 'package:flutter/material.dart';

class SliderBackgroud extends StatelessWidget {
  final Color backgroud;
  final IconData icon;
  final MainAxisAlignment alignment;

  SliderBackgroud({this.backgroud, this.icon, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroud,
        child: Align(
          child: Row(
              mainAxisAlignment: alignment,
              children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            )
          ]
        )
      )
    );
  }
}
