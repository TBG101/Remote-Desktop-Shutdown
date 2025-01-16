import 'package:flutter/material.dart';

class ShutdownButton extends StatelessWidget {
  final Function callback;

  const ShutdownButton({
    super.key,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.all(50),
        child: Center(
            child: SizedBox(
                width: size.width,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  splashColor: Color.fromARGB(255, 184, 3, 255),
                  style: ElevatedButton.styleFrom(),
                  icon: Image.asset("lib/assets/power.png"),
                  onPressed: () {
                    callback();
                  },
                ))));
  }
}
