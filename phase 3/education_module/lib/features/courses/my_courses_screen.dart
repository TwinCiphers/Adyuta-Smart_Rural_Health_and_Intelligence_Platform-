import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/theme/edu_theme.dart';
import '../../models/models.dart';
import '../../services/edu_storage_service.dart';
import 'course_detail_screen.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  List<Course> _enrolledCourses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEnrolled();
  }

  Future<void> _loadEnrolled() async {
    setState(() => _isLoading = true);
    final all = await EduStorageService.loadCoursesWithProgress();
    if (mounted) {
      setState(() {
        _enrolledCourses = all.where((c) => c.isEnrolled).toList();
        _isLoading = false;
      });
    }
  }

  void _openCourse(Course course) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
    );
    _loadEnrolled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: EduTheme.primaryIndigo))
          : _enrolledCourses.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadEnrolled,
                  color: EduTheme.primaryIndigo,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _enrolledCourses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final course = _enrolledCourses[index];
                      final progress = course.progressPercentage;
                      return InkWell(
                        onTap: () => _openCourse(course),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: EduTheme.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        course.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(color: EduTheme.primaryIndigo),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: EduTheme.accentGold,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'ENROLLED',
                                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10, color: EduTheme.textDark),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.title,
                                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: EduTheme.textDark),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Instructor: ${course.instructor}', style: GoogleFonts.inter(fontSize: 12, color: EduTheme.textGrey)),
                                    const SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Progress', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: EduTheme.textDark)),
                                        Text(
                                          '${(progress * 100).toInt()}%',
                                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: EduTheme.accentTeal),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    LinearPercentIndicator(
                                      lineHeight: 8.0,
                                      percent: progress,
                                      backgroundColor: const Color(0xFFE2E8F0),
                                      progressColor: EduTheme.accentTeal,
                                      barRadius: const Radius.circular(4),
                                      padding: EdgeInsets.zero,
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Resume Learning',
                                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: EduTheme.primaryIndigo),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.arrow_forward, size: 16, color: EduTheme.primaryIndigo),
                                      ],
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: EduTheme.primaryIndigo.withOpacity(0.08), shape: BoxShape.circle),
              child: const Icon(Icons.school_outlined, size: 64, color: EduTheme.primaryIndigo),
            ),
            const SizedBox(height: 20),
            Text('No Enrolled Courses Yet', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: EduTheme.textDark)),
            const SizedBox(height: 8),
            Text(
              'Explore our catalog of free rural skill courses and enroll today to start learning offline & online!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: EduTheme.textGrey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
