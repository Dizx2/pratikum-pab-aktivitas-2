import 'package:flutter/material.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum PAB - Movie App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE50914),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const DetailScreen(),
    const Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFE50914),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_max), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: "Movie"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

// ==========================================
// HALAMAN 1: HOME (GRID POSTER)
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PRAKTIKUM PAB", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65, // Disesuaikan agar kotak poster proporsional
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailScreen())),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[900], // Background pengganti jika gambar gagal load
                image: DecorationImage(
                  image: NetworkImage('https://picsum.photos/seed/${index + 100}/400/600'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// HALAMAN 2: DETAIL (FIXED SCROLL & PLAY)
// ==========================================
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PRAKTIKUM PAB", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      // INI KUNCINYA: Tambahkan SingleChildScrollView agar bisa di-scroll ke bawah
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Poster Besar (Ukuran disesuaikan agar tidak memakan seluruh layar)
              Container(
                height: 400, // Ukuran dikurangi sedikit agar Play terlihat lebih cepat
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/seed/movie_hd/600/900'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              
              const Text(
                "Interstellar: Redux", 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sci-Fi • Adventure • 2h 49m", 
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              
              const SizedBox(height: 30),

              // Tombol Play Lonjong (Stadium)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56), // Lebar mengikuti container
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Memutar Film...")),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 30),
                label: const Text("Play", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              
              // Spasi tambahan di bawah agar scroll terasa nyaman
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
