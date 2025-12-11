import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:project_mobile/models/watch_item.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/services/notification_service.dart';
import 'package:project_mobile/providers/daftar_provider.dart';

class AddListPage extends StatefulWidget {
  final WatchItem? itemToEdit;

  const AddListPage({super.key, this.itemToEdit});

  @override
  State<AddListPage> createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _title;
  late TextEditingController _type;
  late TextEditingController _genre;
  late TextEditingController _episodes;

  DateTime? selectedDate;
  final dateFormat = DateFormat('yyyy-MM-dd');
  final NotificationService _notifService = NotificationService();

  @override
  void initState() {
    super.initState();

    _title = TextEditingController();
    _type = TextEditingController();
    _genre = TextEditingController();
    _episodes = TextEditingController();

    if (widget.itemToEdit != null) {
      final item = widget.itemToEdit!;
      
      _title.text = item.title;
      _type.text = item.type;
      _genre.text = item.genre;
      
      if (item.episodes != null) {
        _episodes.text = item.episodes.toString();
      }

      try {
        selectedDate = dateFormat.parse(item.date);
      } catch (e) {
        selectedDate = DateTime.now();
      }
    }
  }

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
    final isEditMode = widget.itemToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Jadwal" : "Tambah Watch List"),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (isEditMode) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Mengubah tanggal akan menjadwalkan ulang notifikasi.",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
          _cardContainer([_form()]),
          const SizedBox(height: 24),
          _submitButton(isEditMode),
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
              if (v == null || v.isEmpty) return null;
              final value = int.tryParse(v);
              if (value == null) return "Episode harus berupa angka";
              if (value <= 0) return "Episode harus lebih dari 0";
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
          ? (v) => (v == null || v.isEmpty) ? "$label tidak boleh kosong" : null
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

  Widget _submitButton(bool isEditMode) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 4,
        ),
        onPressed: saveData,
        child: Text(
          isEditMode ? "Simpan Perubahan" : "Simpan Jadwal",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final initial = selectedDate ?? now;

    final result = await showDatePicker(
      context: context,
      initialDate: initial,
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

    final isEditMode = widget.itemToEdit != null;
    final item = WatchItem(
      id: isEditMode ? widget.itemToEdit!.id : '',
      title: _title.text,
      type: _type.text,
      genre: _genre.text,
      date: dateFormat.format(selectedDate!),
      isWatched: isEditMode ? widget.itemToEdit!.isWatched : false,
      currentEpisode: isEditMode ? widget.itemToEdit!.currentEpisode : 0,
      episodes: _episodes.text.isEmpty ? null : int.tryParse(_episodes.text),
    );

    try {
      if (isEditMode) {
        await context.read<DaftarProvider>().updateItem(item);
      } else {
        await context.read<DaftarProvider>().addItem(item);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e")),
      );
      return;
    }

    int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    
    final now = DateTime.now();
    DateTime scheduleTime;

    bool isToday =
        selectedDate!.year == now.year &&
        selectedDate!.month == now.month &&
        selectedDate!.day == now.day;
        
    if (isToday) {
      // Demo: Jika hari ini, bunyi 10 detik lagi
      scheduleTime = now.add(const Duration(seconds: 10));
    } else {
      // Jika tidak notifikasi muncul jam 9 pagi
      scheduleTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        9, 0, 0,
      );
    }

    if (scheduleTime.isAfter(now) && hasPermission) {
      await _notifService.scheduleNotification(
        id: notificationId,
        title: isEditMode ? "Jadwal Diubah! 🎬" : "Waktunya Nonton! 🎬",
        body: "Jangan lupa nonton ${_title.text} pada jadwal barumu.",
        scheduledTime: scheduleTime,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditMode 
            ? "Jadwal diperbarui! Notif: ${DateFormat('dd MMM HH:mm').format(scheduleTime)}"
            : "Disimpan! Notif: ${DateFormat('dd MMM HH:mm').format(scheduleTime)}",
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.pop(context);
  }
}