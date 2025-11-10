// 📄 daftar_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Watch List'), centerTitle: true),
        backgroundColor: Colors.black,
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
                      title: item,
                      date: '10 November 2025',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Kamu memilih $item')),
                        );
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
