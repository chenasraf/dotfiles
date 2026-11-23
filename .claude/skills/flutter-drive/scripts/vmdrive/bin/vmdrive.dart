// Drives a running debug/profile Flutter app through its VM service: pointer
// events go straight into the app's GestureBinding, so the OS mouse and
// keyboard focus are never touched.
//
//   vmdrive <vm-service-uri> size
//   vmdrive <vm-service-uri> tap <x> <y>
//   vmdrive <vm-service-uri> longpress <x> <y>
//   vmdrive <vm-service-uri> drag <x1> <y1> <x2> <y2>
//   vmdrive <vm-service-uri> type <text>
//   vmdrive <vm-service-uri> eval <library-uri> <expression>
//
// Coordinates are logical pixels of the app's first view.
import 'dart:io';

import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

const _gestures = 'package:flutter/src/gestures/binding.dart';
const _editable = 'package:flutter/src/widgets/editable_text.dart';

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('usage: vmdrive <vm-service-uri> <command> [args]');
    exit(64);
  }
  final service = await vmServiceConnectUri(_wsUri(args[0]));
  try {
    final vm = await service.getVM();
    final isolateRef = vm.isolates!.firstWhere(
      (i) => i.name?.contains('main') ?? false,
      orElse: () => vm.isolates!.first,
    );
    final isolate = await service.getIsolate(isolateRef.id!);

    Future<String> eval(String libraryUri, String expr) async {
      final lib = isolate.libraries!.firstWhere((l) => l.uri == libraryUri);
      final r = await service.evaluate(isolateRef.id!, lib.id!, expr);
      if (r is InstanceRef) return r.valueAsString ?? r.classRef?.name ?? '?';
      if (r is ErrorRef) throw StateError(r.message ?? 'evaluation failed');
      return r.toString();
    }

    // Evaluation runs wherever the isolate happens to be — possibly in the
    // middle of a frame. Dispatching there throws "Build scheduled during
    // frame" and leaves a recognizer holding a pointer that never lifts, so
    // every event is queued on a timer and lands between frames like real
    // input.
    Future<void> pointer(List<(int delayMs, String event)> events) async {
      final timers = [
        for (final (delay, event) in events)
          'Timer(const Duration(milliseconds: $delay), () => '
              'GestureBinding.instance.handlePointerEvent($event))',
      ];
      await eval(_gestures, '[${timers.join(', ')}].length.toString()');
      final last = events.map((e) => e.$1).reduce((a, b) => a > b ? a : b);
      await Future<void>.delayed(Duration(milliseconds: last + 50));
    }

    final id = DateTime.now().millisecondsSinceEpoch % 1000000 + 1000;
    String ev(String type, double x, double y, [String extra = '']) =>
        '$type(pointer: $id, kind: PointerDeviceKind.touch, '
        'position: Offset($x, $y)$extra)';
    double n(int i) => double.parse(args[i]);

    switch (args[1]) {
      case 'size':
        print(
          await eval(
            _gestures,
            '(PlatformDispatcher.instance.views.first.physicalSize / '
            'PlatformDispatcher.instance.views.first.devicePixelRatio)'
            '.toString()',
          ),
        );
      case 'tap':
        final (x, y) = (n(2), n(3));
        await pointer([
          (0, ev('PointerDownEvent', x, y)),
          (80, ev('PointerUpEvent', x, y)),
        ]);
      case 'longpress':
        final (x, y) = (n(2), n(3));
        await pointer([
          (0, ev('PointerDownEvent', x, y)),
          (800, ev('PointerUpEvent', x, y)),
        ]);
      case 'drag':
        final (x1, y1, x2, y2) = (n(2), n(3), n(4), n(5));
        const steps = 12;
        final events = <(int, String)>[(0, ev('PointerDownEvent', x1, y1))];
        var px = x1, py = y1;
        for (var s = 1; s <= steps; s++) {
          final x = x1 + (x2 - x1) * s / steps;
          final y = y1 + (y2 - y1) * s / steps;
          events.add((
            s * 16,
            ev('PointerMoveEvent', x, y, ', delta: Offset(${x - px}, ${y - py})'),
          ));
          px = x;
          py = y;
        }
        events.add(((steps + 1) * 16, ev('PointerUpEvent', x2, y2)));
        await pointer(events);
      case 'type':
        // Replaces the text of whichever field has focus, as if typed.
        final text = args.sublist(2).join(' ');
        final quoted = "'${text.replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll(r'$', r'\$')}'";
        print(
          await eval(
            _editable,
            '[Timer.run(() { final s = FocusManager.instance.primaryFocus'
            '?.context?.findAncestorStateOfType<EditableTextState>(); '
            'if (s == null) { debugPrint("vmdrive: no focused text field"); '
            'return; } s.userUpdateTextEditingValue(TextEditingValue('
            'text: $quoted, selection: TextSelection.collapsed('
            'offset: $quoted.length)), SelectionChangedCause.keyboard); })]'
            '.length.toString()',
          ),
        );
      case 'eval':
        print(await eval(args[2], args[3]));
      default:
        stderr.writeln('unknown command ${args[1]}');
        exit(64);
    }
  } finally {
    await service.dispose();
  }
}

/// `http://127.0.0.1:PORT/TOKEN=/` → `ws://127.0.0.1:PORT/TOKEN=/ws`.
String _wsUri(String uri) {
  final u = Uri.parse(uri);
  if (u.scheme.startsWith('ws')) return uri;
  final path = u.path.endsWith('/') ? u.path : '${u.path}/';
  return u.replace(scheme: 'ws', path: '${path}ws').toString();
}
