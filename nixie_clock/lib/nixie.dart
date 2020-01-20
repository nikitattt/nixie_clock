// Copyright 2020 Nikita Goncharuk. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Nixie extends StatefulWidget {
  Nixie({Key key, @required this.timeNumber, @required this.maxTimeNumber})
      : super(key: key);
  final int timeNumber;
  final int maxTimeNumber;

  @override
  _NixieState createState() => _NixieState();
}

class _NixieState extends State<Nixie> {
  String _animation;

  void _setOffAnimation() {
    if (widget.timeNumber == 0) {
      _animation = '${widget.maxTimeNumber}Off';
    } else {
      _animation = '${widget.timeNumber - 1}Off';
    }
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: ScreenUtil().setHeight(700),
        child: FlareActor("assets/rive/nixie.flr", animation: _animation,
            callback: (name) {
          if (name.contains("Off")) {
            setState(() {
              _animation = '${widget.timeNumber}On';
            });
          }
        }),
      ),
    );
  }
}
