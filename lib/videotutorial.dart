
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class VideoData {
  final String id;
  final String title;
  final String description;
  final String youtubeUrl;
  final String category;

  VideoData({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeUrl,
    required this.category,
  });

  String get embedUrl {
    final videoId = youtubeUrl.split('/').last.split('?').first;
    return 'https://www.youtube.com/embed/$videoId';
  }

  String get videoId {
    // handle shorts and watch URLs
    try {
      final uri = Uri.parse(youtubeUrl);
      if (uri.pathSegments.contains('shorts')) {
        return uri.pathSegments.last.split('?').first;
      }
      if (uri.queryParameters.containsKey('v')) return uri.queryParameters['v']!;
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.last.split('?').first : '';
    } catch (_) {
      return '';
    }
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final VideoData video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _ytController;
  bool _isYoutube = false;
  bool _muted = true;
  bool _isLoading = true;
  bool _loadError = false;

  @override
  void initState() {
    super.initState();
    final url = widget.video.youtubeUrl.trim();
    if (url.contains('youtube.com') || url.contains('youtu.be') || url.contains('/shorts/')) {
      _isYoutube = true;
      final id = widget.video.videoId;
      if (id.isEmpty) {
        _loadError = true;
        _isLoading = false;
        return;
      }
      _ytController = YoutubePlayerController(
        initialVideoId: id,
        flags: YoutubePlayerFlags(autoPlay: true, mute: _muted),
      )..addListener(() {
          if (!mounted) return;
          final ready = _ytController?.value.isReady ?? false;
          setState(() => _isLoading = !ready);
        });
    } else {
      try {
        _videoController = VideoPlayerController.network(url)
          ..initialize().then((_) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
            });
            _videoController?.setLooping(false);
            _videoController?.play();
          }).catchError((_) {
            if (!mounted) return;
            setState(() {
              _loadError = true;
              _isLoading = false;
            });
          });
      } catch (e) {
        _loadError = true;
        _isLoading = false;
      }
    }
  }

  @override
  void dispose() {
    _videoController?.pause();
    _videoController?.dispose();
    // _ytController?.close();
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_muted ? Icons.volume_off : Icons.volume_up, color: Colors.white),
            onPressed: () {
              setState(() {
                _muted = !_muted;
                if (_isYoutube) {
                  if (_muted) {
                    _ytController?.mute();
                  } else {
                    _ytController?.unMute();
                  }
                } else {
                  _videoController?.setVolume(_muted ? 0 : 1);
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                if (_loadError)
                  Center(
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.error_outline, color: Colors.white, size: 40),
                          SizedBox(height: 8),
                          Text('Failed to load video', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  )
                else if (_isYoutube)
                  (_ytController == null)
                      ? const Center(child: CircularProgressIndicator())
                      : YoutubePlayerBuilder(
                          player: YoutubePlayer(
                            controller: _ytController!,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.red,
                          ),
                          builder: (context, player) => player,
                        )
                else
                  (_videoController == null || !_videoController!.value.isInitialized)
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          ),
                        ),
                if (_isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.video.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(widget.video.description, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoTutorial extends StatefulWidget {
  const VideoTutorial({super.key});

  @override
  State<VideoTutorial> createState() => _VideoTutorialState();
}

class _VideoTutorialState extends State<VideoTutorial> {
  String selectedCategory = "All";

  final List<VideoData> allVideos = [
    // Cat Videos
    VideoData(
      id: 'cat1',
      title: "Cat Food Training",
      description: "Learn how to train your cat for proper feeding",
      youtubeUrl: 'https://youtube.com/shorts/40mI-kL82nc',
      category: 'Cats',
    ),
    VideoData(
      id: 'cat2',
      title: "Cat Behavior Training",
      description: "Understand and train cat behavior",
      youtubeUrl: 'https://youtube.com/shorts/H7hpIxntuaw',
      category: 'Cats',
    ),
    VideoData(
      id: 'cat3',
      title: "Cat Litter Training",
      description: "Teach your cat proper litter box habits",
      youtubeUrl: 'https://youtube.com/shorts/VAlC8JPmXCM',
      category: 'Cats',
    ),
    VideoData(
      id: 'cat4',
      title: "Cat Grooming Tips",
      description: "Keep your cat healthy and well-groomed",
      youtubeUrl: 'https://youtube.com/shorts/uRUXYLg4n_A',
      category: 'Cats',
    ),
    // Dog Videos
    VideoData(
      id: 'dog1',
      title: "Dog Food Training",
      description: "Train your dog for proper feeding",
      youtubeUrl: 'https://youtube.com/shorts/eJ27au_MK2U',
      category: 'Dogs',
    ),
    VideoData(
      id: 'dog2',
      title: "Dog Security Training",
      description: "Teach your dog security and protection",
      youtubeUrl: 'https://youtube.com/shorts/CVgZN6G5yC0',
      category: 'Dogs',
    ),
    VideoData(
      id: 'dog3',
      title: "Dog Listening Training",
      description: "Train your dog to listen and obey",
      youtubeUrl: 'https://youtube.com/shorts/NAODpmaoF24',
      category: 'Dogs',
    ),
    VideoData(
      id: 'dog4',
      title: "Leash Training",
      description: "Master leash training techniques",
      youtubeUrl: 'https://youtube.com/shorts/AF64kPSE1jI',
      category: 'Dogs',
    ),
    // General Videos
    VideoData(
      id: 'general1',
      title: "Basic Obedience Training",
      description: "Fundamental obedience training for all pets",
      youtubeUrl: 'https://youtube.com/shorts/QsrWJJ6eBlg',
      category: 'All',
    ),
    VideoData(
      id: 'general2',
      title: "How to Train Your Pet",
      description: "Complete guide to pet training",
      youtubeUrl: 'https://youtube.com/shorts/Q0OZKXiUu84',
      category: 'All',
    ),
  ];

  List<VideoData> getFilteredVideos() {
    if (selectedCategory == 'All') {
      return allVideos;
    }
    return allVideos.where((video) => video.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredVideos = getFilteredVideos();

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Pet Portal",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) => [],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CATEGORY BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                categoryButton("All", () {
                  setState(() {
                    selectedCategory = "All";
                  });
                }),
               categoryButton("Dogs", () {
                  setState(() {
                    selectedCategory = "Dogs";
                  });
                }),
                categoryButton("Cats", () {
                  setState(() {
                    selectedCategory = "Cats";
                  });
                }),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Video Tutorials",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredVideos.length,
                itemBuilder: (context, index) {
                  final video = filteredVideos[index];
                  return _videoCard(video: video);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoCard({required VideoData video}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: video)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    video.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.play_circle_fill, color: Color(0xff3F82FF), size: 32),
          ],
        ),
      ),
    );
  }
  
  // CATEGORY BUTTON
  Widget categoryButton(String text, VoidCallback onTap) {
    bool isActive = selectedCategory == text;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xff3F82FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
