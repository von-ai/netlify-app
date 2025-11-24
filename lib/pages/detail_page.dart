import 'package:flutter/material.dart';
import 'package:project_mobile/widgets/detail_header.dart';
import 'package:project_mobile/widgets/detail_info.dart';
import 'package:provider/provider.dart';
import '../providers/detail_provider.dart';
import '../core/theme/colors.dart';

class DetailPage extends StatelessWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailProvider()..loadDetail(id),
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          title: const Text("Detail Acaramu"),
          centerTitle: true,
          backgroundColor: AppColors.background,
          elevation: 0,
          foregroundColor: AppColors.textDark,
        ),

        body: Consumer<DetailProvider>(
          builder: (context, state, _) {
            if (state.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state.item == null) {
              return const Center(
                child: Text(
                  "Data tidak ditemukan…",
                  style: TextStyle(color: AppColors.textDark),
                ),
              );
            }

            final item = state.item!;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DetailHeader(title: item.title, type: item.type),

                const SizedBox(height: 20),

                // --- Card wrapper agar lebih rapi dan elegan ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      DetailInfo(
                        genre: item.genre,
                        date: item.date,
                        isWatched: item.isWatched,
                        episodes: item.episodes,
                      ),

                      const SizedBox(height: 20),

                      // Divider halus
                      Divider(
                        color: Colors.white.withOpacity(0.1),
                        thickness: 1,
                        height: 24,
                      ),

                      if (item.episodes != null) ...[
                        Text(
                          "Progress Episode",
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // --- Episode Counter Stylish ---
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  final ep = item.currentEpisode > 0
                                      ? item.currentEpisode - 1
                                      : 0;

                                  context.read<DetailProvider>().updateEpisode(
                                    id,
                                    ep,
                                  );
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  "${item.currentEpisode} / ${item.episodes}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  final ep =
                                      item.currentEpisode < item.episodes!
                                      ? item.currentEpisode + 1
                                      : item.currentEpisode;

                                  context.read<DetailProvider>().updateEpisode(
                                    id,
                                    ep,
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // --- Button Modern ---
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            await context
                                .read<DetailProvider>()
                                .updateWatchedStatus(id);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Yey kamu udah nonton!"),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Text(
                            item.isWatched
                                ? "Sudah Ditonton"
                                : "Tandai Sudah Ditonton",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
