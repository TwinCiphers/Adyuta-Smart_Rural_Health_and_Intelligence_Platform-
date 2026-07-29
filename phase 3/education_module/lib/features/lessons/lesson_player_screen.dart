import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/edu_theme.dart';
import '../../models/models.dart';
import '../../services/edu_storage_service.dart';

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
  }

  Future<void> _toggleCompletion() async {
    final newState = !_isCompleted;
    setState(() {
      _isCompleted = newState;
      widget.lesson.isCompleted = newState;
    });
    await EduStorageService.toggleLessonCompleted(widget.lesson.id, newState);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newState ? '🎉 Lesson marked as completed!' : 'Lesson unmarked.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: newState ? EduTheme.accentTeal : EduTheme.primaryIndigo,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openExternalVideo() async {
    final uri = Uri.parse(widget.lesson.videoUrl.isNotEmpty ? widget.lesson.videoUrl : 'https://www.youtube.com/results?search_query=${Uri.encodeComponent(widget.lesson.title)}');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open video URL: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EduTheme.textDark),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Text(
          widget.course.title,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: EduTheme.textDark),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Area
            Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [EduTheme.primaryIndigo.withOpacity(0.8), EduTheme.primaryViolet],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_lesson, color: EduTheme.accentGold, size: 56),
                      const SizedBox(height: 12),
                      Text(
                        'Interactive Video Lecture',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.lesson.duration,
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        onPressed: _openExternalVideo,
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: const Text('Watch External Stream / HD'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: EduTheme.accentGold,
                          foregroundColor: EduTheme.textDark,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: EduTheme.primaryIndigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'LESSON DETAIL',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: EduTheme.primaryIndigo),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 16, color: EduTheme.textGrey),
                          const SizedBox(width: 4),
                          Text(widget.lesson.duration, style: GoogleFonts.inter(fontSize: 13, color: EduTheme.textGrey, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.lesson.title,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: EduTheme.textDark),
                  ),
                  const SizedBox(height: 16),
                  
                  // Completion Checkbox Card
                  InkWell(
                    onTap: _toggleCompletion,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isCompleted ? const Color(0xFFF0FDF4) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _isCompleted ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0), width: 1.5),
                        boxShadow: EduTheme.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _isCompleted ? EduTheme.accentTeal : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(color: _isCompleted ? EduTheme.accentTeal : EduTheme.textGrey, width: 2),
                            ),
                            child: Icon(
                              Icons.check,
                              size: 18,
                              color: _isCompleted ? Colors.white : Colors.transparent,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isCompleted ? 'Lesson Completed!' : 'Mark Lesson as Completed',
                                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: _isCompleted ? const Color(0xFF166534) : EduTheme.textDark),
                                ),
                                Text(
                                  _isCompleted ? 'Great job! Progress recorded.' : 'Tap here once you finish this learning session.',
                                  style: GoogleFonts.inter(fontSize: 12, color: _isCompleted ? const Color(0xFF15803D) : EduTheme.textGrey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('About This Lesson', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: EduTheme.textDark)),
                  const SizedBox(height: 8),
                  Text(
                    widget.lesson.description.isNotEmpty ? widget.lesson.description : 'In this lesson, you will learn key techniques and practical applications designed for immediate implementation in your farm or rural enterprise.',
                    style: GoogleFonts.inter(fontSize: 14, color: EduTheme.textGrey, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Key Takeaways Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb, color: Color(0xFF2563EB), size: 20),
                            const SizedBox(width: 8),
                            Text('Key Learning Takeaways', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1E3A8A))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildTakeawayItem('Step-by-step practical implementation rules.'),
                        const SizedBox(height: 6),
                        _buildTakeawayItem('Designed for low-cost, high-yield rural growth.'),
                        const SizedBox(height: 6),
                        _buildTakeawayItem('Review notes anytime offline in your dashboard.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTakeawayItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, color: Color(0xFF2563EB), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E40AF))),
        ),
      ],
    );
  }
}
