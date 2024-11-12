import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/print_bloc.dart';
import '../blocs/sticker_event.dart';
import '../blocs/sticker_state.dart';

class PrintPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();

  PrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Создание стикеров')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            TextField(
              controller: barcodeController,
              decoration: const InputDecoration(labelText: 'Штрих-код'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                final barcodeValue = barcodeController.text;

                if (title.isNotEmpty &&
                    description.isNotEmpty &&
                    barcodeValue.isNotEmpty) {
                  context.read<PrintBloc>().add(
                      CreateStickerEvent(title, description, barcodeValue));
                }
              },
              child: const Text('Создать стикер'),
            ),
            const SizedBox(height: 20),
            BlocListener<PrintBloc, StickerState>(
              listener: (context, state) {
                if (state is StickerCreated) {
                  context
                      .read<PrintBloc>()
                      .add(PrintStickerEvent(state.sticker));
                } else if (state is StickerError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
