import 'package:audiobinge/favoriteUtils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_scrape_api/models/video.dart';
import 'videoComponent.dart';
import 'package:shimmer/shimmer.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'connectivityProvider.dart'; // Import connectivity provider
import 'MyVideo.dart';
import 'colors.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<MyVideo> _videos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  void fetchFavorites() async {
    setState(() {
      _isLoading = true;
    });
    List<MyVideo> videos = await getFavorites();
    setState(() {
      _videos = videos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final playing = context.watch<Playing>();
    bool isOnline =
        Provider.of<NetworkProvider>(context).isOnline; // Get online status

    return Scaffold(
      backgroundColor: Colors.black,
      body: isOnline // Check if online
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Favorites',
                        style: GoogleFonts.roboto(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 20.0,
                          ),
                          padding: EdgeInsets.all(16),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[700]!,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            );
                          },
                        )
                      : _videos.isEmpty
                          ? Center(
                              child: Text(
                                'No favorites yet.',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 20.0,
                              ),
                              padding: EdgeInsets.all(16),
                              itemCount: _videos.length,
                              itemBuilder: (context, index) {
                                final video = _videos[index];
                                return VideoComponent(video: video);
                              },
                            ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "You're offline. Favorites may not be up to date.",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
