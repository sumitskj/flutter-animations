import 'dart:math';

import 'package:flutter/cupertino.dart';

class Riugh extends StatelessWidget {
  const Riugh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.loose,
      children: [
        Transform.rotate(
          angle: (90 * pi) / 180, // Converting degrees to radians
          child: const Image(
            image: AssetImage('lib/assets/wheel.png'),
          ),
        ),
        const Image(
          image: AssetImage('lib/assets/arrow.png'),
        )
      ],
    );
  }
}

class AnimationControllerExample extends StatefulWidget {
  const AnimationControllerExample({Key? key}) : super(key: key);

  @override
  State<AnimationControllerExample> createState() =>
      _AnimationControllerExampleState();
}

class _AnimationControllerExampleState extends State<AnimationControllerExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
