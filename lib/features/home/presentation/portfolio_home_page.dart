import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mib_portfolio/core/constants/app_colors.dart';
import 'package:mib_portfolio/core/widgets/glass_container.dart';
import 'package:mib_portfolio/features/about/models/about_models.dart';
import 'package:mib_portfolio/features/contact/cubit/contact_cubit.dart';
import 'package:mib_portfolio/features/projects/models/project_model.dart';
import 'package:mib_portfolio/features/projects/presentation/project_details_screen.dart';
import 'package:mib_portfolio/features/home/presentation/admin_panel_screen.dart';
import 'package:mib_portfolio/features/home/cubit/navigation_cubit.dart';

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();

  // Keys for scroll targeting
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _worksKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _certificationsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Project filtering state
  ProjectCategory _selectedCategory = ProjectCategory.all;
  List<ProjectModel> _projectsList = ProjectModel.featuredProjects;

  // Profile Config Variables
  String _profileName = 'M. Ishaq Butt';
  String _profileTagline = 'Lead Mobile Engineer';
  String _profileIntro = 'Crafting high-performance cross-platform experiences with Flutter, Dart, AI, and secure backend solutions.';
  String _profileAboutText = 'I am a highly dedicated and solutions-oriented Mobile Application Developer with a rich history of building and publishing flagship software packages.';
  String _profileEmail = 'mishaqbutt98@gmail.com';
  String _profilePhone = '+92 301 4452093';
  String _profileAddress = 'Lahore, Punjab, Pakistan';
  String _profileGithubUrl = 'https://github.com/mishaqbutt';
  String _profileLinkedinUrl = 'https://linkedin.com/in/m-ishaq-butt-715b70211';
  String _profileGmailUrl = 'mailto:mishaqbutt98@gmail.com';

  // Dynamic Lists with offline-first fallbacks
  List<ExperienceModel> _experiencesList = ExperienceModel.list;
  List<EducationModel> _educationList = EducationModel.list;
  List<CertificationModel> _certificationsList = CertificationModel.list;

  // Contact form text controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Active Cert Lightbox state
  CertificationModel? _selectedCert;

  late List<GlobalKey> _sectionKeys;
  final List<String> _sectionNames = [
    'Home',
    'About',
    'Works',
    'Education',
    'Experience',
    'Certifications',
    'Contact',
  ];

  @override
  void initState() {
    super.initState();
    _sectionKeys = [
      _homeKey,
      _aboutKey,
      _worksKey,
      _educationKey,
      _experienceKey,
      _certificationsKey,
      _contactKey,
    ];
    _scrollController.addListener(_onScrollListener);
    _fetchLivePortfolioData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollListener);
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchLivePortfolioData() async {
    final client = Supabase.instance.client;

    // 1. Fetch config
    try {
      final configResponse = await client.from('portfolio_config').select().eq('id', 1).maybeSingle();
      if (configResponse != null) {
        setState(() {
          _profileName = configResponse['name']?.toString() ?? _profileName;
          _profileTagline = configResponse['tagline']?.toString() ?? _profileTagline;
          _profileIntro = configResponse['intro']?.toString() ?? _profileIntro;
          _profileAboutText = configResponse['about_text']?.toString() ?? _profileAboutText;
          _profileEmail = configResponse['email']?.toString() ?? _profileEmail;
          _profilePhone = configResponse['phone']?.toString() ?? _profilePhone;
          _profileAddress = configResponse['address']?.toString() ?? _profileAddress;
          _profileGithubUrl = configResponse['github_url']?.toString() ?? _profileGithubUrl;
          _profileLinkedinUrl = configResponse['linkedin_url']?.toString() ?? _profileLinkedinUrl;
          _profileGmailUrl = configResponse['gmail_url']?.toString() ?? _profileGmailUrl;
        });
      }
    } catch (e) {
      debugPrint('Error fetching portfolio config from Supabase: $e');
    }

    // 2. Fetch projects
    try {
      final projectsResponse = await client.from('projects').select().order('created_at', ascending: true);
      if (projectsResponse.isNotEmpty) {
        final fetchedList = projectsResponse.map<ProjectModel>((row) => ProjectModel.fromJson(row)).toList();
        setState(() {
          _projectsList = fetchedList;
        });
      }
    } catch (e) {
      debugPrint('Error fetching live projects from Supabase: $e');
    }

    // 3. Fetch experiences
    try {
      final expResponse = await client.from('experiences').select().order('created_at', ascending: true);
      if (expResponse.isNotEmpty) {
        final fetchedList = expResponse.map<ExperienceModel>((row) => ExperienceModel.fromJson(row)).toList();
        setState(() {
          _experiencesList = fetchedList;
        });
      }
    } catch (e) {
      debugPrint('Error fetching experiences from Supabase: $e');
    }

    // 4. Fetch education
    try {
      final eduResponse = await client.from('education').select().order('created_at', ascending: true);
      if (eduResponse.isNotEmpty) {
        final fetchedList = eduResponse.map<EducationModel>((row) => EducationModel.fromJson(row)).toList();
        setState(() {
          _educationList = fetchedList;
        });
      }
    } catch (e) {
      debugPrint('Error fetching education from Supabase: $e');
    }

    // 5. Fetch certifications
    try {
      final certsResponse = await client.from('certifications').select().order('created_at', ascending: true);
      if (certsResponse.isNotEmpty) {
        final fetchedList = certsResponse.map<CertificationModel>((row) => CertificationModel.fromJson(row)).toList();
        setState(() {
          _certificationsList = fetchedList;
        });
      }
    } catch (e) {
      debugPrint('Error fetching certifications from Supabase: $e');
    }
  }

  // Scroll listener to automatically update active header highlights
  void _onScrollListener() {
    if (!mounted) return;

    final double offset = _scrollController.offset + 250; // Offset cushion
    int newActiveIndex = 0;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final keyContext = _sectionKeys[i].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        final scrollOffset = position.dy + _scrollController.offset;

        if (offset >= scrollOffset) {
          newActiveIndex = i;
        }
      }
    }

    context.read<NavigationCubit>().setSection(newActiveIndex);
  }

  // Programmatic smooth scroll to specific section
  void _scrollToSection(int index) {
    final keyContext = _sectionKeys[index].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // Helper to open links safely
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch $urlString: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: !isDesktop ? _buildDrawer() : null,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _buildGlassAppBar(isDesktop),
      ),
      body: Stack(
        children: [
          // Base Deep Obsidian Gradient Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.darkBgGradient,
            ),
          ),

          // Subtle Glowing Cosmic Nebula Orbs (Background Art)
          Positioned(
            top: -150,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryCyan.withValues(alpha: 0.08),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCyan.withValues(alpha: 0.05),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.3,
            left: -200,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPurple.withValues(alpha: 0.06),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.04),
                    blurRadius: 180,
                    spreadRadius: 80,
                  ),
                ],
              ),
            ),
          ),

          // Main Single Scrollable Viewport
          Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // 1. Home Section
                  _buildSectionWrapper(
                    key: _homeKey,
                    child: _buildHeroSection(isDesktop, isTablet, size),
                  ),

                  // 2. About Section
                  _buildSectionWrapper(
                    key: _aboutKey,
                    child: _buildAboutSection(isDesktop, size),
                  ),

                  // 3. Works Section
                  _buildSectionWrapper(
                    key: _worksKey,
                    child: _buildWorksSection(isDesktop, isTablet),
                  ),

                  // 4. Education Section
                  _buildSectionWrapper(
                    key: _educationKey,
                    child: _buildEducationSection(isDesktop),
                  ),

                  // 5. Experience Section
                  _buildSectionWrapper(
                    key: _experienceKey,
                    child: _buildExperienceSection(isDesktop),
                  ),

                  // 6. Certifications Section
                  _buildSectionWrapper(
                    key: _certificationsKey,
                    child: _buildCertificationsSection(isDesktop, isTablet),
                  ),

                  // 7. Contact Section
                  _buildSectionWrapper(
                    key: _contactKey,
                    child: _buildContactSection(isDesktop, size),
                  ),

                  // Footer
                  _buildFooter(isDesktop),
                ],
              ),
            ),
          ),

          // Lightbox Certification popup overlay
          if (_selectedCert != null) _buildCertLightboxOverlay(),
        ],
      ),
    );
  }

  // Wrapper for structural section padding
  Widget _buildSectionWrapper({required Key key, required Widget child}) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
      alignment: Alignment.center,
      child: child,
    );
  }

  // Section header typography component
  Widget _buildSectionTitle(
    String title,
    String subtitle, {
    bool center = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: center
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Container(
              width: 16,
              height: 4,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.accentTextGradient.createShader(bounds),
              child: Text(
                subtitle.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Responsive Frosted Glass Navigation Bar
  Widget _buildGlassAppBar(bool isDesktop) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return GlassContainer(
          borderRadius: 0,
          blur: 15.0,
          color: Colors.black.withValues(alpha: 0.3),
          borderColor: AppColors.glassBorder.withValues(alpha: 0.08),
          borderWidth: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const SizedBox(width: 8),
                // Glowing initials badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: AppColors.cyanGlowShadow(blur: 10, opacity: 0.2),
                  ),
                  child: Text(
                    'MIB',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _profileName,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            actions: isDesktop
                ? [
                    ...List.generate(_sectionNames.length, (index) {
                      final isActive = state.activeIndex == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: TextButton(
                          onPressed: () => _scrollToSection(index),
                          style: TextButton.styleFrom(
                            foregroundColor: isActive
                                ? AppColors.primaryCyan
                                : AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 18,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _sectionNames[index],
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: isActive ? 24 : 0,
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 24),
                  ]
                : [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: AppColors.textPrimary,
                          size: 28,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
          ),
        );
      },
    );
  }

  // Sidebar Mobile/Tablet Drawer
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.bgDarkStart,
      elevation: 16,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      'MIB',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _profileName,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: _sectionNames.length,
                    itemBuilder: (context, index) {
                      final isActive = state.activeIndex == index;
                      return ListTile(
                        leading: Icon(
                          _getSectionIcon(index),
                          color: isActive
                              ? AppColors.primaryCyan
                              : AppColors.textSecondary,
                        ),
                        title: Text(
                          _sectionNames[index],
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isActive
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                        selected: isActive,
                        selectedTileColor: AppColors.primaryCyan.withValues(
                          alpha: 0.05,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _scrollToSection(index);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSectionIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.person_rounded;
      case 2:
        return Icons.dashboard_rounded;
      case 3:
        return Icons.school_rounded;
      case 4:
        return Icons.work_rounded;
      case 5:
        return Icons.verified_rounded;
      case 6:
        return Icons.mail_rounded;
      default:
        return Icons.circle;
    }
  }

  // 1. HOME / HERO SECTION
  Widget _buildHeroSection(bool isDesktop, bool isTablet, Size size) {
    final textTheme = Theme.of(context).textTheme;

    final heroText = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Professional greeting tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryCyan.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.primaryCyan.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt, color: AppColors.primaryCyan, size: 16),
              const SizedBox(width: 6),
              Text(
                'Available for Senior Flutter Roles',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryCyan,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Title heading
        Text(
          'Hi, I am',
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            _profileName,
            style: GoogleFonts.outfit(
              fontSize: isDesktop ? 68 : (isTablet ? 52 : 40),
              fontWeight: FontWeight.w900,
              height: 1.1,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Subtitle typing description
        Text(
          _profileTagline,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        // Narrative pitch
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            _profileIntro,
            style: textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 36),
        // Glowing CTA Buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ElevatedButton(
              onPressed: () => _scrollToSection(6), // Navigate to Contact
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                backgroundColor: AppColors.primaryCyan,
                shadowColor: AppColors.primaryCyan,
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Let\'s Connect',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.black,
                    size: 18,
                  ),
                ],
              ),
            ),
            // Outlined CV Resume button (Uses a hosted/safe fallback URL to prevent local 404s!)
            OutlinedButton(
              onPressed: () => _launchUrl(
                'https://mishaqbutt.github.io/portfolio/assets/images/resume/my_cv.pdf',
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                side: const BorderSide(
                  color: AppColors.glassBorder,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.textPrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Download Resume',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        // Social Media Link icons
        Row(
          children: [
            _buildSocialIcon(
              FontAwesomeIcons.github,
              _profileGithubUrl,
            ),
            _buildSocialIcon(
              FontAwesomeIcons.linkedin,
              _profileLinkedinUrl,
            ),
            _buildSocialIcon(
              FontAwesomeIcons.envelope,
              _profileGmailUrl,
            ),
          ],
        ),
      ],
    );

    // Decorative floating right graphic (interactive glass profile shell)
    final heroGraphic = Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer revolving tech orbit visual
          Container(
            width: isDesktop ? 380 : 300,
            height: isDesktop ? 380 : 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryCyan.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
          ),
          Container(
            width: isDesktop ? 320 : 250,
            height: isDesktop ? 320 : 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryPurple.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
          ),

          // Central Glassmorphic Avatar Shell
          GlassContainer(
            width: isDesktop ? 260 : 210,
            height: isDesktop ? 260 : 210,
            borderRadius: 130,
            blur: 15,
            color: AppColors.glassBg,
            borderColor: AppColors.primaryCyan.withValues(alpha: 0.2),
            boxShadows: AppColors.cyanGlowShadow(blur: 30, opacity: 0.15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.flutter,
                    size: 64,
                    color: AppColors.primaryCyan,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'FLUTTER SENIOR',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '5+ Years Exp',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating orbit badge 1 (Android)
          _buildFloatingBadge(
            icon: Icons.android_rounded,
            color: Colors.greenAccent,
            top: 20,
            right: 0,
            sizeMultiplier: isDesktop ? 1.0 : 0.8,
          ),
          // Floating orbit badge 2 (Apple)
          _buildFloatingBadge(
            icon: Icons.apple_rounded,
            color: Colors.white,
            bottom: 40,
            left: -10,
            sizeMultiplier: isDesktop ? 1.0 : 0.8,
          ),
          // Floating orbit badge 3 (Web/Desktop)
          _buildFloatingBadge(
            icon: Icons.computer_rounded,
            color: AppColors.primaryCyan,
            bottom: 10,
            right: 20,
            sizeMultiplier: isDesktop ? 1.0 : 0.8,
          ),
        ],
      ),
    );

    return Container(
      constraints: BoxConstraints(minHeight: size.height - 120),
      width: isDesktop ? 1100 : double.infinity,
      child: isDesktop
          ? Row(
              children: [
                Expanded(flex: 3, child: heroText),
                Expanded(flex: 2, child: heroGraphic),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                heroGraphic,
                const SizedBox(height: 50),
                heroText,
              ],
            ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.glassBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
      ),
    );
  }

  Widget _buildFloatingBadge({
    required IconData icon,
    required Color color,
    double? top,
    double? bottom,
    double? left,
    double? right,
    double sizeMultiplier = 1.0,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 54 * sizeMultiplier,
        height: 54 * sizeMultiplier,
        decoration: BoxDecoration(
          color: AppColors.bgDarkEnd,
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 24 * sizeMultiplier),
      ),
    );
  }

  // 2. ABOUT SECTION
  Widget _buildAboutSection(bool isDesktop, Size size) {
    final textTheme = Theme.of(context).textTheme;

    final aboutNarrative = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('My Background', 'About Me'),
        Text(
          _profileAboutText,
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        Text(
          'Core Skill Set Focus',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildSkillChipsGrid(),
      ],
    );

    // Sidebar Info Panel
    final aboutStats = GlassContainer(
      padding: const EdgeInsets.all(28.0),
      borderRadius: 20,
      borderColor: AppColors.glassBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Information Index',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Degree', 'MS Computer Science'),
          _buildInfoRow('Alma Mater', 'FAST-NUCES Lahore'),
          _buildInfoRow('Specialization', 'AI & Machine Learning'),
          _buildInfoRow('Core Tech', 'Flutter / iOS / Android / Desktop'),
          _buildInfoRow('Location', _profileAddress),
          _buildInfoRow('Experience', '5+ Productive Years'),
          const Divider(height: 32),
          // Dynamic stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBlock('11', 'Apps Deployed'),
              _buildStatBlock('5+', 'Years Exp'),
              _buildStatBlock('1st', 'Univ Rank'),
            ],
          ),
        ],
      ),
    );

    return SizedBox(
      width: isDesktop ? 1100 : double.infinity,
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: aboutNarrative),
                const SizedBox(width: 50),
                Expanded(flex: 2, child: aboutStats),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                aboutNarrative,
                const SizedBox(height: 40),
                aboutStats,
              ],
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBlock(String num, String label) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            num,
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChipsGrid() {
    final skills = [
      'Flutter Web & Apps',
      'Dart Programming',
      'Cubit / BLoC State',
      'State Management (Provider / GetX)',
      'Native Channels (Swift / Kotlin)',
      'Rest APIs & JSON Serialization',
      'Real-time WebSockets',
      'RevenueCat Subscriptions',
      'Stripe Integration',
      'Firebase Ecosystem',
      'Local Storage (SQLite / Hive / Secure)',
      'Custom Timber Timelines / POS Printer ESC Drivers',
      'Blockchain API (Web3Dart)',
      'NLP & Machine Learning Models',
      'Google Play & Apple Store Deployment',
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.glassBorder.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Text(
            skill,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        );
      }).toList(),
    );
  }

  // 3. WORKS / PROJECTS SECTION
  Widget _buildWorksSection(bool isDesktop, bool isTablet) {
    final filteredProjects = _projectsList.where((p) {
      if (_selectedCategory == ProjectCategory.all) return true;
      return p.category == _selectedCategory;
    }).toList();

    return SizedBox(
      width: isDesktop ? 1100 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Productive Portfolio', 'My Works'),

          // Categorization tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryTab('All Showcase', ProjectCategory.all),
                _buildCategoryTab('Mobile Apps', ProjectCategory.mobile),
                _buildCategoryTab('Desktop Apps', ProjectCategory.desktop),
                _buildCategoryTab(
                  'Cross-Platform',
                  ProjectCategory.crossPlatform,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Grid layout
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProjects.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isDesktop ? 0.8 : 0.85,
            ),
            itemBuilder: (context, index) {
              final project = filteredProjects[index];
              return _buildProjectCard(project);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title, ProjectCategory category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ChoiceChip(
        label: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.black : AppColors.textPrimary,
          ),
        ),
        selected: isSelected,
        onSelected: (val) {
          if (val) {
            setState(() {
              _selectedCategory = category;
            });
          }
        },
        selectedColor: AppColors.primaryCyan,
        backgroundColor: AppColors.glassBg,
        checkmarkColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : AppColors.glassBorder.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsScreen(project: project),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GlassContainer(
          borderRadius: 16,
          borderColor: AppColors.glassBorder,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project numerical index
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    project.id,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryCyan.withValues(alpha: 0.5),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        project.category,
                      ).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getCategoryColor(
                          project.category,
                        ).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _getCategoryName(project.category),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getCategoryColor(project.category),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Project titles
              Text(
                project.title,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                project.subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              // Project Description
              Expanded(
                child: Text(
                  project.description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Technologies used in cards
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: project.technologies.take(3).map((tech) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tech,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Divider(height: 24),
              // Dynamic Project interactive items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    project.role ?? 'Developer',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Row(
                    children: [
                      if (project.gitHubUrl != null)
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.github, size: 16),
                          color: AppColors.textPrimary,
                          tooltip: 'Github Source',
                          onPressed: () => _launchUrl(project.gitHubUrl!),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      if (project.liveUrl != null)
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.squareArrowUpRight,
                            size: 16,
                          ),
                          color: AppColors.primaryCyan,
                          tooltip: 'Live App Link',
                          onPressed: () => _launchUrl(project.liveUrl!),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(ProjectCategory cat) {
    switch (cat) {
      case ProjectCategory.mobile:
        return Colors.greenAccent;
      case ProjectCategory.desktop:
        return AppColors.primaryCyan;
      case ProjectCategory.crossPlatform:
        return AppColors.primaryPurple;
      default:
        return Colors.white;
    }
  }

  String _getCategoryName(ProjectCategory cat) {
    switch (cat) {
      case ProjectCategory.mobile:
        return 'MOBILE';
      case ProjectCategory.desktop:
        return 'DESKTOP';
      case ProjectCategory.crossPlatform:
        return 'CROSSPLAT';
      default:
        return 'APP';
    }
  }

  // 4. EDUCATION TIMELINE
  Widget _buildEducationSection(bool isDesktop) {
    final eduList = _educationList;

    return SizedBox(
      width: isDesktop ? 900 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Academic Matrix', 'Education'),

          // Vertical timelines for academic entries
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: eduList.length,
            itemBuilder: (context, index) {
              final edu = eduList[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Side vertical tracking nodes
                  Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.bgDarkStart,
                          border: Border.all(
                            color: AppColors.primaryCyan,
                            width: 3,
                          ),
                          boxShadow: AppColors.cyanGlowShadow(
                            blur: 8,
                            opacity: 0.3,
                          ),
                        ),
                      ),
                      if (index != eduList.length - 1)
                        Container(
                          width: 2,
                          height: 200,
                          color: AppColors.primaryCyan.withValues(alpha: 0.2),
                        ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Degree content cards
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: GlassContainer(
                        padding: const EdgeInsets.all(24.0),
                        borderColor: AppColors.glassBorder,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              edu.dateRange,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryCyan,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              edu.degree,
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              edu.institution,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (edu.grade != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.emeraldGreen.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.emeraldGreen.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  edu.grade!,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.emeraldGreen,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Text(
                              'Major Courses & Work Focus:',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: edu.courses.map((course) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.03),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    course,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // 5. EXPERIENCE TIMELINE
  Widget _buildExperienceSection(bool isDesktop) {
    final expList = _experiencesList;

    return SizedBox(
      width: isDesktop ? 900 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Career Trajectory', 'Experience'),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expList.length,
            itemBuilder: (context, index) {
              final exp = expList[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.bgDarkStart,
                          border: Border.all(
                            color: AppColors.primaryPurple,
                            width: 3,
                          ),
                          boxShadow: AppColors.purpleGlowShadow(
                            blur: 8,
                            opacity: 0.3,
                          ),
                        ),
                      ),
                      if (index != expList.length - 1)
                        Container(
                          width: 2,
                          height: 380,
                          color: AppColors.primaryPurple.withValues(alpha: 0.2),
                        ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: GlassContainer(
                        padding: const EdgeInsets.all(24.0),
                        borderColor: AppColors.glassBorder,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  exp.dateRange,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPurple.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      exp.company,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryPurple,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              exp.title,
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Divider(height: 24),
                            // Bullet points details
                            ...exp.bullets.map((bullet) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 6.0),
                                      child: Icon(
                                        Icons.circle_rounded,
                                        color: AppColors.primaryCyan,
                                        size: 6,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        bullet,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 16),
                            // Tags
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: exp.tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.03),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.glassBorder.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // 6. CERTIFICATIONS SECTION
  Widget _buildCertificationsSection(bool isDesktop, bool isTablet) {
    final certs = _certificationsList;

    return SizedBox(
      width: isDesktop ? 1100 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Verified Credentials', 'Certifications'),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: certs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final cert = certs[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedCert = cert;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: GlassContainer(
                  borderRadius: 16,
                  borderColor: AppColors.glassBorder,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amberOrange.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.amberOrange.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Text(
                              cert.category,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.amberOrange,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.verified_rounded,
                            color: AppColors.amberOrange,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        cert.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Issuer: ${cert.issuer}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Click to Expand',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.primaryCyan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.open_in_full_rounded,
                            color: AppColors.primaryCyan,
                            size: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Certification Lightbox full-screen popup
  Widget _buildCertLightboxOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCert = null;
          });
        },
        child: Container(
          color: Colors.black.withValues(alpha: 0.75),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent click propagation to close background
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  maxHeight: 400,
                ),
                child: GlassContainer(
                  borderRadius: 24,
                  borderColor: AppColors.primaryCyan.withValues(alpha: 0.3),
                  boxShadows: AppColors.cyanGlowShadow(blur: 40, opacity: 0.3),
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amberOrange.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _selectedCert!.category.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.amberOrange,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textPrimary,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedCert = null;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedCert!.title,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Credential Issuer: ${_selectedCert!.issuer}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryCyan,
                        ),
                      ),
                      const Divider(height: 32),
                      Text(
                        _selectedCert!.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCert = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.08,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Close View',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 7. CONTACT SECTION
  Widget _buildContactSection(bool isDesktop, Size size) {
    final textTheme = Theme.of(context).textTheme;

    final contactInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Inquiry Interface', 'Contact Me'),
        Text(
          'Have a senior engineering opportunity or a challenging project in mind? Drop me a line! I will analyze your requirements and get back to you with custom architecture designs.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 36),

        // Custom contact coordinate info details
        _buildContactDetailBlock(
          Icons.email_outlined,
          'Email Address',
          _profileEmail,
          _profileGmailUrl,
        ),
        _buildContactDetailBlock(
          Icons.location_on_outlined,
          'Operational Center',
          _profileAddress,
          null,
        ),
        _buildContactDetailBlock(
          Icons.phone_android_outlined,
          'Connect Direct',
          _profilePhone,
          'tel:${_profilePhone.replaceAll(" ", "")}',
        ),
      ],
    );

    // Frosted Form card
    final contactFormCard = GlassContainer(
      padding: const EdgeInsets.all(32.0),
      borderRadius: 20,
      borderColor: AppColors.glassBorder,
      child: BlocConsumer<ContactCubit, ContactState>(
        listener: (context, state) {
          if (state is ContactSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.emeraldGreen,
              ),
            );
            // Reset text controllers
            _nameController.clear();
            _emailController.clear();
            _subjectController.clear();
            _messageController.clear();
          } else if (state is ContactFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ContactSuccess) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.emeraldGreen,
                  size: 72,
                ),
                const SizedBox(height: 20),
                Text(
                  'Message Deposited!',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your message was securely sent. I will review and get in touch with you shortly.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<ContactCubit>().reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Send Another Message'),
                ),
              ],
            );
          }

          final isLoading = state is ContactSubmitting;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Submission Portal',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildContactTextField(
                  controller: _nameController,
                  label: 'Your Name',
                  icon: Icons.person_outline_rounded,
                  enabled: !isLoading,
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildContactTextField(
                  controller: _emailController,
                  label: 'Your Email',
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Required';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(val.trim())) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildContactTextField(
                  controller: _subjectController,
                  label: 'Subject',
                  icon: Icons.topic_outlined,
                  enabled: !isLoading,
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildContactTextField(
                  controller: _messageController,
                  label: 'Detailed Message',
                  icon: Icons.chat_bubble_outline_rounded,
                  maxLines: 4,
                  enabled: !isLoading,
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ContactCubit>().sendMessage(
                                name: _nameController.text,
                                email: _emailController.text,
                                subject: _subjectController.text,
                                message: _messageController.text,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCyan,
                      disabledBackgroundColor: AppColors.primaryCyan.withValues(
                        alpha: 0.3,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Send Message',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.send_rounded,
                                color: Colors.black,
                                size: 16,
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return SizedBox(
      width: isDesktop ? 1100 : double.infinity,
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: contactInfo),
                const SizedBox(width: 50),
                Expanded(flex: 2, child: contactFormCard),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                contactInfo,
                const SizedBox(height: 40),
                contactFormCard,
              ],
            ),
    );
  }

  Widget _buildContactDetailBlock(
    IconData icon,
    String label,
    String value,
    String? link,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: InkWell(
        onTap: link != null ? () => _launchUrl(link) : null,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryCyan.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryCyan.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(icon, color: AppColors.primaryCyan, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      validator: validator,
      style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primaryCyan,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  // FOOTER Visual component
  Widget _buildFooter(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: Colors.black.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                FontAwesomeIcons.github,
                _profileGithubUrl,
              ),
              _buildSocialIcon(
                FontAwesomeIcons.linkedin,
                _profileLinkedinUrl,
              ),
              _buildSocialIcon(
                FontAwesomeIcons.envelope,
                _profileGmailUrl,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '© 2026 $_profileName. All Rights Reserved.',
            style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Built with ',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              const Icon(
                Icons.favorite_rounded,
                color: Colors.redAccent,
                size: 10,
              ),
              Text(
                ' using Flutter Web',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminPanelScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'SYSTEM CORE ACCESS',
                style: GoogleFonts.outfit(
                  color: AppColors.primaryPurple.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
