import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/edu_theme.dart';
import '../../models/models.dart';
import '../../services/edu_storage_service.dart';
import '../courses/course_detail_screen.dart';
import '../courses/my_courses_screen.dart';

class EduHomeScreen extends StatefulWidget {
  const EduHomeScreen({super.key});

  @override
  State<EduHomeScreen> createState() => _EduHomeScreenState();
}

class _EduHomeScreenState extends State<EduHomeScreen> {
  int _currentIndex = 0;
  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debouncer;
  bool _isLoading = true;

  final List<String> _categories = ['All', 'Agri', 'Finance', 'Tech', 'Business'];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    final courses = await EduStorageService.loadCoursesWithProgress();
    if (mounted) {
      setState(() {
        _allCourses = courses;
        _applyFilters();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debouncer?.isActive ?? false) _debouncer!.cancel();
    _debouncer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query.toLowerCase();
        _applyFilters();
      });
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredCourses = _allCourses.where((course) {
      final matchesQuery = _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery) ||
          course.instructor.toLowerCase().contains(_searchQuery) ||
          course.description.toLowerCase().contains(_searchQuery);
      final matchesCat = _selectedCategory == 'All' || course.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchesQuery && matchesCat;
    }).toList();
  }

  void _openCourse(Course course) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
    );
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _currentIndex == 0 ? _buildCatalogTab() : const MyCoursesScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 0) _loadCourses();
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: EduTheme.primaryIndigo,
          unselectedItemColor: EduTheme.textGrey,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Course Catalog'),
            BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'My Courses'),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: EduTheme.primaryIndigo,
          expandedHeight: 180,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Adyuta E-Learn',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          centerTitle: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: EduTheme.heroGradient,
                  ),
                ),
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(Icons.school, size: 160, color: Colors.white.withOpacity(0.1)),
                ),
                Positioned(
                  left: 20,
                  bottom: 24,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: EduTheme.accentGold, borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          'RURAL SKILL ACADEMY',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10, color: EduTheme.textDark),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Master Free Skills Online & Offline',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: EduTheme.cardShadow,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: GoogleFonts.inter(fontSize: 14, color: EduTheme.textDark),
                    decoration: InputDecoration(
                      hintText: 'Search skills, farming, finance, tech...',
                      hintStyle: GoogleFonts.inter(color: EduTheme.textGrey, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: EduTheme.primaryIndigo),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: EduTheme.textGrey),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Category Pills
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return InkWell(
                        onTap: () => _onCategorySelected(cat),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? EduTheme.primaryIndigo : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? EduTheme.primaryIndigo : const Color(0xFFCBD5E1)),
                            boxShadow: isSelected ? EduTheme.cardShadow : null,
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isSelected ? Colors.white : EduTheme.textDark,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Available Courses (${_filteredCourses.length})',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: EduTheme.textDark),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        // Courses List
        _isLoading
            ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: EduTheme.primaryIndigo)))
            : _filteredCourses.isEmpty
                ? SliverFillRemaining(child: _buildNoResults())
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final course = _filteredCourses[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCourseCard(course),
                          );
                        },
                        childCount: _filteredCourses.length,
                      ),
                    ),
                  ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildCourseCard(Course course) {
    return InkWell(
      onTap: () => _openCourse(course),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: EduTheme.cardShadow,
          border: Border.all(color: course.isEnrolled ? const Color(0xFF86EFAC) : const Color(0xFFF1F5F9)),
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
                          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: EduTheme.accentGold, borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          course.category.toUpperCase(),
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10, color: EduTheme.textDark),
                        ),
                      ),
                    ),
                    if (course.isEnrolled)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: EduTheme.accentTeal, borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            'ENROLLED',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: EduTheme.textGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          course.instructor,
                          style: GoogleFonts.inter(fontSize: 12, color: EduTheme.textGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.menu_book, size: 16, color: EduTheme.primaryIndigo),
                          const SizedBox(width: 4),
                          Text(
                            '${course.lessons.length} Lessons',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12, color: EduTheme.primaryIndigo),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('View Syllabus', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: EduTheme.textDark)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios, size: 12, color: EduTheme.textDark),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: EduTheme.textGrey),
            const SizedBox(height: 16),
            Text('No Courses Found', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: EduTheme.textDark)),
            const SizedBox(height: 8),
            Text(
              'We could not find any courses matching your search. Try different keywords or select "All" categories.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: EduTheme.textGrey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
