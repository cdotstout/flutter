// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('debugPrintGestureArenaDiagnostics', (WidgetTester tester) {
    PointerEvent event;
    debugPrintGestureArenaDiagnostics = true;
    final DebugPrintCallback oldCallback = debugPrint;
    final List<String> log = <String>[];
    debugPrint = (String s, { int wrapWidth }) { log.add(s); };

    final TapGestureRecognizer tap = new TapGestureRecognizer()
      ..onTapDown = (TapDownDetails details) { }
      ..onTapUp = (TapUpDetails details) { }
      ..onTap = () { }
      ..onTapCancel = () { };
    expect(log, isEmpty);

    event = const PointerDownEvent(pointer: 1, position: const Offset(10.0, 10.0));
    tap.addPointer(event);
    expect(log, hasLength(2));
    expect(log[0], equalsIgnoringHashCodes('Gesture arena 1    ❙ ★ Opening new gesture arena.'));
    expect(log[1], equalsIgnoringHashCodes('Gesture arena 1    ❙ Adding: TapGestureRecognizer#00000(state: ready)'));
    log.clear();

    GestureBinding.instance.gestureArena.close(1);
    expect(log, hasLength(1));
    expect(log[0], equalsIgnoringHashCodes('Gesture arena 1    ❙ Closing with 1 member.'));
    log.clear();

    GestureBinding.instance.pointerRouter.route(event);
    expect(log, isEmpty);

    event = const PointerUpEvent(pointer: 1, position: const Offset(12.0, 8.0));
    GestureBinding.instance.pointerRouter.route(event);
    expect(log, isEmpty);

    GestureBinding.instance.gestureArena.sweep(1);
    expect(log, hasLength(2));
    expect(log[0], equalsIgnoringHashCodes('Gesture arena 1    ❙ Sweeping with 1 member.'));
    expect(log[1], equalsIgnoringHashCodes('Gesture arena 1    ❙ Winner: TapGestureRecognizer#00000(state: ready, finalPosition: Offset(12.0, 8.0))'));
    log.clear();

    tap.dispose();
    expect(log, isEmpty);

    debugPrintGestureArenaDiagnostics = false;
    debugPrint = oldCallback;
  });

  testWidgets('debugPrintRecognizerCallbacksTrace', (WidgetTester tester) {
    PointerEvent event;
    debugPrintRecognizerCallbacksTrace = true;
    final DebugPrintCallback oldCallback = debugPrint;
    final List<String> log = <String>[];
    debugPrint = (String s, { int wrapWidth }) { log.add(s); };

    final TapGestureRecognizer tap = new TapGestureRecognizer()
      ..onTapDown = (TapDownDetails details) { }
      ..onTapUp = (TapUpDetails details) { }
      ..onTap = () { }
      ..onTapCancel = () { };
    expect(log, isEmpty);

    event = const PointerDownEvent(pointer: 1, position: const Offset(10.0, 10.0));
    tap.addPointer(event);
    expect(log, isEmpty);

    GestureBinding.instance.gestureArena.close(1);
    expect(log, isEmpty);

    GestureBinding.instance.pointerRouter.route(event);
    expect(log, isEmpty);

    event = const PointerUpEvent(pointer: 1, position: const Offset(12.0, 8.0));
    GestureBinding.instance.pointerRouter.route(event);
    expect(log, isEmpty);

    GestureBinding.instance.gestureArena.sweep(1);
    expect(log, hasLength(3));
    expect(log[0], equalsIgnoringHashCodes('TapGestureRecognizer#00000(state: ready, finalPosition: Offset(12.0, 8.0)) calling onTapDown callback.'));
    expect(log[1], equalsIgnoringHashCodes('TapGestureRecognizer#00000(state: ready, won arena, finalPosition: Offset(12.0, 8.0), sent tap down) calling onTapUp callback.'));
    expect(log[2], equalsIgnoringHashCodes('TapGestureRecognizer#00000(state: ready, won arena, finalPosition: Offset(12.0, 8.0), sent tap down) calling onTap callback.'));
    log.clear();

    tap.dispose();
    expect(log, isEmpty);

    debugPrintRecognizerCallbacksTrace = false;
    debugPrint = oldCallback;
  });

  testWidgets('debugPrintGestureArenaDiagnostics and debugPrintRecognizerCallbacksTrace', (WidgetTester tester) {
    PointerEvent event;
    debugPrintGestureArenaDiagnostics = true;
    debugPrintRecognizerCallbacksTrace = true;
    final DebugPrintCallback oldCallback = debugPrint;
    final List<String> log = <String>[];
    debugPrint = (String s, { int wrapWidth }) { log.add(s); };

    final TapGestureRecognizer tap = new TapGestureRecognizer()
      ..onTapDown = (TapDownDetails details) { }
      ..onTapUp = (TapUpDetails details) { }
      ..onTap = () { }
      ..onTapCancel = () { };
    expect(log, isEmpty);

    event = const PointerDownEvent(pointer: 1, position: const Offset(10.0, 10.0));
    tap.addPointer(event);
    expect(log, hasLength(2));
    expect(log[0], equalsIgnoringHashCodes('Gesture arena 1    ❙ ★ Opening new gesture arena.'));
    expect(log[1], equalsIgnoringHashCodes('Gesture arena 1    ❙ Adding: TapGestureRecognizer#00000(state: ready)'));
    log.clear();

    GestureBinding.instance.gestureArena.close(1);
    expect(log, hasLength(1));
    expect(log[0], equalsIgnoringHashCodes('Gesture arena 1    ❙ Closing with 1 member.'));
    log.clear();

    GestureBinding.instance.pointerRouter.route(event);
    expect(log, isEmpty);

    event = const PointerUpEvent(pointer: 1, position: const Offset(12.0, 8.0));
    GestureBinding.instance.pointerRouter.route(event);
    expect(log, isEmpty);

    GestureBinding.instance.gestureArena.sweep(1);
    expect(log, hasLength(5));
    expect(log[0], equalsIgnoringHashCodes('Gesture arena 1    ❙ Sweeping with 1 member.'));
    expect(log[1], equalsIgnoringHashCodes('Gesture arena 1    ❙ Winner: TapGestureRecognizer#00000(state: ready, finalPosition: Offset(12.0, 8.0))'));
    expect(log[2], equalsIgnoringHashCodes('                   ❙ TapGestureRecognizer#00000(state: ready, finalPosition: Offset(12.0, 8.0)) calling onTapDown callback.'));
    expect(log[3], equalsIgnoringHashCodes('                   ❙ TapGestureRecognizer#00000(state: ready, won arena, finalPosition: Offset(12.0, 8.0), sent tap down) calling onTapUp callback.'));
    expect(log[4], equalsIgnoringHashCodes('                   ❙ TapGestureRecognizer#00000(state: ready, won arena, finalPosition: Offset(12.0, 8.0), sent tap down) calling onTap callback.'));
    log.clear();

    tap.dispose();
    expect(log, isEmpty);

    debugPrintGestureArenaDiagnostics = false;
    debugPrintRecognizerCallbacksTrace = false;
    debugPrint = oldCallback;
  });

  test('TapGestureRecognizer _sentTapDown toString', () {
    final TapGestureRecognizer tap = new TapGestureRecognizer();
    expect(tap.toString(), equalsIgnoringHashCodes('TapGestureRecognizer#00000(state: ready)'));
    const PointerEvent event = const PointerDownEvent(pointer: 1, position: const Offset(10.0, 10.0));
    tap.addPointer(event);
    tap.didExceedDeadline();
    expect(tap.toString(), equalsIgnoringHashCodes('TapGestureRecognizer#00000(state: possible, sent tap down)'));
  });
}
