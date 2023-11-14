import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.4,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
