import 'package:flutter/material.dart';
import 'conversation_page.dart'; // Import the conversation page

class MessagesPage extends StatelessWidget {
  final List<Map<String, String>> conversations = [
    {
      "title": "UnoMate Dev Team",
      "subtitle": "Welcome to UnoMate! If you have any questions, feel free to ask."
    },
    {
      "title": "Dorms",
      "subtitle": "Hi there! We have new accommodations available. Check them out!"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/business_signup.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        title: Text(
                          conversations[index]['title']!,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        subtitle: Text(conversations[index]['subtitle']!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConversationPage(
                                title: conversations[index]['title']!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
