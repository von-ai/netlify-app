import 'package:flutter/material.dart';
import 'package:project_mobile/widgets/detail_header.dart';
import 'package:project_mobile/widgets/detail_info.dart';
import 'package:provider/provider.dart';
import '../providers/detail_provider.dart';

class DetailPage extends StatelessWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailProvider()..loadDetail(id),
      child: Scaffold(
        appBar: AppBar(title: const Text("Detail Acaramu"), centerTitle: true),
        body: Consumer<DetailProvider>(
          builder: (context, state, _) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.item == null) {
              return const Center(child: Text("Data tidak ditemukan…"));
            }

            final item = state.item!;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DetailHeader(title: item.title, type: item.type),
                const SizedBox(height: 16),
                DetailInfo(
                  genre: item.genre,
                  date: item.date,
                  isWatched: item.isWatched,
                  episodes: item.episodes,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
