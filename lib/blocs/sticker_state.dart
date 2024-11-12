import '../models/sticker.dart';

abstract class StickerState {}

class PrintInitial extends StickerState {}

class StickerCreated extends StickerState {
  final Sticker sticker;

  StickerCreated(this.sticker);
}

class StickerPrinted extends StickerState {}

class StickerError extends StickerState {
  final String message;

  StickerError(this.message);
}
