import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/watch_item.dart';
import '../providers/watchlist_providers.dart';
import 'package:project_mobile/core/theme/colors.dart';

class AddListPage extends StatefulWidget {
  const AddListPage({super.key});

  @override
  State<AddListPage> createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _type = TextEditingController();
  final _genre = TextEditingController();
  final _date = TextEditingController();
  final _episodes = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _type.dispose();
    _genre.dispose();
    _date.dispose();
    _episodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Watch List"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field(_title, "Title"),
              const SizedBox(height: 16),
              _field(_type, "Type"),
              const SizedBox(height: 16),
              _field(_genre, "Genre"),
              const SizedBox(height: 16),
              _field(_date, "When you want to watch"),
              const SizedBox(height: 16),
              _field(_episodes, "Episodes", requiredField: false), // optional
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textDark,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newItem = WatchItem(
                      title: _title.text,
                      type: _type.text,
                      genre: _genre.text,
                      date: _date.text,
                      isWatched: false,
                      episodes: _episodes.text.isEmpty
                          ? null
                          : int.tryParse(_episodes.text),
                    );

                    await context.read<WatchlistProvider>().add(newItem);

                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool requiredField = true,
  }) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: requiredField
          ? (v) => v!.isEmpty ? "$label tidak boleh kosong" : null
          : null,
    );
  }
}
