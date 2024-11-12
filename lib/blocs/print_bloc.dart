import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import '../models/sticker.dart';
import 'sticker_event.dart';
import 'sticker_state.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:barcode/barcode.dart';

class PrintBloc extends Bloc<StickerEvent, StickerState> {
  PrintBloc() : super(PrintInitial()) {
    // Регистрация обработчиков событий
    on<CreateStickerEvent>((event, emit) async {
      try {
        final sticker = Sticker(
          title: event.title,
          description: event.description,
          barcodeValue: event.barcodeValue,
        );
        emit(StickerCreated(sticker));
      } catch (e) {
        emit(StickerError("Ошибка при создании стикера"));
      }
    });

    on<PrintStickerEvent>((event, emit) async {
      try {
        await _printSticker(event.sticker);
        emit(StickerPrinted());
      } catch (e) {
        emit(StickerError("Ошибка при печати стикера"));
      }
    });
  }

  Future<void> _printSticker(Sticker sticker) async {
    final pdf = pw.Document();

    // Генерация штрих-кода
    final barcode = Barcode.code128(); // Выбор типа штрих-кода
    final barcodeSvg =
        barcode.toSvg(sticker.barcodeValue, width: 200, height: 80);

    // Преобразование SVG-строки в Uint8List
    final svgBytes = Uint8List.fromList(utf8.encode(barcodeSvg));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              if (sticker.title != null)
                pw.Text(sticker.title!,
                    style: const pw.TextStyle(fontSize: 24)),
              if (sticker.description != null)
                pw.Text(sticker.description!,
                    style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              // Отображение штрих-кода как изображения
              pw.Image(pw.MemoryImage(svgBytes)),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
