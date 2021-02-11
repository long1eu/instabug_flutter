import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Instabug {
  static const MethodChannel _channel = const MethodChannel('com.instabug/instabug');

  Future<void> start(String token, List<InvocationEvent> events) async {
    if (events.isEmpty) {
      events.add(InvocationEvent.none);
    }
    await _channel.invokeMethod('start', [token, ...events.map((e) => e.name).toList()]);
  }

  Future<void> identifyUser({@required String name, @required String email}) async {
    await _channel.invokeMethod('identifyUser', [name, email]);
  }

  Future<void> setWelcomeMessageMode(WelcomeMessageMode mode) async {
    await _channel.invokeMethod('setWelcomeMessageMode', mode.name);
  }

  Future<void> showWelcomeMessage(WelcomeMessageMode mode) async {
    await _channel.invokeMethod('showWelcomeMessage', mode.name);
  }

  Future<void> setBrightness(Brightness brightness) async {
    await _channel.invokeMethod('setBrightness', '$brightness'.split('.')[1]);
  }

  Future<void> setPrimaryColor(Color color) async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('setPrimaryColor', color.value);
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('setPrimaryColor',
          [color.alpha, color.red, color.green, color.blue].map((int value) => value / 255).toList());
    }
  }

  Future<void> setInAppNotificationEnabled(bool enabled) async {
    await _channel.invokeMethod('setInAppNotificationEnabled', enabled ?? false);
  }

  Future<void> setLocale(Locale locale) async {
    await _channel.invokeMethod(
      'setLocale',
      <String>[
        locale.languageCode ?? '',
        locale.countryCode ?? '',
        locale.scriptCode ?? '',
      ],
    );
  }

  Future<void> logOut() async {
    await _channel.invokeMethod('logOut');
  }

  Future<void> show() async {
    await _channel.invokeMethod('show');
  }

  Future<void> replies() async {
    await _channel.invokeMethod('replies');
  }

  Future<bool> hasChats() async {
    return _channel.invokeMethod('hasChats');
  }

  Future<int> getUnreadRepliesCount() async {
    return _channel.invokeMethod('getUnreadRepliesCount');
  }
}

class InvocationEvent {
  const InvocationEvent._(this.name);

  final String name;

  static const InvocationEvent none = InvocationEvent._('none');
  static const InvocationEvent shake = InvocationEvent._('shake');
  static const InvocationEvent floatingButton = InvocationEvent._('floatingButton');
  static const InvocationEvent screenshot = InvocationEvent._('screenshot');
  static const InvocationEvent twoFingerSwipeLeft = InvocationEvent._('twoFingerSwipeLeft');

  @override
  String toString() => 'InvocationEvent.$name';
}

class WelcomeMessageMode {
  const WelcomeMessageMode._(this.name);

  final String name;

  static const WelcomeMessageMode live = WelcomeMessageMode._('live');
  static const WelcomeMessageMode beta = WelcomeMessageMode._('beta');
  static const WelcomeMessageMode disabled = WelcomeMessageMode._('disabled');

  @override
  String toString() => 'WelcomeMessageMode.$name';
}
