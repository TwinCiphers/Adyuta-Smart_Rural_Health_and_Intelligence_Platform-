class Lesson {
  final String id;
  final String title;
  final String duration;
  final String description;
  final String videoUrl;
  bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.description,
    required this.videoUrl,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'description': description,
      'videoUrl': videoUrl,
      'isCompleted': isCompleted,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      duration: map['duration'] ?? '10 mins',
      description: map['description'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

class Course {
  final String id;
  final String title;
  final String instructor;
  final String category;
  final String description;
  final String imageUrl;
  final List<Lesson> lessons;
  bool isEnrolled;

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.lessons,
    this.isEnrolled = false,
  });

  double get progressPercentage {
    if (lessons.isEmpty) return 0.0;
    int completedCount = lessons.where((l) => l.isCompleted).length;
    return completedCount / lessons.length;
  }
}

class EduCatalog {
  static List<Course> getInitialCourses() {
    return [
      Course(
        id: 'course_01',
        title: 'Agriculture Playlists',
        instructor: 'Various Creators',
        category: 'Agri',
        description: 'Explore the best agricultural channels on YouTube.',
        imageUrl: 'https://picsum.photos/seed/agri/600/400',
        lessons: [
          Lesson(id: 'l1_1', title: 'Millennial Farmer', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Millennial+Farmer'),
          Lesson(id: 'l1_2', title: 'Ag PhD', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Ag+PhD+Hefty'),
          Lesson(id: 'l1_3', title: 'How Farms Work', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=How+Farms+Work'),
          Lesson(id: 'l1_4', title: 'Farmonaut', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Farmonaut'),
          Lesson(id: 'l1_5', title: "Nature's Always Right", duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Nature%27s+Always+Right'),
          Lesson(id: 'l1_6', title: 'Krishi Jagran', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Krishi+Jagran'),
          Lesson(id: 'l1_7', title: 'Digital Green', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Digital+Green+agriculture'),
          Lesson(id: 'l1_8', title: 'Peterson Farm Bros', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Peterson+Farm+Bros'),
          Lesson(id: 'l1_9', title: 'Cole the Cornstar', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Cole+the+Cornstar'),
          Lesson(id: 'l1_10', title: 'FAO', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=FAO+sustainable+agriculture'),
        ],
      ),
      Course(
        id: 'course_02',
        title: 'Finance Playlists',
        instructor: 'Various Creators',
        category: 'Finance',
        description: 'Explore the best finance channels on YouTube.',
        imageUrl: 'https://picsum.photos/seed/fin/600/400',
        lessons: [
          Lesson(id: 'l2_1', title: 'The Plain Bagel', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=The+Plain+Bagel'),
          Lesson(id: 'l2_2', title: 'Ben Felix', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Ben+Felix+PWL+Capital'),
          Lesson(id: 'l2_3', title: 'Graham Stephan', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Graham+Stephan'),
          Lesson(id: 'l2_4', title: 'Two Cents PBS', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Two+Cents+PBS'),
          Lesson(id: 'l2_5', title: 'Patrick Boyle', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Patrick+Boyle+finance'),
          Lesson(id: 'l2_6', title: 'Zerodha Varsity', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Zerodha+Varsity'),
          Lesson(id: 'l2_7', title: 'CA Rachana Ranade', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=CA+Rachana+Ranade'),
          Lesson(id: 'l2_8', title: 'Khan Academy Finance', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Khan+Academy+Finance+and+Capital+Markets'),
          Lesson(id: 'l2_9', title: 'Aswath Damodaran', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Aswath+Damodaran+valuation'),
          Lesson(id: 'l2_10', title: 'Bloomberg Originals', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Bloomberg+Originals+markets'),
        ],
      ),
      Course(
        id: 'course_03',
        title: 'Tech Playlists',
        instructor: 'Various Creators',
        category: 'Tech',
        description: 'Explore the best tech channels on YouTube.',
        imageUrl: 'https://picsum.photos/seed/tech/600/400',
        lessons: [
          Lesson(id: 'l3_1', title: 'Fireship', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Fireship'),
          Lesson(id: 'l3_2', title: 'freeCodeCamp', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=freeCodeCamp'),
          Lesson(id: 'l3_3', title: 'Traversy Media', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Traversy+Media'),
          Lesson(id: 'l3_4', title: 'CS50 Harvard', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=CS50+Harvard'),
          Lesson(id: 'l3_5', title: 'Two Minute Papers', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Two+Minute+Papers'),
          Lesson(id: 'l3_6', title: 'NetworkChuck', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=NetworkChuck'),
          Lesson(id: 'l3_7', title: 'The Cyber Mentor', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=The+Cyber+Mentor'),
          Lesson(id: 'l3_8', title: 'Corey Schafer', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Corey+Schafer+Python'),
          Lesson(id: 'l3_9', title: 'IBM Technology', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=IBM+Technology'),
          Lesson(id: 'l3_10', title: 'sentdex', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=sentdex'),
        ],
      ),
      Course(
        id: 'course_04',
        title: 'Business Playlists',
        instructor: 'Various Creators',
        category: 'Business',
        description: 'Explore the best business channels on YouTube.',
        imageUrl: 'https://picsum.photos/seed/biz/600/400',
        lessons: [
          Lesson(id: 'l4_1', title: 'Y Combinator', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Y+Combinator+startup+school'),
          Lesson(id: 'l4_2', title: 'Harvard Business Review', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Harvard+Business+Review+YouTube'),
          Lesson(id: 'l4_3', title: 'Ali Abdaal', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Ali+Abdaal'),
          Lesson(id: 'l4_4', title: 'Valuetainment', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Valuetainment+Patrick+Bet-David'),
          Lesson(id: 'l4_5', title: 'Slidebean', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Slidebean+startup'),
          Lesson(id: 'l4_6', title: 'Think Media', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Think+Media'),
          Lesson(id: 'l4_7', title: 'Wall Street Journal', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Wall+Street+Journal+business'),
          Lesson(id: 'l4_8', title: 'Exponent podcast', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Exponent+podcast+tech+business'),
          Lesson(id: 'l4_9', title: 'GaryVee', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=GaryVee'),
          Lesson(id: 'l4_10', title: 'Stanford GSB View', duration: 'Playlist', description: '', videoUrl: 'https://www.youtube.com/results?search_query=Stanford+GSB+View+From+The+Top'),
        ],
      ),
    ];
  }
}
