import 'package:flutter/material.dart';

class ShutdownButton extends StatelessWidget {
  final Function callback;

  const ShutdownButton({
    super.key,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      splashColor: Color.fromARGB(255, 184, 3, 255),
      style: ElevatedButton.styleFrom(),
      icon: Image.asset("lib/assets/power.png"),
      onPressed: () {
        callback();
      },
    );
  }
}
