import 'package:flutter/material.dart';

class MouseButtonWidget extends StatelessWidget {
  const MouseButtonWidget(
      {super.key, this.onTap, this.onTapDown, this.onTapUp, this.width});

  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.grey[800],
        child: InkWell(
          onTap: () => {onTap?.call()},
          onTapDown: (_) => {onTapDown?.call()},
          onTapUp: (_) => {onTapUp?.call()},
          splashColor: const Color.fromRGBO(255, 255, 255, 0.25),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          child: Container(
            width: width,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                color: const Color.fromARGB(111, 255, 255, 255),
                width: 1,
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
