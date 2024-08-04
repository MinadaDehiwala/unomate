import 'dart:math';
import 'package:flutter/material.dart';
import 'profile_page.dart'; // Import the profile page
import 'messages_page.dart'; // Import the messages page
import 'map_screen.dart'; // Import the map screen
import 'group_page.dart'; // Import the group page
import 'fav_page.dart'; // Import the favorites page

class StuHomePage extends StatefulWidget {
  const StuHomePage({super.key});

  @override
  _StuHomePageState createState() => _StuHomePageState();
}

class _StuHomePageState extends State<StuHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    GroupPage(), // Navigate to GroupPage
    FavPage(), // Navigate to FavPage
    MessagesPage(), // Use the MessagesPage here
    ProfilePage(), // Use the ProfilePage here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unomate', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: Colors.blue),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.blue),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail, color: Colors.blue),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.blue),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  HomeContent({super.key});  // Remove const

  final List<String> hostelImages = [
    'assets/images/hostel1.png',
    'assets/images/hostel2.png',
    'assets/images/hostel3.png',
    'assets/images/hostel4.png',
    'assets/images/hostel5.png',
    'assets/images/hostel6.png',
    'assets/images/hostel7.png',
    'assets/images/hostel8.png',
    'assets/images/hostel9.png',
    'assets/images/hostel10.png',
  ];

  final List<String> hostelNames = [
    'Sunrise Hostel',
    'City Center Hostel',
    'Green Valley Hostel',
    'Ocean View Hostel',
    'Mountain Peak Hostel',
    'Riverside Hostel',
    'Central Park Hostel',
    'Downtown Hostel',
    'Lakeside Hostel',
    'Hilltop Hostel',
  ];

  int _generateRandomPrice() {
    final random = Random();
    return 15000 + random.nextInt(15000);
  }

  int _generateRandomStars() {
    final random = Random();
    return 1 + random.nextInt(5);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by university, city, or property',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Popular hostels near your uni',
              style: TextStyle(fontSize: 18, color: Colors.purple),
            ),
          ),
          for (int i = 0; i < hostelImages.length; i++)
            HostelCard(
              imagePath: hostelImages[i],
              name: hostelNames[i],
              price: _generateRandomPrice(),
              stars: _generateRandomStars(),
            ),
        ],
      ),
    );
  }
}

class HostelCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final int price;
  final int stars;

  const HostelCard({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.stars,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, height: 200, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('LKR $price per month'),
                  Row(
                    children: [
                      for (int i = 0; i < stars; i++)
                        const Icon(Icons.star, color: Colors.amber),
                      for (int i = stars; i < 5; i++)
                        const Icon(Icons.star_border, color: Colors.amber),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MapScreen()),
                          );
                        },
                        child: const Text('Map'),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.phone),
                        onPressed: () {
                          // Implement call functionality
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () {
                          // Implement favorite functionality
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
