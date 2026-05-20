enum ProjectCategory {
  all,
  mobile,
  desktop,
  crossPlatform,
}

class ProjectModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final ProjectCategory category;
  final List<String> technologies;
  final String? gitHubUrl;
  final String? liveUrl;
  final String? role;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.technologies,
    this.gitHubUrl,
    this.liveUrl,
    this.role,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    ProjectCategory cat;
    final catStr = (json['category'] as String?)?.toLowerCase() ?? '';
    if (catStr == 'mobile') {
      cat = ProjectCategory.mobile;
    } else if (catStr == 'desktop') {
      cat = ProjectCategory.desktop;
    } else if (catStr == 'crossplatform' || catStr == 'cross_platform') {
      cat = ProjectCategory.crossPlatform;
    } else {
      cat = ProjectCategory.all;
    }

    return ProjectModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: cat,
      technologies: List<String>.from(json['technologies'] ?? []),
      gitHubUrl: json['github_url'] as String?,
      liveUrl: json['live_url'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    String catStr;
    switch (category) {
      case ProjectCategory.mobile:
        catStr = 'mobile';
        break;
      case ProjectCategory.desktop:
        catStr = 'desktop';
        break;
      case ProjectCategory.crossPlatform:
        catStr = 'crossplatform';
        break;
      default:
        catStr = 'all';
    }

    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'category': catStr,
      'technologies': technologies,
      'github_url': gitHubUrl,
      'live_url': liveUrl,
      'role': role,
    };
  }

  static List<ProjectModel> get featuredProjects => [
    const ProjectModel(
      id: '01',
      title: 'Alter Ego',
      subtitle: 'Mobile Application (AI & Lifestyle)',
      description: 'A high-end lifestyle mobile application featuring personalized AI-driven chat-bots, custom chat backgrounds, interactive profile builders, and immersive user experiences designed to boost engagement. Integrated with RevenueCat subscriptions and deployed on the Play Store & App Store.',
      category: ProjectCategory.mobile,
      technologies: ['Flutter', 'Cubit', 'Generative AI', 'RevenueCat', 'SQLite', 'Rest API'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Lead Flutter Developer',
    ),
    const ProjectModel(
      id: '02',
      title: 'ParentFlow',
      subtitle: 'Mobile Application (Parenting & Tracking)',
      description: 'A comprehensive parenting platform providing real-time activity tracking, milestone logs, baby health stats, visual progress charts, and push notifications. Built using BLoC architecture, REST APIs, and Firebase for secure database synchronization and real-time alerts.',
      category: ProjectCategory.mobile,
      technologies: ['Flutter', 'Dart', 'BLoC/Cubit', 'Firebase', 'REST APIs', 'Push Notifications'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Mobile Engineer',
    ),
    const ProjectModel(
      id: '03',
      title: 'Riskli',
      subtitle: 'Mobile Application (Risk & Compliance)',
      description: 'An enterprise risk assessment application. Featuring interactive dynamic questionnaires, offline database storage, automatic generation of comprehensive executive PDF reports, and real-time sync with corporate servers.',
      category: ProjectCategory.mobile,
      technologies: ['Flutter', 'BLoC', 'REST APIs', 'Hive DB', 'PDF Generator', 'Dart'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Sr. Flutter Developer',
    ),
    const ProjectModel(
      id: '04',
      title: 'DreamyBot AI',
      subtitle: 'Mobile Application (AI Assistant)',
      description: 'A smart virtual assistant utilizing state-of-the-art Large Language Models. Supports complex context-aware natural conversations, custom prompt layouts, image analysis features, and fully functional subscription plans with RevenueCat.',
      category: ProjectCategory.mobile,
      technologies: ['Flutter', 'Cubit', 'Google AI SDK', 'RevenueCat', 'Firebase Auth', 'WebSockets'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Lead Developer',
    ),
    const ProjectModel(
      id: '05',
      title: 'Scrivilo',
      subtitle: 'Mobile Application (Content Writer & Notes)',
      description: 'A beautiful content generator and notes management application featuring an advanced rich text editor, category grouping, smart keyword tags, automatic offline synchronization, and encrypted cloud backups.',
      category: ProjectCategory.mobile,
      technologies: ['Flutter', 'Provider', 'SQLite', 'Cloud Sync', 'Encryption', 'Rest API'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Full Stack Developer',
    ),
    const ProjectModel(
      id: '06',
      title: 'Sobex E-Commerce',
      subtitle: 'Mobile Application (Retail Shop)',
      description: 'A feature-rich retail shopping application with advanced catalog searching, multi-criteria filters, complex shopping cart animations, payment integration, order tracking, and custom notification systems.',
      category: ProjectCategory.mobile,
      technologies: ['Flutter', 'GetX', 'Stripe API', 'Firebase', 'REST APIs', 'Cached Network Image'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Mobile Engineer',
    ),
    const ProjectModel(
      id: '07',
      title: 'D-idconnect',
      subtitle: 'Mobile Application (Secure Identity Manager)',
      description: 'A highly secure digital identification manager leveraging advanced cryptographic keys, local biometric scanners, secure local database vault systems, and encrypted WebSocket connections for secure identity handshakes.',
      category: ProjectCategory.mobile,
      technologies: ['Flutter', 'Cryptography', 'Secure Storage', 'Biometric Auth', 'WebSockets'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Sr. Mobile Developer',
    ),
    const ProjectModel(
      id: '08',
      title: 'E-votter',
      subtitle: 'Mobile Application (Decentralized Voting)',
      description: 'A decentralized, secure mobile voting platform using cryptographic tokens and blockchain API ledgers to ensure completely verifiable, transparent, and secure polling events.',
      category: ProjectCategory.mobile,
      technologies: ['Flutter', 'Web3Dart', 'Blockchain API', 'GetX', 'Cryptography', 'Local Auth'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Flutter Developer',
    ),
    const ProjectModel(
      id: '09',
      title: 'CareCircle',
      subtitle: 'Mobile & Desktop App (Health Circle)',
      description: 'A medical safety and location network app connecting family members and medical centers. Features real-time location streaming, smart geofencing, custom emergency alerts, and unified medical charts.',
      category: ProjectCategory.crossPlatform,
      technologies: ['Flutter', 'Google Maps API', 'Location SDK', 'Socket.io', 'Firebase', 'Window Manager'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Cross-Platform Engineer',
    ),
    const ProjectModel(
      id: '10',
      title: 'Attentify',
      subtitle: 'Desktop Application (Attendance Scanner)',
      description: 'An enterprise desktop terminal dashboard designed for administrative desks. Integrates directly with barcode and QR scanning hardware, tracks worker attendance shifts, and exports detailed excel and PDF sheets.',
      category: ProjectCategory.desktop,
      technologies: ['Flutter', 'SQLite', 'QR/Barcode Integrations', 'PDF Reports', 'Window Manager'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Desktop Developer',
    ),
    const ProjectModel(
      id: '11',
      title: 'Medsoft',
      subtitle: 'Desktop Application (Medical POS & Billing)',
      description: 'A clinical management and POS system designed for hospital pharmacies and clinics. Integrates with ESC/POS thermal receipt printers, barcoding systems, local inventory managers, and medical drug databases.',
      category: ProjectCategory.desktop,
      technologies: ['Flutter', 'Printer ESC/POS Drivers', 'SQLite', 'Hardware Scanner Integrations', 'Dynamic Printing'],
      gitHubUrl: 'https://github.com/mishaqbutt',
      role: 'Desktop Developer',
    ),
  ];
}
