import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      color: Colors.white,
      home: _CardsHandler(),
    );
  }
}

class _CardsHandler extends StatefulWidget {
  const _CardsHandler({Key? key}) : super(key: key);

  @override
  State<_CardsHandler> createState() => _CardsHandlerState();
}

class _CardsHandlerState extends State<_CardsHandler>
    with TickerProviderStateMixin {
  final cardSize = 150.0;

  late final cardOffsetTween = Tween<double>(
    begin: 0,
    end: 2 * cardSize,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardRotationTween = Tween<double>(
    begin: 0,
    end: 0.5,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardElevationTween = Tween<double>(
    begin: 2,
    end: 20,
  );
  late final holeSizeTween = Tween<double>(
    begin: 0,
    end: 1.5 * cardSize,
  );

  late final cardOffsetAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late final holeAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  double get cardOffset =>
      cardOffsetTween.evaluate(cardOffsetAnimationController);
  double get cardRotation =>
      cardRotationTween.evaluate(cardOffsetAnimationController);
  double get cardElevation =>
      cardElevationTween.evaluate(cardOffsetAnimationController);
  double get holeSize => holeSizeTween.evaluate(holeAnimationController);

  @override
  initState() {
    super.initState();
    holeAnimationController.addListener(() => setState(() {}));
    cardOffsetAnimationController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              holeAnimationController.forward();
              await cardOffsetAnimationController.forward();
              Future.delayed(const Duration(milliseconds: 1200),
                  () => holeAnimationController.reverse());
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {
              cardOffsetAnimationController.reverse();
              holeAnimationController.reverse();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: ClipPath(
          clipper: _BlackHoleClipper(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: holeSize,
                child: Image.asset(
                  'images/hole.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, cardOffset),
                    child: Transform.rotate(
                      angle: cardRotation,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _Card(
                          size: cardSize,
                          elevation: cardElevation,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0,
                child: SizedBox(
                  width: cardSize * 1.5,
                  child: Image.asset(
                    'assets/images/hole.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlackHoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Start from half the height at the left
    path.moveTo(0, size.height / 2);
    // Go to half the height at the right passing through the bottom center
    // using an arc
    path.arcTo(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      0,
      pi,
      true,
    );
    path.lineTo(0, -1000);

    path.lineTo(size.width, -1000);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_BlackHoleClipper oldClipper) => true;
}

class _Card extends StatelessWidget {
  const _Card({
    Key? key,
    required this.size,
    required this.elevation,
  }) : super(key: key);

  final double size;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: const Center(
            child: Text(
              'Hello\nWorld',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
