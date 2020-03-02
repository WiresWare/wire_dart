library wire;

import 'dart:collection';

part 'layer.dart';

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/DQvsRA
/// License: MIT
///
class Wire
{
  static int _INDEX = 0;
  static WireLayer _LAYER = WireLayer();

  ///
  /// The number of times that this item will respond.
  /// Default is 0 that means infinity times.
  ///
  int replies;

  ///**************************************************
  ///  Protected / Private Properties
  ///**************************************************

  ///
  /// [read-only]
  /// The Wire SIGNAL associated with this Wire.
  ///
  /// @private
  String _signal;
  String get signal => _signal;

  ///
  /// [read-only]
  /// The closure method that this item was associated.
  ///
  /// @private
  Function _listener;

  ///
  /// [read-only] [internal use]
  /// Unique identification for this instance based on its attributes.
  ///
  /// @private
  int _hash;
  int get hash => _hash;

  Wire(String signal, Function listener, int replies)
  {
    _signal = signal;
    _listener = listener;
    this.replies = replies;

    _hash = ++_INDEX << 0x08;
    _LAYER.add(this);
  }

  ///**********************************************************************************************************
  ///
  ///  Public Static Methods
  ///
  ///**********************************************************************************************************
  static Wire add(String signal, Function listener, [int replies = 0])
  { return Wire(signal, listener, replies); }

  static bool send(String signal, [args])
  { return _LAYER.send(signal, args); }

  static bool remove(String signal)
  { return _LAYER.remove(signal); }

  ///**********************************************************************************************************
  ///
  ///  Public Methods
  ///
  ///**********************************************************************************************************
  void perform([params])
  {
    // Call a listener in this Wire.
    if (params != null) { _listener(params); }
    else { _listener(null); }
  }
}
