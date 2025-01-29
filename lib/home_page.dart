import 'package:flutter/material.dart';
import 'package:hicodechildrights/color.dart';
import 'package:hicodechildrights/puzzle_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        foregroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
          ),
        ),
      ),
      drawer: const Drawer(), // Menü simgesi için bir çekmece
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                // Tahmin Kartı
                _buildGridButton(
                  context,
                  color: Colors.pink[100]!,
                  icon: Icons.question_mark,
                  label: 'Tahmin Kartı',
                  onTap: () {
                    print("Tahmin Kartı butonuna tıklandı");
                  },
                  imageUrl: 'lib/images/zurafa.png',
                ),
                // Puzzle
                _buildGridButton(
                  context,
                  color: Colors.purple[100]!,
                  icon: Icons.extension,
                  label: 'Puzzle',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SlidePuzzle()),
                    );
                  },
                  imageUrl: 'lib/images/flamingo.png',
                ),
                // Resimler Arasındaki Fark
                _buildGridButton(
                  context,
                  color: Colors.grey[300]!,
                  icon: Icons.build,
                  label: 'Resimler Arasındaki Fark',
                  onTap: () {
                    print("Resimler Arasındaki Fark butonuna tıklandı");
                  },
                  imageUrl: 'lib/images/yilan.png',
                ),
                // Eşleştirme
                _buildGridButton(
                  context,
                  color: Colors.green[100]!,
                  icon: Icons.music_note,
                  label: 'Eşleştirme',
                  onTap: () {
                    print("Eşleştirme butonuna tıklandı");
                  },
                  imageUrl: 'lib/images/kus.png',
                ),
              ],
            ),
          ),
          // Ekranın alt sağ köşesine fotoğraf eklemek için Positioned widget'ı
          Positioned(
            bottom: 16,
            right: 16,
            child: Image.asset(
              'lib/images/kucukkiz.png',
              width: 200,
              height: 250,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Üst taraf: İkon ve yazı
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 40,
                      color: AppColors.purple,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Alt taraf: Küçük fotoğraf
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: Align(
                  alignment: Alignment.centerRight, // Sağ hizalama için ayar
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 45, // Genişlik ayarı
                    height: 45, // Yükseklik ayarı
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
