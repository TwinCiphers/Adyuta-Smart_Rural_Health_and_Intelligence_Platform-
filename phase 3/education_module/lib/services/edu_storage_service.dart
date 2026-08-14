import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class EduStorageService {
  static const String _enrolledKey = 'elearn_enrolled_course_ids';
  static const String _completedLessonsKey = 'elearn_completed_lesson_ids';

  static Future<List<String>> getEnrolledCourseIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_enrolledKey) ?? [];
  }

  static Future<void> enrollInCourse(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_enrolledKey) ?? [];
    if (!list.contains(courseId)) {
      list.add(courseId);
      await prefs.setStringList(_enrolledKey, list);
    }
  }

  static Future<void> unenrollFromCourse(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_enrolledKey) ?? [];
    if (list.contains(courseId)) {
      list.remove(courseId);
      await prefs.setStringList(_enrolledKey, list);
    }
  }

  static Future<List<String>> getCompletedLessonIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedLessonsKey) ?? [];
  }

  static Future<void> toggleLessonCompleted(String lessonId, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_completedLessonsKey) ?? [];
    if (completed && !list.contains(lessonId)) {
      list.add(lessonId);
      await prefs.setStringList(_completedLessonsKey, list);
    } else if (!completed && list.contains(lessonId)) {
      list.remove(lessonId);
      await prefs.setStringList(_completedLessonsKey, list);
    }
  }

  static Future<List<Course>> loadCoursesWithProgress() async {
    final courses = EduCatalog.getInitialCourses();
    final enrolledIds = await getEnrolledCourseIds();
    final completedLessonIds = await getCompletedLessonIds();

    for (var course in courses) {
      course.isEnrolled = enrolledIds.contains(course.id);
      for (var lesson in course.lessons) {
        lesson.isCompleted = completedLessonIds.contains(lesson.id);
      }
    }
    return courses;
  }
}
