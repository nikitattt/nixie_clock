import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Nixie extends StatefulWidget {
  Nixie({Key key, @required this.timeNumber}) : super(key: key);
  final int timeNumber;

  @override
  _NixieState createState() => _NixieState();
}

class _NixieState extends State<Nixie> {
  String _animation;

  void _setOffAnimation() {
    int number;

    if (widget.timeNumber == 0) {
      number = 9;
    } else if (widget.timeNumber == 9) {
      number = 0;
    } else {
      number = widget.timeNumber - 1;
    }
    _animation = '${number}Off';
  }

  @override
  void initState() {
    _setOffAnimation();
    super.initState();
  }

@override
  void didUpdateWidget(Nixie oldWidget) {
    if (oldWidget.timeNumber != widget.timeNumber) {
      _setOffAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FlareActor("assets/rive/nixie.flr", animation: _animation,
      callback: (name) {
      if (name.contains("Off")) {
        setState(() {
          _animation = '${widget.timeNumber}On';
        });
      }
    });
  }
}
