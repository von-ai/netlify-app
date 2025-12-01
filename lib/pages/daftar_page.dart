import 'package:flutter/material.dart';
import 'package:project_mobile/pages/detail_page.dart';
import 'package:provider/provider.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/providers/navbar_provider.dart';
import 'package:project_mobile/providers/daftar_provider.dart';
import 'package:project_mobile/widgets/card_list.dart';
import 'package:project_mobile/widgets/searchbar.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DaftarProvider>(context);
    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => navBarProvider.setIndex(0),
          ),
          title: const Text('Watch List'),
          centerTitle: true,
        ),
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBarWidget(
                controller: searchController,
                onChanged: provider.search,
                hintText: 'Cari anime atau acara...',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = provider.filteredItems[index];

                    return CardList(
                      title: item.title,
                      genre: item.genre,
                      date: item.date,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(id: item.id!),
                          ),
                        );
                      },
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Hapus item ini?"),
                              content: Text(
                                "Kamu yakin mau menghapus \"${item.title}\" dari daftar?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Hapus",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          provider.removeItem(item);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
