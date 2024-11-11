import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final dynamic show;

  const DetailScreen({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          show['name'] ?? 'Movie Details',
          style: const TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontFamily: 'SharpSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  show['image'] != null
                      ? show['image']['original']
                      : 'https://via.placeholder.com/400', // Placeholder image
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              // Show Title
              Text(
                show['name'] ?? 'No title',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'SharpSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Show Summary
              Text(
                show['summary'] != null
                    ? show['summary'].replaceAll(RegExp(r'<[^>]*>'), '')
                    : 'No summary available.',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'SharpSans',
                ),
              ),
              const SizedBox(height: 16),
              // Show Genres
              if (show['genres'] != null)
                Text(
                  'Genres: ${show['genres'].join(', ')}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'SharpSans',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
