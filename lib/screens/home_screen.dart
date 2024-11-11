import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'search_page.dart'; // Import the SearchPage
import 'detail_screen.dart'; // Import the DetailScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> shows = [];
  bool isLoading = true;
  bool hasMore = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchShows();
  }

  Future<void> fetchShows() async {
    if (!hasMore) return; // Avoid multiple requests if all data is loaded

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.tvmaze.com/search/shows?q=all&page=$currentPage'));

    if (response.statusCode == 200) {
      final List<dynamic> fetchedData = json.decode(response.body);

      if (fetchedData.isEmpty) {
        setState(() {
          hasMore = false;
        });
      } else {
        setState(() {
          shows.addAll(fetchedData);
          currentPage++;
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Make the app bar background transparent
        elevation: 0, // Remove shadow of the app bar
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/netflix.png', // Replace with your own path to the Netflix logo image
            fit: BoxFit.contain,
            height: 30, // Adjust the height of the logo as needed
          ),
        ),
        title: const Text(
          'Netflix',
          style: TextStyle(
            color: Colors.red,
            fontSize: 32,
            fontFamily: 'SharpSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading && shows.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  // When scrolled to the bottom, fetch more data
                  fetchShows();
                }
                return false;
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Display 2 items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6, // Aspect ratio for each box
                ),
                itemCount: shows.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == shows.length) {
                    // Show loading spinner at the end of the list when fetching more data
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.red));
                  }

                  final show = shows[index]['show'];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the details screen and pass the selected movie data
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      ? show['summary']
                                          .replaceAll(RegExp(r'<[^>]*>'), '')
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            // Navigate to Search Page when the search icon is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          }
        },
      ),
    );
  }
}
