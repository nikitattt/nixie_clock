// Copyright 2020 Nikita Goncharuk. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nixie_clock/nixie.dart';

enum _NumberExtractType { first, second }

class NixieClock extends StatefulWidget {
  const NixieClock(this.model);

  final ClockModel model;

  @override
  _NixieClockState createState() => _NixieClockState();
}

class _NixieClockState extends State<NixieClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didChangeDependencies() {
    ScreenUtil.init(context, width: 1600, height: 960);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(NixieClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  int _extractOneNumber(int number, _NumberExtractType type) {
    if (type == _NumberExtractType.first) {
      return number ~/ 10;
    } else {
      return number % 10;
    }
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    final hourFirst =
        _extractOneNumber(int.parse(hour), _NumberExtractType.first);
    final hourSecond =
        _extractOneNumber(int.parse(hour), _NumberExtractType.second);
    final minuteFirst =
        _extractOneNumber(int.parse(minute), _NumberExtractType.first);
    final minuteSecond =
        _extractOneNumber(int.parse(minute), _NumberExtractType.second);

    return Container(
      color: const Color.fromRGBO(10, 10, 10, 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Nixie(timeNumber: hourFirst, maxTimeNumber: 2),
              ),
              Expanded(
                flex: 2,
                child: Nixie(timeNumber: hourSecond, maxTimeNumber: 9),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: ScreenUtil().setHeight(700),
                    child: FlareActor(
                      "assets/rive/nixie_middle.flr",
                      animation: 'idle',
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Nixie(timeNumber: minuteFirst, maxTimeNumber: 5),
              ),
              Expanded(
                flex: 2,
                child: Nixie(timeNumber: minuteSecond, maxTimeNumber: 9),
              ),
            ],
          ),
          Container(
            height: ScreenUtil().setHeight(95),
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(6)),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(56, 57, 59, 1.0),
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(5))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
                child: _baseLeg,
              ),
              Padding(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(27)),
                child: _baseLeg,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget get _baseLeg {
    return Container(
        height: ScreenUtil().setHeight(40),
        width: ScreenUtil().setWidth(110),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(124, 126, 130, 1.0),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(ScreenUtil().setWidth(5)),
            bottomRight: Radius.circular(ScreenUtil().setWidth(5)),
          ),
        ));
  }
}
