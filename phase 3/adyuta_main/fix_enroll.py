import re

with open(r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\education_module\lib\features\courses\course_detail_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

replacement = """if (newState) {
      await EduStorageService.enrollInCourse(widget.course.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Enrolled in ${widget.course.title}!', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            backgroundColor: EduTheme.accentTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        if (widget.course.lessons.isNotEmpty) {
          final firstIncomplete = widget.course.lessons.firstWhere((l) => !l.isCompleted, orElse: () => widget.course.lessons.first);
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonPlayerScreen(lesson: firstIncomplete, course: widget.course),
            ),
          );
          setState(() {});
        }
      }
    } else {"""

content = re.sub(r'if \(newState\)\s*\{.*?\}\s*else\s*\{', replacement, content, flags=re.DOTALL)

with open(r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\education_module\lib\features\courses\course_detail_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
