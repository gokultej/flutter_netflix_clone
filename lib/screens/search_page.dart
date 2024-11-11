import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_screen.dart'; // Import the DetailScreen

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> searchResults = [];
  bool isLoading = false;
  // ignore: non_constant_identifier_names
  String search_term = ''; // Declare search_term

  // Function to search for movies based on query
  Future<void> searchMovies(String query) async {
    setState(() {
      search_term = query; // Update search_term with the user query
    });

    if (search_term.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.tvmaze.com/search/shows?q=$search_term')); // Use search_term in the URL

    if (response.statusCode == 200) {
      final List<dynamic> fetchedData = json.decode(response.body);
      setState(() {
        searchResults = fetchedData;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontFamily: 'SharpSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pop(context); // Close the search screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'SharpSans',
              ),
              cursorColor: Colors.red,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[850],
                hintText: 'Search for a movie...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'SharpSans',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.red),
              ),
              onSubmitted: (query) {
                searchMovies(query); // Trigger search on submit
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.red))
                : Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Display 2 items per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.6, // Aspect ratio for each box
                      ),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final show = searchResults[index]['show'];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the DetailScreen and pass the movie data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(show: show),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Show Thumbnail
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8)),
                                  child: Image.network(
                                    show['image'] != null
                                        ? show['image']['medium']
                                        : 'https://via.placeholder.com/150', // Placeholder image
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: double.infinity,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Show Title
                                      Text(
                                        show['name'] ?? 'No title',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'SharpSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      // Show Summary
                                      Text(
                                        show['summary'] != null
                                            ? show['summary'].replaceAll(
                                                RegExp(r'<[^>]*>'), '')
                                            : 'No summary available.',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: 'SharpSans',
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
