import '../models/sticker.dart';

abstract class StickerEvent {}

class CreateStickerEvent extends StickerEvent {
  final String title;
  final String description;
  final String barcodeValue;

  CreateStickerEvent(this.title, this.description, this.barcodeValue);
}

class PrintStickerEvent extends StickerEvent {
  final Sticker sticker;

  PrintStickerEvent(this.sticker);
}

