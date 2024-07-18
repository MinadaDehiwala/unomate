import 'package:flutter/material.dart';
import 'map_screen.dart'; // Import the map screen

class StuHomePage extends StatelessWidget {
  const StuHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unomate'),
        backgroundColor: Colors.blue,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by university, city, or property',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Popular hostels near your uni',
                style: TextStyle(fontSize: 18, color: Colors.purple),
              ),
            ),
            HostelCard(),
            HostelCard(),
            HostelCard(),
            HostelCard(),
            HostelCard(),
            HostelCard(),
            HostelCard(),
            HostelCard(),
            HostelCard(),
            HostelCard(),
          ],
        ),
      ),
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
      ),
    );
  }
}

class HostelCard extends StatelessWidget {
  const HostelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/default_hostel.jpg', // Placeholder image
                height: 200, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hostel at Galle Face',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text('LKR 6000'),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const Icon(Icons.star, color: Colors.amber),
                      const Icon(Icons.star, color: Colors.amber),
                      const Icon(Icons.star, color: Colors.amber),
                      const Icon(Icons.star, color: Colors.amber),
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
