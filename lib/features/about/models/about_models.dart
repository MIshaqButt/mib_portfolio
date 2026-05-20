class ExperienceModel {
  final String dateRange;
  final String title;
  final String company;
  final List<String> bullets;
  final List<String> tags;

  const ExperienceModel({
    required this.dateRange,
    required this.title,
    required this.company,
    required this.bullets,
    required this.tags,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      dateRange: json['date_range']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      bullets: List<String>.from(json['bullets'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_range': dateRange,
      'title': title,
      'company': company,
      'bullets': bullets,
      'tags': tags,
    };
  }

  static List<ExperienceModel> get list => [
    const ExperienceModel(
      dateRange: 'APR 2025 - PRESENT',
      title: 'Flutter Developer',
      company: 'Sparkix Technologies',
      bullets: [
        'Engineered and successfully deployed flagship applications including Alter Ego, ParentFlow, Riskli, and DreamyBot AI.',
        'Integrated advanced AI Chat-bots with contextual conversational models to increase active user retention by 35%.',
        'Built enterprise-grade state management solutions using clean Cubit (BLoC) architecture for fluid app responsiveness.',
        'Implemented secure subscription billing platforms with RevenueCat and fully managed iOS App Store & Android Play Store deployment lifecycles.',
      ],
      tags: ['Flutter', 'Cubit', 'Generative AI', 'RevenueCat', 'App Publishing'],
    ),
    const ExperienceModel(
      dateRange: 'FEB 2024 - DEC 2024',
      title: 'Sr. Flutter Developer',
      company: 'Swati Corporation',
      bullets: [
        'Designed high-performance cross-platform software containing secure REST APIs, real-time chats, and Web3 blockchain nodes.',
        'Engineered custom native Swift and Kotlin modules to interface directly with mobile system capabilities, boosting performance by 25%.',
        'Implemented enterprise state management using Bloc and Provider, ensuring responsive offline database caching.',
        'Collaborated in multi-functional teams to build and ship scalable software according to strict deadlines and budgets.',
      ],
      tags: ['Native Channels', 'WebSockets', 'Blockchain Web3', 'Bloc', 'Provider'],
    ),
    const ExperienceModel(
      dateRange: 'JAN 2023 - JAN 2024',
      title: 'Sr. Flutter Developer',
      company: 'United Softlabs Pvt. Ltd.',
      bullets: [
        'Created a desktop Point of Sale (POS) application integrating hardware elements like thermal ESC/POS printers and barcode scanners.',
        'Delivered highly responsive mobile applications including BeautyDukan and State App with fluid scroll animations.',
        'Integrated Firebase real-time datastores and local SQLite architectures to support secure data syncing and robust offline support.',
      ],
      tags: ['Desktop POS', 'ESC/POS Drivers', 'Hardware Scanning', 'SQLite', 'Firebase'],
    ),
    const ExperienceModel(
      dateRange: 'FEB 2021 - NOV 2022',
      title: 'Mobile Application Developer',
      company: 'APE IT Solution',
      bullets: [
        'Initiated Android engineering projects (EasyHajj, DOW, Haramayn Hotel) using Java before transitioning the tech stack to Flutter.',
        'Delivered scalable cross-platform mobile apps such as Sync Travel, Home Services, and Travel World.',
        'Integrated standard REST APIs, real-time Firebase services, and GetX state controllers to ensure smooth performance.',
      ],
      tags: ['Android SDK', 'Java', 'Flutter', 'GetX', 'REST API'],
    ),
    const ExperienceModel(
      dateRange: 'FEB 2020 - JAN 2021',
      title: 'Jr. Android Developer (Intern -> Jr.)',
      company: 'House of Professionals',
      bullets: [
        'Learned clean Android native development using Java, XML layouts, and local database systems.',
        'Contributed to the development and testing of a local Service Provider application and custom customer projects.',
        'Acquired hands-on skills in integrating third-party SDKs, API requests, and responsive mobile interfaces.',
      ],
      tags: ['Java', 'Android Studio', 'XML Layouts', 'REST APIs', 'SQL Lite'],
    ),
  ];
}

class EducationModel {
  final String dateRange;
  final String degree;
  final String institution;
  final List<String> courses;
  final String? grade;

  const EducationModel({
    required this.dateRange,
    required this.degree,
    required this.institution,
    required this.courses,
    this.grade,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      dateRange: json['date_range']?.toString() ?? '',
      degree: json['degree']?.toString() ?? '',
      institution: json['institution']?.toString() ?? '',
      courses: List<String>.from(json['courses'] ?? []),
      grade: json['grade']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_range': dateRange,
      'degree': degree,
      'institution': institution,
      'courses': courses,
      'grade': grade,
    };
  }

  static List<EducationModel> get list => [
    const EducationModel(
      dateRange: 'SEP 2021 - DEC 2023',
      degree: 'MS Computer Science',
      institution: 'FAST National University of Computer and Emerging Science, Lahore',
      courses: [
        'Advance Machine Learning',
        'Natural Language Processing (NLP)',
        'Computational Intelligence',
        'Advance Deep Learning'
      ],
    ),
    const EducationModel(
      dateRange: 'OCT 2016 - DEC 2020',
      degree: 'BS Computer Science',
      institution: 'Minhaj University, Lahore',
      grade: 'CGPA: 3.54 (Grade: B+ | Secured 1st Position Merit Award)',
      courses: [
        'Object-Oriented Language',
        'Data Structures & Algorithms',
        'Web Design & Development',
        'Artificial Intelligence',
        'Advance Software Engineering',
        'Software Project Management',
        'Operating Systems'
      ],
    ),
  ];
}

class CertificationModel {
  final String title;
  final String category;
  final String issuer;
  final String description;

  const CertificationModel({
    required this.title,
    required this.category,
    required this.issuer,
    required this.description,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      issuer: json['issuer']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'issuer': issuer,
      'description': description,
    };
  }

  static List<CertificationModel> get list => [
    const CertificationModel(
      title: 'MS Computer Science Degree',
      category: 'Degree',
      issuer: 'FAST NUCES Lahore',
      description: 'Official postgraduate degree in Computer Science, focusing on Deep Learning, Machine Learning, and NLP.',
    ),
    const CertificationModel(
      title: 'BS Computer Science Degree',
      category: 'Degree',
      issuer: 'Minhaj University Lahore',
      description: 'Official undergraduate graduation degree. Earned with a high CGPA of 3.54 and top ranking honors.',
    ),
    const CertificationModel(
      title: '1st Position Merit Certificate',
      category: 'Merit Award',
      issuer: 'Minhaj University Lahore',
      description: 'Official award certificate issued for securing the First Position in the Computer Science department.',
    ),
    const CertificationModel(
      title: 'Professional Experience Letter',
      category: 'Experience',
      issuer: 'Sparkix Technologies',
      description: 'Verification of responsibilities as a Flutter Application Engineer, delivering cutting-edge AI and tracking apps.',
    ),
    const CertificationModel(
      title: 'Senior Developer Experience Letter',
      category: 'Experience',
      issuer: 'Swati Corporation',
      description: 'Official senior role experience verification covering native integration, blockchain components, and WebSockets.',
    ),
    const CertificationModel(
      title: 'Senior Flutter Developer Letter',
      category: 'Experience',
      issuer: 'United Softlabs Pvt. Ltd.',
      description: 'Verification of senior developer tenure building desktop barcode/printer systems and core cross-platform apps.',
    ),
    const CertificationModel(
      title: 'Mobile Developer Certificate',
      category: 'Experience',
      issuer: 'APE IT Solutions Ltd',
      description: 'Official recognition of development duties creating REST API connected mobile and Android applications.',
    ),
    const CertificationModel(
      title: 'Android & Java Training Certificate',
      category: 'Certification',
      issuer: 'House of Professionals',
      description: 'Intense course completion certification covering Android SDK, Java Core, and Database operations.',
    ),
    const CertificationModel(
      title: 'Web & Desktop Short Course',
      category: 'Certification',
      issuer: 'Xtreme Computer Sciences Institute',
      description: 'Course completion certification in advanced software architectures and localized databases.',
    ),
  ];
}
