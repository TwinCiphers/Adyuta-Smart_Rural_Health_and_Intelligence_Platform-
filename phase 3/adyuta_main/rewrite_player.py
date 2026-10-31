import re

path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\education_module\lib\features\lessons\lesson_player_screen.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

# Replace imports
code = code.replace(
    "import 'package:youtube_player_flutter/youtube_player_flutter.dart';",
    "import 'package:video_player/video_player.dart';\nimport 'package:chewie/chewie.dart';\nimport 'package:youtube_explode_dart/youtube_explode_dart.dart';"
)

state_vars = """class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  late bool _isCompleted;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.lesson.isCompleted;
    _initNativePlayer();
  }

  Future<void> _initNativePlayer() async {
    try {
      final yt = YoutubeExplode();
      final videoId = VideoId.parseVideoId(widget.lesson.videoUrl) ?? '';
      if (videoId.isEmpty) throw Exception('Invalid video ID');

      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      final streamInfo = manifest.muxed.withHighestBitrate();
      
      _videoPlayerController = VideoPlayerController.networkUrl(streamInfo.url);
      await _videoPlayerController!.initialize();
      
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          playedColor: EduTheme.accentGold,
          handleColor: EduTheme.accentGold,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white30,
        ),
      );
      
      yt.close();
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Stream unavailable. Try external player.';
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }"""

code = re.sub(
    r'class _LessonPlayerScreenState extends State<LessonPlayerScreen>\s*\{.*?void dispose\(\)\s*\{.*?super\.dispose\(\);\s*\}',
    state_vars,
    code,
    flags=re.DOTALL
)

ui_replacement = """            // Video Player Area
            Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: EduTheme.accentGold))
                : _chewieController != null 
                  ? Chewie(controller: _chewieController!)
                  : Stack("""

code = re.sub(
    r'            // Video Player Area.*?child: _youtubeController != null.*?:\s*Stack\(',
    ui_replacement,
    code,
    flags=re.DOTALL
)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
