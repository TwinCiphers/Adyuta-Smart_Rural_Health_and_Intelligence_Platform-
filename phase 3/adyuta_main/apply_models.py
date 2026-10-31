import json

with open("scraped_videos.json", "r") as f:
    queries = json.load(f)

code = """class Lesson {
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
    return ["""

courses = [
    {
        "id": "course_01",
        "title": "Modern Organic Farming & Soil Mastery",
        "instructor": "Dr. Ramesh Kulkarni",
        "category": "Agri",
        "description": "Master sustainable organic farming methods, natural vermicomposting, soil nutrient balancing, and eco-friendly pest control.",
        "imageUrl": "https://images.unsplash.com/photo-1592982537447-6f2a6e0c856f?q=80&w=600&auto=format&fit=crop"
    },
    {
        "id": "course_02",
        "title": "Digital Literacy & Smartphone Banking",
        "instructor": "Priya Sharma (FinTech Specialist)",
        "category": "Finance",
        "description": "Empowering rural citizens with confidence to use smartphones, UPI payments, mobile banking, and online portals safely.",
        "imageUrl": "https://images.unsplash.com/photo-1556742049-0a67d55febc4?q=80&w=600&auto=format&fit=crop"
    },
    {
        "id": "course_03",
        "title": "Agri-Tech Drones & Smart Irrigation",
        "instructor": "Anil Varma (Agri-Tech Engineer)",
        "category": "Tech",
        "description": "A futuristic guide to using agricultural spray drones, automated drip irrigation sensors, and satellite maps.",
        "imageUrl": "https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?q=80&w=600&auto=format&fit=crop"
    },
    {
        "id": "course_04",
        "title": "Women Entrepreneurship in Cottage Industries",
        "instructor": "Savitri Devi (Self-Help Group Leader)",
        "category": "Business",
        "description": "Step-by-step training on launching rural cottage businesses, food processing, handicraft packaging, and micro-loans.",
        "imageUrl": "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=600&auto=format&fit=crop"
    }
]

def generate_lessons(course_idx, topic, lessons_data):
    lessons_str = ""
    for i, data in enumerate(lessons_data):
        lessons_str += f"""
          Lesson(
            id: 'l{course_idx}_{i+1}',
            title: '{data["title"].replace("'", "\\'")}',
            duration: '15 mins',
            description: 'Comprehensive tutorial from {data["title"].replace("'", "\\'")} tailored for rural development.',
            videoUrl: 'https://www.youtube.com/watch?v={data["videoId"]}',
          ),"""
    return lessons_str

for i, c in enumerate(courses):
    course_id = c["id"]
    lessons_data = queries[course_id]
    lessons_str = generate_lessons(i+1, c["title"], lessons_data)
    code += f"""
      Course(
        id: '{c["id"]}',
        title: '{c["title"]}',
        instructor: '{c["instructor"]}',
        category: '{c["category"]}',
        description: '{c["description"]}',
        imageUrl: '{c["imageUrl"]}',
        lessons: [{lessons_str}
        ],
      ),"""

code += """
    ];
  }
}
"""

with open(r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\education_module\lib\models\models.dart', 'w', encoding='utf-8') as f:
    f.write(code)
