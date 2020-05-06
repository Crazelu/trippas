import 'package:flutter/material.dart';

import 'home.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  void delay() async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Home();
    }));
  }

  @override
  void initState() {
    super.initState();
    delay();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Material(
              color: Theme.of(context).primaryColorLight,
              child: Transform(
                transform: Matrix4.translationValues(
                    animation.value * width, 0.0, 0.0),
                child: Center(
                  child: Text(
                    'Trippas',
                    style: TextStyle(
                        fontFamily: 'SourceCodePro',
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
              ));
        });
  }
}
