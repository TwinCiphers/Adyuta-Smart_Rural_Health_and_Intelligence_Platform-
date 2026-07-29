import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/theme/edu_theme.dart';
import '../../models/models.dart';
import '../../services/edu_storage_service.dart';
import '../lessons/lesson_player_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late bool _isEnrolled;

  @override
  void initState() {
    super.initState();
    _isEnrolled = widget.course.isEnrolled;
  }

  Future<void> _toggleEnrollment() async {
    final newState = !_isEnrolled;
    setState(() {
      _isEnrolled = newState;
      widget.course.isEnrolled = newState;
    });
    if (newState) {
      await EduStorageService.enrollInCourse(widget.course.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Enrolled in ${widget.course.title}!', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            backgroundColor: EduTheme.accentTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      await EduStorageService.unenrollFromCourse(widget.course.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unenrolled from course.', style: GoogleFonts.inter()),
            backgroundColor: EduTheme.textGrey,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openLesson(Lesson lesson) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonPlayerScreen(lesson: lesson, course: widget.course),
      ),
    );
    // Refresh state when returning to update checkmarks and progress bar
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.course.progressPercentage;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // Hero Sliver AppBar
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: EduTheme.primaryIndigo,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context, true),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.course.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: EduTheme.primaryIndigo),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.75), Colors.transparent, Colors.black.withOpacity(0.85)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: EduTheme.accentGold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.course.category.toUpperCase(),
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10, color: EduTheme.textDark),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.course.title,
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Instructor: ${widget.course.instructor}',
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enrollment / Progress Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: EduTheme.cardShadow,
                      border: Border.all(color: _isEnrolled ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(_isEnrolled ? Icons.school : Icons.menu_book, color: _isEnrolled ? EduTheme.accentTeal : EduTheme.primaryIndigo, size: 24),
                                const SizedBox(width: 10),
                                Text(
                                  _isEnrolled ? 'Currently Enrolled' : 'Free Rural Skill Course',
                                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: EduTheme.textDark),
                                ),
                              ],
                            ),
                            if (_isEnrolled)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  '${(progress * 100).toInt()}% Done',
                                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12, color: const Color(0xFF166534)),
                                ),
                              ),
                          ],
                        ),
                        if (_isEnrolled) ...[
                          const SizedBox(height: 14),
                          LinearPercentIndicator(
                            lineHeight: 8.0,
                            percent: progress,
                            backgroundColor: const Color(0xFFE2E8F0),
                            progressColor: EduTheme.accentTeal,
                            barRadius: const Radius.circular(4),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 8),
                          Text('Complete all lessons below to master this topic!', style: GoogleFonts.inter(fontSize: 12, color: EduTheme.textGrey)),
                        ],
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _toggleEnrollment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isEnrolled ? const Color(0xFFFEF2F2) : EduTheme.primaryIndigo,
                              foregroundColor: _isEnrolled ? const Color(0xFFDC2626) : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: _isEnrolled ? 0 : 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: _isEnrolled ? const BorderSide(color: Color(0xFFFECACA)) : BorderSide.none,
                              ),
                            ),
                            child: Text(
                              _isEnrolled ? 'Unenroll from Course' : 'Enroll Now for Free',
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Course Overview
                  Text('Course Overview', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: EduTheme.textDark)),
                  const SizedBox(height: 8),
                  Text(
                    widget.course.description,
                    style: GoogleFonts.inter(fontSize: 14, color: EduTheme.textGrey, height: 1.5),
                  ),
                  const SizedBox(height: 28),

                  // Syllabus Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Course Syllabus', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: EduTheme.textDark)),
                      Text('${widget.course.lessons.length} Lessons', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: EduTheme.primaryIndigo)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Lessons List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.course.lessons.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lesson = widget.course.lessons[index];
                      return InkWell(
                        onTap: () => _openLesson(lesson),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: EduTheme.cardShadow,
                            border: Border.all(color: lesson.isCompleted ? const Color(0xFF86EFAC) : const Color(0xFFF1F5F9)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: lesson.isCompleted ? const Color(0xFFDCFCE7) : EduTheme.primaryIndigo.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: lesson.isCompleted
                                      ? const Icon(Icons.check_circle, color: EduTheme.accentTeal, size: 22)
                                      : Text(
                                          '${index + 1}',
                                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: EduTheme.primaryIndigo),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lesson.title,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: lesson.isCompleted ? const Color(0xFF166534) : EduTheme.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.play_circle_outline, size: 14, color: EduTheme.textGrey),
                                        const SizedBox(width: 4),
                                        Text(lesson.duration, style: GoogleFonts.inter(fontSize: 12, color: EduTheme.textGrey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: EduTheme.textGrey),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
