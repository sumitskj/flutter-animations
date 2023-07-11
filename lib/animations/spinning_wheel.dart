import 'dart:math';

import 'package:flutter/material.dart';

class WheelJackpotAnimation extends StatelessWidget {
  final AnimationController animationController;
  final int winner;
  final Animation<double> rotationTween;

  WheelJackpotAnimation(
      {Key? key, required this.animationController, required this.winner})
      : rotationTween = Tween<double>(
          begin: 0,
          end: 10 * 360 + 72 * winner.toDouble(),
        ).animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0, 1, curve: Curves.decelerate))),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: const Image(
        image: AssetImage('lib/assets/wheel.png'),
      ),
      builder: (context, child) => Transform.rotate(
        angle: (rotationTween.value * pi) / 180,
        child: child,
      ),
    );
  }
}

class SpinningWheel extends StatefulWidget {
  const SpinningWheel({Key? key}) : super(key: key);

  @override
  State<SpinningWheel> createState() => _SpinningWheelState();
}

class _SpinningWheelState extends State<SpinningWheel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> rotationTween;
  int winner = Random().nextInt(5);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          winnerTag = "winner is $winner";
          _scaleDialog();
        });
      }
    });
  }

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF7D59E7),
      title: const Center(
        child: Text(
          '🥳🎊🎊🎉',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      content: Text(
        youWonFunction(),
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
      ),
    );
  }

  String youWonFunction() {
    if (winner == 0) return 'You won Tesla Model 5';
    if (winner == 1) return 'You have to goto hell!!';
    if (winner == 2) return 'You won Ducati Scrambler';
    if (winner == 3) return 'You have to goto hell!!';
    return 'You won 1 Million Dollars';
  }

  void _scaleDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Card',
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String winnerTag = "";

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF7D59E7),
      body: SizedBox(
        height: mediaQueryData.size.height,
        width: mediaQueryData.size.width,
        child: Stack(
          children: [
            SizedBox(
                height: mediaQueryData.size.height,
                width: mediaQueryData.size.width,
                child: const GridPaper()),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.center,
                    children: [
                      WheelJackpotAnimation(
                        animationController: _controller,
                        winner: winner,
                      ),
                      const Image(
                        image: AssetImage('lib/assets/arrow.png'),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      if (_controller.isAnimating) return;
                      setState(() {
                        winner = Random().nextInt(5);
                        winnerTag = "";
                      });
                      _controller.reset();
                      _controller.forward().orCancel;
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        if (_controller.isAnimating) return;
                        setState(() {
                          winner = Random().nextInt(5);
                          winnerTag = "";
                        });
                        _controller.reset();
                        _controller.forward().orCancel;
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 100)),
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => _controller.isAnimating
                                ? const Color(0xFF5A5A5A)
                                : const Color(0xFFD6FD17),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                            ),
                          )),
                      child: const Text(
                        'Spin',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
