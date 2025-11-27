import 'package:flutter/material.dart';

class PhotoGuidePage extends StatelessWidget {
  const PhotoGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Poradnik robienia zdjęć'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pszenica'),
              Tab(text: 'Ziemniak'),
              Tab(text: 'Rzepak'),
              Tab(text: 'Pomidor'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _CropGuide(cropName: 'Pszenica', folderName: 'Pszenica'),
            _CropGuide(cropName: 'Ziemniak', folderName: 'Ziemniak'),
            _CropGuide(cropName: 'Rzepak', folderName: 'Rzepak'),
            _CropGuide(cropName: 'Pomidor', folderName: 'Pomidor'),
          ],
        ),
      ),
    );
  }
}

class _CropGuide extends StatelessWidget {
  final String cropName;
  final String folderName;

  const _CropGuide({required this.cropName, required this.folderName});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Jak zrobić dobre zdjęcie - $cropName',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const Text(
          'Aby uzyskać najlepszą diagnozę, upewnij się, że zdjęcie jest ostre, dobrze oświetlone i przedstawia chorobę z bliska. Poniżej znajdują się przykłady.',
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: 5,
          itemBuilder: (context, index) {
            final imageIndex = index + 1;
            final assetPath = 'assets/images/guide/$folderName/$imageIndex.jpg';
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Przykład $imageIndex',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
