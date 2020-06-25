import 'package:flutter/material.dart';

class PlaceholderText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'You don\'t have any archived task',
            style: TextStyle(fontSize: 32.0),
            textAlign: TextAlign.center
          )
        ]
      )
    );
  }
}
