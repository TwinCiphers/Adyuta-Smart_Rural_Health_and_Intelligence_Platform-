import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:education_module/core/theme/edu_theme.dart';
import 'package:education_module/models/models.dart';
import 'package:education_module/services/edu_storage_service.dart';

class LessonPlayerScreen extends StatefulWidget {
  final Lesson lesson;
  final Course course;

  const LessonPlayerScreen({super.key, required this.lesson, required this.course});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.lesson.isCompleted;
    _launchPlaylist();
  }

  Future<void> _launchPlaylist() async {
    final url = Uri.parse(widget.lesson.videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    }
  }

  void _toggleCompletion() async {
    setState(() {
      _isCompleted = !_isCompleted;
      widget.lesson.isCompleted = _isCompleted;
    });
    
    // Save state to local database
    await EduStorageService.toggleLessonCompleted(widget.lesson.id, _isCompleted);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: GlobalBhashiniText(
            _isCompleted ? 'Marked as completed!' : 'Marked as uncompleted.',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: _isCompleted ? EduTheme.accentTeal : EduTheme.textGrey,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduTheme.background,
      appBar: AppBar(
        backgroundColor: EduTheme.primaryIndigo,
        title: GlobalBhashiniText('Playlist: ${widget.lesson.title}', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image Placeholder
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: EduTheme.primaryIndigo.withOpacity(0.1),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=600&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                )
              ),
              child: Center(
                child: IconButton(
                  iconSize: 64,
                  icon: const Icon(Icons.play_circle_fill, color: Colors.redAccent),
                  onPressed: _launchPlaylist,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalBhashiniText(
                    widget.lesson.title,
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: EduTheme.textDark),
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: EduTheme.textGrey),
                      const SizedBox(width: 4),
                      GlobalBhashiniText(widget.lesson.duration, style: GoogleFonts.inter(color: EduTheme.textGrey, fontSize: 14)),
                      const SizedBox(width: 16),
                      const Icon(Icons.video_library, size: 16, color: EduTheme.textGrey),
                      const SizedBox(width: 4),
                      GlobalBhashiniText('YouTube Playlist', style: GoogleFonts.inter(color: EduTheme.textGrey, fontSize: 14)),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  GlobalBhashiniText('About this Playlist', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: EduTheme.textDark)),
                  const SizedBox(height: 12),
                  GlobalBhashiniText(
                    "Tap the play button above to open this creator's playlist directly in YouTube. After you finish exploring their content, you can mark this topic as completed below.",
                    style: GoogleFonts.inter(fontSize: 15, height: 1.6, color: EduTheme.textDark.withOpacity(0.8)),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Completion Toggle
                  InkWell(
                    onTap: _toggleCompletion,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isCompleted ? const Color(0xFFDCFCE7) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _isCompleted ? EduTheme.accentTeal : const Color(0xFFE2E8F0)),
                        boxShadow: EduTheme.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _isCompleted ? EduTheme.accentTeal : EduTheme.background,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isCompleted ? Icons.check : Icons.circle_outlined,
                              color: _isCompleted ? Colors.white : EduTheme.textGrey,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GlobalBhashiniText(
                                  _isCompleted ? 'Completed!' : 'Mark Topic as Completed',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: _isCompleted ? EduTheme.textDark : EduTheme.primaryIndigo,
                                  ),
                                ),
                                if (!_isCompleted)
                                  GlobalBhashiniText(
                                    'Track your progress',
                                    style: GoogleFonts.inter(fontSize: 13, color: EduTheme.textGrey),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const GlobalBhashiniText('Open Playlist in Browser'),
                      onPressed: () async {
                        final url = Uri.parse(widget.lesson.videoUrl);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
