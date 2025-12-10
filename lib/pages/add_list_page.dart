import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/watch_item.dart';
import 'package:project_mobile/core/theme/colors.dart';
import '../services/notification_service.dart';
import '../providers/daftar_provider.dart';

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
  final _episodes = TextEditingController();

  DateTime? selectedDate;
  final dateFormat = DateFormat('yyyy-MM-dd');

  final NotificationService _notifService = NotificationService();

  @override
  void dispose() {
    _title.dispose();
    _type.dispose();
    _genre.dispose();
    _episodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Watch List"),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _cardContainer([_form()]),
          const SizedBox(height: 24),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _field(_title, "Judul", icon: Icons.movie_creation_outlined),
          const SizedBox(height: 16),

          _field(_type, "Tipe (Anime / Movie / Drama)", icon: Icons.category),
          const SizedBox(height: 16),

          _field(_genre, "Genre", icon: Icons.local_fire_department),
          const SizedBox(height: 16),

          // DATE PICKER
          GestureDetector(
            onTap: pickDate,
            child: AbsorbPointer(
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  label: "Tonton pada tanggal",
                  icon: Icons.calendar_month,
                ),
                controller: TextEditingController(
                  text: selectedDate == null
                      ? ""
                      : dateFormat.format(selectedDate!),
                ),
                validator: (v) =>
                    selectedDate == null ? "Tanggal wajib diisi" : null,
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _episodes,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration(
              label: "Total Episode (opsional)",
              icon: Icons.numbers,
            ),
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.isEmpty) return null; // opsional

              final value = int.tryParse(v);

              if (value == null) {
                return "Episode harus berupa angka";
              }
              if (value <= 0) {
                return "Episode harus lebih dari 0";
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool requiredField = true,
    required IconData icon,
  }) {
    return TextFormField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label: label, icon: icon),
      validator: requiredField
          ? (v) => v!.isEmpty ? "$label tidak boleh kosong" : null
          : null,
    );
  }

  Widget _cardContainer(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 4,
      ),
      onPressed: saveData,
      child: const Text(
        "Simpan",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (result != null) {
      setState(() => selectedDate = result);
    }
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) return;

    bool hasPermission = await _notifService.requestPermission();
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin ditolak. Alarm tidak akan bunyi.")),
      );
    }

    final item = WatchItem(
      title: _title.text,
      type: _type.text,
      genre: _genre.text,
      date: dateFormat.format(selectedDate!),
      isWatched: false,
      episodes: _episodes.text.isEmpty ? null : int.tryParse(_episodes.text),
      currentEpisode: 0,
    );

    int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(
      100000,
    );
    await context.read<DaftarProvider>().addItem(item);
    final now = DateTime.now();
    DateTime scheduleTime;

    bool isToday =
        selectedDate!.year == now.year &&
        selectedDate!.month == now.month &&
        selectedDate!.day == now.day;
    //set 10 second untuk demo
    if (isToday) {
      scheduleTime = now.add(const Duration(seconds: 10));
    } else {
      scheduleTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        9,
        0,
        0,
      );
    }

    if (scheduleTime.isAfter(now) && hasPermission) {
      await _notifService.scheduleNotification(
        id: notificationId,
        title: "Waktunya Nonton! 🎬",
        body: "Jangan lupa nonton ${_title.text} sesuai jadwalmu.",
        scheduledTime: scheduleTime,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Disimpan! FPengingat set: ${DateFormat('dd MMM HH:mm').format(scheduleTime)}",
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.pop(context);
  }
}
