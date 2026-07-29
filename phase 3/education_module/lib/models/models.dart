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
        title: 'Modern Organic Farming & Soil Mastery',
        instructor: 'Dr. Ramesh Kulkarni',
        category: 'Agri',
        description: 'Master sustainable organic farming methods, natural vermicomposting, soil nutrient balancing, and eco-friendly pest control designed for higher yields and soil health.',
        imageUrl: 'https://images.unsplash.com/photo-1592982537447-6f2a6e0c856f?q=80&w=600&auto=format&fit=crop',
        lessons: [
          Lesson(
            id: 'l1_1',
            title: 'Introduction to Organic Soil Health',
            duration: '12 mins',
            description: 'Learn the fundamental microbes and minerals that transform dead soil into rich, living organic farmland.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
          Lesson(
            id: 'l1_2',
            title: 'Vermicomposting Setup & Daily Care',
            duration: '18 mins',
            description: 'Step-by-step practical demonstration on setting up low-cost earthworm compost pits in rural backyards.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
          Lesson(
            id: 'l1_3',
            title: 'Natural Pest Control (Jeevamrutham)',
            duration: '15 mins',
            description: 'How to prepare herbal biopesticides and liquid fertilizers using cow dung, urine, and neem leaves.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
          Lesson(
            id: 'l1_4',
            title: 'Crop Rotation & Yield Maximization',
            duration: '20 mins',
            description: 'Strategic seasonal crop rotation schedules that prevent soil depletion and multiply farmer income.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
        ],
      ),
      Course(
        id: 'course_02',
        title: 'Digital Literacy & Smartphone Banking',
        instructor: 'Priya Sharma (FinTech Specialist)',
        category: 'Finance',
        description: 'Empowering rural citizens with confidence to use smartphones, UPI payments, mobile banking, digital land records, and online government scheme portals securely.',
        imageUrl: 'https://images.unsplash.com/photo-1556742049-0a67d55febc4?q=80&w=600&auto=format&fit=crop',
        lessons: [
          Lesson(
            id: 'l2_1',
            title: 'Getting Started with UPI & QR Codes',
            duration: '10 mins',
            description: 'Understanding how to safely scan QR codes, transfer money without bank visits, and verify transactions.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
          Lesson(
            id: 'l2_2',
            title: 'Protecting Yourself from Financial Scams',
            duration: '14 mins',
            description: 'Recognizing OTP fraud, fake customer care numbers, and phishing links to keep your bank account secure.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
          Lesson(
            id: 'l2_3',
            title: 'Accessing Digital Land Records (Bhoomi/Bhulekh)',
            duration: '16 mins',
            description: 'How to view, download, and verify your agricultural land records directly from state government portals.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
        ],
      ),
      Course(
        id: 'course_03',
        title: 'Agri-Tech Drones & Smart Irrigation',
        instructor: 'Anil Varma (Agri-Tech Engineer)',
        category: 'Tech',
        description: 'A futuristic guide to using agricultural spray drones, automated drip irrigation sensors, and satellite weather maps to save water and reduce labor costs.',
        imageUrl: 'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?q=80&w=600&auto=format&fit=crop',
        lessons: [
          Lesson(
            id: 'l3_1',
            title: 'Introduction to Kisan Drones',
            duration: '15 mins',
            description: 'Overview of drone spraying technology, battery maintenance, and government subsidy schemes for drone purchase.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
          Lesson(
            id: 'l3_2',
            title: 'Drip Irrigation & Soil Moisture Sensors',
            duration: '18 mins',
            description: 'Setting up automated timers and soil sensors that water your crops precisely when needed, saving 50% water.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
        ],
      ),
      Course(
        id: 'course_04',
        title: 'Women Entrepreneurship in Cottage Industries',
        instructor: 'Savitri Devi (Self-Help Group Leader)',
        category: 'Business',
        description: 'Step-by-step training on launching rural cottage businesses, food processing, handicraft packaging, micro-loans, and marketing to urban consumers.',
        imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=600&auto=format&fit=crop',
        lessons: [
          Lesson(
            id: 'l4_1',
            title: 'Forming & Managing Self-Help Groups (SHG)',
            duration: '12 mins',
            description: 'How to organize a 10-member women self-help group, open a joint bank account, and start internal savings.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
          Lesson(
            id: 'l4_2',
            title: 'Packaging & FSSAI Licensing for Food Products',
            duration: '15 mins',
            description: 'Essential quality hygiene rules and simple online FSSAI registration for selling homemade pickles and spices.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
          Lesson(
            id: 'l4_3',
            title: 'Selling via ONDC & Social Media',
            duration: '20 mins',
            description: 'Connecting your rural products to national buyers using WhatsApp catalogs and the Open Network for Digital Commerce.',
            videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
          ),
        ],
      ),
    ];
  }
}
