import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mib_portfolio/core/constants/app_colors.dart';
import 'package:mib_portfolio/core/widgets/glass_container.dart';
import 'package:mib_portfolio/features/home/presentation/file_picker.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoggedIn = false;
  bool _isSandboxMode = true;
  bool _isLoading = false;

  // Login Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 1. Profile / Contact Form Controllers
  final _profileFormKey = GlobalKey<FormState>();
  final TextEditingController _profileNameController = TextEditingController(text: 'M. Ishaq Butt');
  final TextEditingController _profileTaglineController = TextEditingController(text: 'Lead Mobile Engineer');
  final TextEditingController _profileIntroController = TextEditingController(text: 'Crafting high-performance cross-platform experiences with Flutter, Dart, AI, and secure backend solutions.');
  final TextEditingController _profileAboutTextController = TextEditingController(text: 'I am a highly dedicated and solutions-oriented Mobile Application Developer with a rich history of building and publishing flagship software packages.');
  final TextEditingController _profileEmailController = TextEditingController(text: 'mishaqbutt98@gmail.com');
  final TextEditingController _profilePhoneController = TextEditingController(text: '+92 340 6206965');
  final TextEditingController _profileAddressController = TextEditingController(text: 'Lahore, Punjab, Pakistan');
  final TextEditingController _profileGithubController = TextEditingController(text: 'https://github.com/mishaqbutt');
  final TextEditingController _profileLinkedinController = TextEditingController(text: 'https://linkedin.com/in/m-ishaq-butt-715b70211');
  final TextEditingController _profileGmailController = TextEditingController(text: 'mailto:mishaqbutt98@gmail.com');

  // 2. Project Form Controllers
  final _projectFormKey = GlobalKey<FormState>();
  final TextEditingController _projIdController = TextEditingController();
  final TextEditingController _projTitleController = TextEditingController();
  final TextEditingController _projSubtitleController = TextEditingController();
  final TextEditingController _projDescController = TextEditingController();
  final TextEditingController _projRoleController = TextEditingController();
  final TextEditingController _projGithubController = TextEditingController();
  final TextEditingController _projLiveController = TextEditingController();
  final TextEditingController _projTechController = TextEditingController(text: 'Flutter, Dart, Cubit');
  
  PickedFileResult? _selectedHtmlReport;
  String _selectedCategory = 'Mobile';

  // 3. Experience Form Controllers
  final _expFormKey = GlobalKey<FormState>();
  final TextEditingController _expCompanyController = TextEditingController();
  final TextEditingController _expRoleController = TextEditingController();
  final TextEditingController _expDateRangeController = TextEditingController(text: 'APR 2025 - PRESENT');
  final TextEditingController _expBulletsController = TextEditingController();
  final TextEditingController _expTagsController = TextEditingController(text: 'Flutter, Cubit, REST API');

  // 4. Education Form Controllers
  final _eduFormKey = GlobalKey<FormState>();
  final TextEditingController _eduInstitutionController = TextEditingController();
  final TextEditingController _eduDegreeController = TextEditingController();
  final TextEditingController _eduDateRangeController = TextEditingController(text: '2021 - 2023');
  final TextEditingController _eduCoursesController = TextEditingController();
  final TextEditingController _eduGradeController = TextEditingController();

  // 5. Certifications Form Controllers
  final _certFormKey = GlobalKey<FormState>();
  final TextEditingController _certTitleController = TextEditingController();
  final TextEditingController _certCategoryController = TextEditingController(text: 'Certification');
  final TextEditingController _certIssuerController = TextEditingController();
  final TextEditingController _certDescController = TextEditingController();

  // 6. Inbox Messages Parameters
  List<Map<String, dynamic>> _messagesList = [];
  bool _loadingMessages = false;

  // 7. Timeline Edit Parameters
  String? _editingExpId;
  String? _editingEduId;
  String? _editingCertId;
  List<Map<String, dynamic>> _expList = [];
  List<Map<String, dynamic>> _eduList = [];
  List<Map<String, dynamic>> _certList = [];
  bool _loadingLists = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _checkSupabaseInitialization();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    
    _profileNameController.dispose();
    _profileTaglineController.dispose();
    _profileIntroController.dispose();
    _profileAboutTextController.dispose();
    _profileEmailController.dispose();
    _profilePhoneController.dispose();
    _profileAddressController.dispose();
    _profileGithubController.dispose();
    _profileLinkedinController.dispose();
    _profileGmailController.dispose();

    _projIdController.dispose();
    _projTitleController.dispose();
    _projSubtitleController.dispose();
    _projDescController.dispose();
    _projRoleController.dispose();
    _projGithubController.dispose();
    _projLiveController.dispose();
    _projTechController.dispose();

    _expCompanyController.dispose();
    _expRoleController.dispose();
    _expDateRangeController.dispose();
    _expBulletsController.dispose();
    _expTagsController.dispose();

    _eduInstitutionController.dispose();
    _eduDegreeController.dispose();
    _eduDateRangeController.dispose();
    _eduCoursesController.dispose();
    _eduGradeController.dispose();

    _certTitleController.dispose();
    _certCategoryController.dispose();
    _certIssuerController.dispose();
    _certDescController.dispose();
    super.dispose();
  }

  void _checkSupabaseInitialization() {
    try {
      final _ = Supabase.instance.client;
      setState(() {
        _isSandboxMode = false;
      });
    } catch (e) {
      setState(() {
        _isSandboxMode = true;
      });
    }
  }

  Future<void> _fetchAndPrepopulateProfile() async {
    if (_isSandboxMode) return;
    try {
      final client = Supabase.instance.client;
      final configResponse = await client.from('portfolio_config').select().eq('id', 1).maybeSingle();
      if (configResponse != null) {
        setState(() {
          _profileNameController.text = configResponse['name']?.toString() ?? _profileNameController.text;
          _profileTaglineController.text = configResponse['tagline']?.toString() ?? _profileTaglineController.text;
          _profileIntroController.text = configResponse['intro']?.toString() ?? _profileIntroController.text;
          _profileAboutTextController.text = configResponse['about_text']?.toString() ?? _profileAboutTextController.text;
          _profileEmailController.text = configResponse['email']?.toString() ?? _profileEmailController.text;
          _profilePhoneController.text = configResponse['phone']?.toString() ?? _profilePhoneController.text;
          _profileAddressController.text = configResponse['address']?.toString() ?? _profileAddressController.text;
          _profileGithubController.text = configResponse['github_url']?.toString() ?? _profileGithubController.text;
          _profileLinkedinController.text = configResponse['linkedin_url']?.toString() ?? _profileLinkedinController.text;
          _profileGmailController.text = configResponse['gmail_url']?.toString() ?? _profileGmailController.text;
        });
      }
    } catch (e) {
      debugPrint('Error prepopulating profile controllers: $e');
    }
  }

  Future<void> _fetchInboxMessages() async {
    if (_isSandboxMode) return;
    setState(() => _loadingMessages = true);
    try {
      final client = Supabase.instance.client;
      final response = await client.from('messages').select().order('created_at', ascending: false);
      if (response != null && response is List) {
        setState(() {
          _messagesList = List<Map<String, dynamic>>.from(response);
          _loadingMessages = false;
        });
      }
    } catch (e) {
      setState(() => _loadingMessages = false);
      debugPrint('Error fetching inbox messages: $e');
    }
  }

  Future<void> _fetchLists() async {
    if (_isSandboxMode) return;
    setState(() => _loadingLists = true);
    try {
      final client = Supabase.instance.client;
      final exps = await client.from('experiences').select().order('date_range', ascending: false);
      final edus = await client.from('education').select().order('date_range', ascending: false);
      final certs = await client.from('certifications').select();
      
      setState(() {
        _expList = List<Map<String, dynamic>>.from(exps);
        _eduList = List<Map<String, dynamic>>.from(edus);
        _certList = List<Map<String, dynamic>>.from(certs);
        _loadingLists = false;
      });
    } catch (e) {
      setState(() => _loadingLists = false);
      debugPrint('Error fetching timeline lists: $e');
    }
  }

  Future<void> _deleteTimelineItem(String table, String id) async {
    if (_isSandboxMode) return;
    setState(() => _loadingLists = true);
    try {
      final client = Supabase.instance.client;
      await client.from(table).delete().eq('id', id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item deleted successfully.')));
      await _fetchLists();
    } catch (e) {
      setState(() => _loadingLists = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting item: $e')));
    }
  }

  Future<void> _deleteInboxMessage(String id) async {
    if (_isSandboxMode) return;
    setState(() => _loadingMessages = true);
    try {
      final client = Supabase.instance.client;
      await client.from('messages').delete().eq('id', id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message deleted successfully from server.')),
      );
      await _fetchInboxMessages();
    } catch (e) {
      setState(() => _loadingMessages = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting message: $e')),
      );
    }
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    if (_isSandboxMode) {
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() {
        _isLoggedIn = true;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully (SANDBOX DEMO MODE)')),
      );
    } else {
      try {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
        await _fetchAndPrepopulateProfile();
        await _fetchInboxMessages();
        await _fetchLists();
        setState(() {
          _isLoggedIn = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully authenticated administrative credentials!')),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Auth error: ${e.toString()}')),
        );
      }
    }
  }

  // 1. SAVE PROFILE CONFIGURATION
  Future<void> _saveProfileConfig() async {
    if (!_profileFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    if (_isSandboxMode) {
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully simulated profile update! (SANDBOX)')),
      );
    } else {
      try {
        final client = Supabase.instance.client;
        await client.from('portfolio_config').upsert({
          'id': 1,
          'name': _profileNameController.text.trim(),
          'tagline': _profileTaglineController.text.trim(),
          'intro': _profileIntroController.text.trim(),
          'about_text': _profileAboutTextController.text.trim(),
          'email': _profileEmailController.text.trim(),
          'phone': _profilePhoneController.text.trim(),
          'address': _profileAddressController.text.trim(),
          'github_url': _profileGithubController.text.trim(),
          'linkedin_url': _profileLinkedinController.text.trim(),
          'gmail_url': _profileGmailController.text.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile configuration and contact data updated successfully!')),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile config: $e')),
        );
      }
    }
  }

  // 2. SAVE SHOWCASE PROJECT
  Future<void> _handleHtmlUpload() async {
    final result = await PortfolioFilePicker.pickHtmlReport();
    if (result != null) {
      setState(() {
        _selectedHtmlReport = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected HTML document: ${result.filename} (${result.bytes.length} bytes)')),
      );
    }
  }

  Future<void> _saveProject() async {
    if (!_projectFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final String projId = _projIdController.text.trim();
    final String title = _projTitleController.text.trim();
    final String subtitle = _projSubtitleController.text.trim();
    final String desc = _projDescController.text.trim();
    final String role = _projRoleController.text.trim();
    final String github = _projGithubController.text.trim();
    final String live = _projLiveController.text.trim();
    final List<String> techList = _projTechController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (_isSandboxMode) {
      await Future.delayed(const Duration(milliseconds: 1200));
      setState(() => _isLoading = false);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.bgDarkStart,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.glassBorder)),
          title: Text('Diagnostics Saved (Demo)', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text(
            'In Sandbox Mode, this simulates successfully:\n\n'
            '1. Creating project record inside PostgreSQL projects table.\n'
            '2. Uploading "${_selectedHtmlReport?.filename ?? 'No file selected'}" report inside the project-details storage bucket.\n'
            '3. Saving the public Storage url.',
            style: GoogleFonts.inter(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearProjectForm();
              },
              child: const Text('Confirm', style: TextStyle(color: AppColors.primaryCyan)),
            ),
          ],
        ),
      );
    } else {
      try {
        String? finalHtmlUrl;

        if (_selectedHtmlReport != null) {
          final client = Supabase.instance.client;
          final String storagePath = 'project-details/$projId-${_selectedHtmlReport!.filename}';
          
          await client.storage.from('project-details').uploadBinary(
            storagePath,
            _selectedHtmlReport!.bytes,
            fileOptions: const FileOptions(contentType: 'text/html', upsert: true),
          );

          finalHtmlUrl = client.storage.from('project-details').getPublicUrl(storagePath);
        }

        await Supabase.instance.client.from('projects').insert({
          'id': projId,
          'title': title,
          'subtitle': subtitle,
          'description': desc,
          'role': role,
          'github_url': github.isNotEmpty ? github : null,
          'live_url': finalHtmlUrl ?? (live.isNotEmpty ? live : null),
          'technologies': techList,
          'category': _selectedCategory.toLowerCase(),
        });

        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully deployed project to Supabase!')),
        );
        _clearProjectForm();
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Supabase insert error: ${e.toString()}')),
        );
      }
    }
  }

  void _clearProjectForm() {
    _projIdController.clear();
    _projTitleController.clear();
    _projSubtitleController.clear();
    _projDescController.clear();
    _projRoleController.clear();
    _projGithubController.clear();
    _projLiveController.clear();
    _projTechController.text = 'Flutter, Dart, Cubit';
    setState(() {
      _selectedHtmlReport = null;
    });
  }

  // 3. TIMELINE EXPERIENCES FORM
  Future<void> _saveExperience() async {
    if (!_expFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    if (_isSandboxMode) {
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulated saving Experience! (SANDBOX)')),
      );
      _clearExperienceForm();
    } else {
      try {
        final client = Supabase.instance.client;
        final String uid = _editingExpId ?? 'exp-${DateTime.now().millisecondsSinceEpoch}';
        
        await client.from('experiences').upsert({
          'id': uid,
          'company': _expCompanyController.text.trim(),
          'title': _expRoleController.text.trim(),
          'date_range': _expDateRangeController.text.trim(),
          'bullets': _expBulletsController.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
          'tags': _expTagsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        });

        setState(() {
          _isLoading = false;
          _editingExpId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully saved timeline experience!')),
        );
        _clearExperienceForm();
        await _fetchLists();
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Supabase experience upsert error: $e')),
        );
      }
    }
  }

  void _clearExperienceForm() {
    _expCompanyController.clear();
    _expRoleController.clear();
    _expDateRangeController.text = 'APR 2025 - PRESENT';
    _expBulletsController.clear();
    _expTagsController.text = 'Flutter, Cubit, REST API';
    _editingExpId = null;
  }

  // 4. SAVE EDUCATION
  Future<void> _saveEducation() async {
    if (!_eduFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    if (_isSandboxMode) {
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulated saving Education credential! (SANDBOX)')),
      );
      _clearEducationForm();
    } else {
      try {
        final client = Supabase.instance.client;
        final String uid = _editingEduId ?? 'edu-${DateTime.now().millisecondsSinceEpoch}';

        await client.from('education').upsert({
          'id': uid,
          'institution': _eduInstitutionController.text.trim(),
          'degree': _eduDegreeController.text.trim(),
          'date_range': _eduDateRangeController.text.trim(),
          'courses': _eduCoursesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
          'grade': _eduGradeController.text.trim().isNotEmpty ? _eduGradeController.text.trim() : null,
        });

        setState(() {
          _isLoading = false;
          _editingEduId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully deployed academic degree to Supabase!')),
        );
        _clearEducationForm();
        await _fetchLists();
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Supabase education upsert error: $e')),
        );
      }
    }
  }

  void _clearEducationForm() {
    _eduInstitutionController.clear();
    _eduDegreeController.clear();
    _eduDateRangeController.text = '2021 - 2023';
    _eduCoursesController.clear();
    _eduGradeController.clear();
    _editingEduId = null;
  }

  // 5. SAVE CERTIFICATION
  Future<void> _saveCertification() async {
    if (!_certFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    if (_isSandboxMode) {
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulated saving Certification record! (SANDBOX)')),
      );
      _clearCertificationForm();
    } else {
      try {
        final client = Supabase.instance.client;
        final String uid = _editingCertId ?? 'cert-${DateTime.now().millisecondsSinceEpoch}';

        await client.from('certifications').upsert({
          'id': uid,
          'title': _certTitleController.text.trim(),
          'category': _certCategoryController.text.trim(),
          'issuer': _certIssuerController.text.trim(),
          'description': _certDescController.text.trim(),
        });

        setState(() {
          _isLoading = false;
          _editingCertId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully deployed certification to Supabase!')),
        );
        _clearCertificationForm();
        await _fetchLists();
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Supabase certification upsert error: $e')),
        );
      }
    }
  }

  void _clearCertificationForm() {
    _certTitleController.clear();
    _certCategoryController.text = 'Certification';
    _certIssuerController.clear();
    _certDescController.clear();
    _editingCertId = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.darkBgGradient,
            ),
          ),
          
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryCyan.withOpacity(0.04),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCyan.withOpacity(0.03),
                    blurRadius: 100,
                    spreadRadius: 50,
                  )
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 350),
                    crossFadeState: _isLoggedIn
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: _buildLoginCard(isDesktop),
                    secondChild: _buildDashboardCMS(isDesktop),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(bool isDesktop) {
    return GlassContainer(
      width: 480,
      padding: const EdgeInsets.all(40.0),
      borderColor: AppColors.glassBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SYSTEM CONTROL',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                  letterSpacing: 2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _isSandboxMode ? Colors.amberAccent.withOpacity(0.1) : Colors.greenAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _isSandboxMode ? Colors.amberAccent.withOpacity(0.3) : Colors.greenAccent.withOpacity(0.3)),
                ),
                child: Text(
                  _isSandboxMode ? 'SANDBOX MODE' : 'SUPABASE CONNECTED',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: _isSandboxMode ? Colors.amberAccent : Colors.greenAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Access Panel',
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Secure credential check required to modify portfolio parameters.',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
          ),
          const Divider(height: 48),
          
          Text('EMAIL ADDRESS', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'admin@mishaqbutt.com',
              filled: true,
              fillColor: Colors.black.withOpacity(0.2),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.glassBorder)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryCyan)),
            ),
          ),
          const SizedBox(height: 24),
          
          Text('PASSWORD SECRET', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '••••••••••••',
              filled: true,
              fillColor: Colors.black.withOpacity(0.2),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.glassBorder)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryCyan)),
            ),
          ),
          const SizedBox(height: 36),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCyan,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                  : Text('Authenticate system', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel & exit', style: TextStyle(color: AppColors.textSecondary)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDashboardCMS(bool isDesktop) {
    return GlassContainer(
      width: isDesktop ? 1100 : double.infinity,
      padding: const EdgeInsets.all(32.0),
      borderColor: AppColors.glassBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PORTFOLIO CONTROL CENTER',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryCyan,
                      letterSpacing: 2,
                ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Administrative Dashboard',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isLoggedIn = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.glassBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Lock system', style: TextStyle(color: Colors.white70)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.08),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Exit CMS'),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 40),
          
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.primaryCyan,
            labelColor: AppColors.primaryCyan,
            unselectedLabelColor: Colors.white70,
            onTap: (index) {
              if (index == 5) {
                _fetchInboxMessages();
              }
            },
            tabs: const [
              Tab(text: 'PROFILE & LINKS'),
              Tab(text: 'PROJECTS'),
              Tab(text: 'EXPERIENCE'),
              Tab(text: 'EDUCATION'),
              Tab(text: 'CERTIFICATIONS'),
              Tab(text: 'INBOX MESSAGES'),
            ],
          ),
          const SizedBox(height: 32),
          
          SizedBox(
            height: 650,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileForm(),
                _buildProjectForm(),
                _buildExperienceForm(),
                _buildEducationForm(),
                _buildCertificationForm(),
                _buildInboxMessagesView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1. PROFILE & LINKS CONFIG FORM
  Widget _buildProfileForm() {
    return Form(
      key: _profileFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFormField('FULL NAME', 'e.g. M. Ishaq Butt', _profileNameController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('TAGLINE / SUBTITLE', 'e.g. Lead Mobile Engineer', _profileTaglineController),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField('HERO INTRO PITCH', 'Crafting high-performance cross-platform experiences...', _profileIntroController, maxLines: 2),
            const SizedBox(height: 20),
            _buildFormField('ABOUT BIOGRAPHY TEXT', 'I am a highly dedicated and solutions-oriented developer...', _profileAboutTextController, maxLines: 3),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildFormField('CONTACT EMAIL', 'ishaq.info1@gmail.com', _profileEmailController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('CONTACT PHONE', '+92 300 1234567', _profilePhoneController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('OPERATIONAL LOCATION', 'Lahore, Pakistan', _profileAddressController),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildFormField('GITHUB PROFILE URL', 'https://github.com/mishaqbutt', _profileGithubController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('LINKEDIN PROFILE URL', 'https://linkedin.com/in/mishaqbutt', _profileLinkedinController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('GMAIL / MAILTO URL', 'mailto:ishaq.info1@gmail.com', _profileGmailController),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfileConfig,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : Text('Deploy profile and links to Database', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 2. PROJECTS FORM
  Widget _buildProjectForm() {
    return Form(
      key: _projectFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFormField('PROJECT UNIQUE ID', 'e.g. parentflow', _projIdController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('PROJECT TITLE', 'e.g. ParentFlow', _projTitleController),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildFormField('SUBTITLE / TAGLINE', 'e.g. Real-time Parent monitoring', _projSubtitleController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('DEVELOPER ROLE', 'e.g. Senior Mobile Lead', _projRoleController),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField('PROJECT DESCRIPTION ABSTRACT', 'Detail the technical specifications, milestones, and stack results...', _projDescController, maxLines: 3),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildFormField('GITHUB SOURCE URL (OPTIONAL)', 'https://github.com/...', _projGithubController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('LIVE PRODUCT URL (OPTIONAL)', 'https://apps.apple.com/...', _projLiveController),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TECHNOLOGY STACKS (COMMA SEPARATED)', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _projTechController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Flutter, Dart, Firebase, Stripe',
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.glassBorder)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PROJECT CATEGORY', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          dropdownColor: AppColors.bgDarkStart,
                          underline: const SizedBox(),
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white),
                          items: <String>['Mobile', 'Desktop', 'CrossPlatform']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            GlassContainer(
              padding: const EdgeInsets.all(24),
              borderColor: AppColors.primaryPurple.withOpacity(0.2),
              color: AppColors.primaryPurple.withOpacity(0.04),
              child: Row(
                children: [
                  const Icon(Icons.html_rounded, size: 40, color: AppColors.primaryPurple),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Project HTML Report Upload', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(
                          _selectedHtmlReport == null 
                              ? 'Optionally upload a detailed HTML report file that will be dynamically displayed via iFrame when clicked.' 
                              : 'Ready to sync HTML details: ${_selectedHtmlReport!.filename}',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _handleHtmlUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(_selectedHtmlReport == null ? 'Select HTML File' : 'Change File'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : Text('Deploy project record to Database', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 3. TIMELINE EXPERIENCES FORM
  Widget _buildExperienceForm() {
    return Form(
      key: _expFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFormField('COMPANY NAME', 'e.g. Sparkix Technologies', _expCompanyController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('ROLE TITLE', 'e.g. Senior Flutter Developer', _expRoleController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('DATE RANGE / DURATION', 'e.g. APR 2025 - PRESENT', _expDateRangeController),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField(
              'RESPONSIBILITIES BULLETS (ONE PER LINE)', 
              'Engineered alterego AI app.\nIntegrated ChatGPT billing pipelines.\nPublished dynamic Swift modules.', 
              _expBulletsController, 
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            _buildFormField('TECHNOLOGY CHIPS (COMMA SEPARATED)', 'Flutter, Cubit, Blockchain, Native iOS', _expTagsController),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveExperience,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : Text(_editingExpId != null ? 'Update Experience Record' : 'Save Experience to Database', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            if (_editingExpId != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: TextButton(
                    onPressed: _clearExperienceForm,
                    child: const Text('Cancel Edit', style: TextStyle(color: Colors.redAccent)),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            _buildTimelineList(
              items: _expList,
              titleKey: 'title',
              subtitleKey: 'company',
              onEdit: (item) {
                setState(() => _editingExpId = item['id']);
                _expCompanyController.text = item['company'] ?? '';
                _expRoleController.text = item['title'] ?? '';
                _expDateRangeController.text = item['date_range'] ?? '';
                _expBulletsController.text = (item['bullets'] as List?)?.join('\n') ?? '';
                _expTagsController.text = (item['tags'] as List?)?.join(', ') ?? '';
              },
              onDelete: (item) => _deleteTimelineItem('experiences', item['id']),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 4. ACADEMIC DEGREES FORM
  Widget _buildEducationForm() {
    return Form(
      key: _eduFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFormField('DEGREE TITLE', 'e.g. MS Computer Science', _eduDegreeController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('INSTITUTION / UNIVERSITY', 'e.g. FAST NUCES Lahore', _eduInstitutionController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('DATE RANGE', 'e.g. SEP 2021 - DEC 2023', _eduDateRangeController),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField('HIGHLIGHT COURSES (COMMA SEPARATED)', 'Advanced Deep Learning, Natural Language Processing, Machine Learning', _eduCoursesController),
            const SizedBox(height: 20),
            _buildFormField('GRADE / MERIT POSITION (OPTIONAL)', 'e.g. CGPA: 3.54 (Secured 1st Position Merit Award)', _eduGradeController),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveEducation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : Text(_editingEduId != null ? 'Update Education Record' : 'Save Academic degree to Database', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            if (_editingEduId != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: TextButton(
                    onPressed: _clearEducationForm,
                    child: const Text('Cancel Edit', style: TextStyle(color: Colors.redAccent)),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            _buildTimelineList(
              items: _eduList,
              titleKey: 'degree',
              subtitleKey: 'institution',
              onEdit: (item) {
                setState(() => _editingEduId = item['id']);
                _eduInstitutionController.text = item['institution'] ?? '';
                _eduDegreeController.text = item['degree'] ?? '';
                _eduDateRangeController.text = item['date_range'] ?? '';
                _eduCoursesController.text = (item['courses'] as List?)?.join(', ') ?? '';
                _eduGradeController.text = item['grade'] ?? '';
              },
              onDelete: (item) => _deleteTimelineItem('education', item['id']),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 5. CERTIFICATIONS FORM
  Widget _buildCertificationForm() {
    return Form(
      key: _certFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFormField('CERTIFICATION NAME', 'e.g. 1st Position Merit Certificate', _certTitleController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('ISSUER ORGANIZATION', 'e.g. Minhaj University Lahore', _certIssuerController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField('CATEGORY (e.g. Degree, Experience, Certification)', 'e.g. Merit Award', _certCategoryController),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField('SHORT DESCRIPTION', 'Official post-graduate award recognition issued for department ranking.', _certDescController, maxLines: 3),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveCertification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : Text(_editingCertId != null ? 'Update Certification Record' : 'Save Certification to Database', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            if (_editingCertId != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: TextButton(
                    onPressed: _clearCertificationForm,
                    child: const Text('Cancel Edit', style: TextStyle(color: Colors.redAccent)),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            _buildTimelineList(
              items: _certList,
              titleKey: 'title',
              subtitleKey: 'issuer',
              onEdit: (item) {
                setState(() => _editingCertId = item['id']);
                _certTitleController.text = item['title'] ?? '';
                _certCategoryController.text = item['category'] ?? '';
                _certIssuerController.text = item['issuer'] ?? '';
                _certDescController.text = item['description'] ?? '';
              },
              onDelete: (item) => _deleteTimelineItem('certifications', item['id']),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 6. INBOX MESSAGES VIEWING TAB
  Widget _buildInboxMessagesView() {
    if (_loadingMessages) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryCyan,
        ),
      );
    }

    if (_isSandboxMode) {
      return Center(
        child: GlassContainer(
          padding: const EdgeInsets.all(40),
          borderColor: AppColors.glassBorder,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mark_email_unread_rounded, size: 48, color: Colors.amberAccent),
              const SizedBox(height: 16),
              Text('Inbox Messages (Sandbox Mode)', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                'In demo mode, database inbox selects are simulated.\nConnect your Supabase key to unlock visitor message panels.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    if (_messagesList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mail_outline_rounded, size: 60, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'No Messages Found',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              'When a client sends you an inquiry from the landing page, it will display here!',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _messagesList.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final msg = _messagesList[index];
        final String name = msg['name'] ?? 'Unknown Sender';
        final String email = msg['email'] ?? '';
        final String subject = msg['subject'] ?? 'No Subject';
        final String body = msg['message'] ?? '';
        final String dateStr = msg['created_at'] != null 
            ? DateTime.parse(msg['created_at']).toLocal().toString().substring(0, 16)
            : 'Just now';

        return GlassContainer(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          padding: const EdgeInsets.all(20),
          borderColor: AppColors.glassBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryCyan,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '<$email>',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                    onPressed: () => _deleteInboxMessage(msg['id']),
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.glassBorder),
              Text(
                body,
                style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.calendar_today_rounded, color: AppColors.textMuted, size: 10),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          validator: (value) => value == null || value.trim().isEmpty ? 'Required field.' : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.black.withOpacity(0.2),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.glassBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryCyan)),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineList({
    required List<Map<String, dynamic>> items,
    required String titleKey,
    required String subtitleKey,
    required Function(Map<String, dynamic>) onEdit,
    required Function(Map<String, dynamic>) onDelete,
  }) {
    if (_loadingLists) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryCyan));
    }
    
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No existing items found. Add one above!', style: GoogleFonts.inter(color: AppColors.textMuted)),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GlassContainer(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          borderColor: AppColors.glassBorder,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item[titleKey] ?? 'Unknown', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(item[subtitleKey] ?? '', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: AppColors.primaryCyan, size: 20),
                    onPressed: () => onEdit(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                    onPressed: () => onDelete(item),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

