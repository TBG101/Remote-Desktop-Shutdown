import 'dart:typed_data';

import 'package:msgpack_dart/msgpack_dart.dart';

enum Command {
  shutdown(0x01),
  shutdownAll(0x02),
  mouseMove(0x03),
  mouseClick(0x04),
  mouseScroll(0x05),
  volume(0x06),
  media(0x07);

  const Command(this.id);

  final int id;
}

enum MouseButton {
  left(0x00),
  right(0x01),
  middle(0x02);

  const MouseButton(this.id);

  final int id;
}

enum ClickAction {
  click(0x00),
  press(0x01),
  release(0x02);

  const ClickAction(this.id);

  final int id;
}

enum VolumeAction {
  mute(0x00),
  down(0x01),
  up(0x02);

  const VolumeAction(this.id);

  final int id;
}

enum MediaAction {
  stop(0x00),
  play(0x01),
  next(0x02),
  previous(0x03);

  const MediaAction(this.id);

  final int id;
}

class Protocol {
  static Uint8List encode(
    Command command, [
    Map<String, dynamic> payload = const {},
  ]) {
    final encodedPayload = serialize(payload);

    return Uint8List(1 + encodedPayload.length)
      ..[0] = command.id
      ..setRange(1, 1 + encodedPayload.length, encodedPayload);
  }

  static Map<String, dynamic> mouseMove(int dx, int dy) => {
        'dx': dx,
        'dy': dy,
      };

  static Map<String, dynamic> mouseClick(
    MouseButton button,
    ClickAction action,
  ) =>
      {
        'button': button.id,
        'action': action.id,
      };

  static Map<String, dynamic> mouseScroll({
    required int amount,
    required int axis,
  }) =>
      {
        'amount': amount,
        'axis': axis,
      };

  static Map<String, dynamic> volume(VolumeAction action) => {
        'action': action.id,
      };

  static Map<String, dynamic> media(MediaAction action) => {
        'action': action.id,
      };
}
