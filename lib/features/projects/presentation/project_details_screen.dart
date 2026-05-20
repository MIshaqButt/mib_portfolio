import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../models/project_model.dart';
import 'html_view.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

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
    final textTheme = Theme.of(context).textTheme;

    // Supabase HTML URL constructor
    // Pointing dynamically to Supabase storage bucket: project-details
    // If not supplied, falls back to a beautiful public mock detail sheet hosted on a static endpoint for demo purposes.
    final String supabaseBucketUrl =
        'https://mishaqbutt.github.io/portfolio/assets/html/demo_project.html'; // Default Fallback

    // We construct the URL dynamically if the project has a custom supabase project reference, otherwise uses a beautiful fallback
    final String htmlUrl =
        project.liveUrl != null && project.liveUrl!.endsWith('.html')
        ? project.liveUrl!
        : supabaseBucketUrl;

    // View ID must be unique per platform view
    final String platformViewId = 'iframe-project-${project.id}';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.glassBorder, width: 1),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Project Diagnostics',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Base Obsidian Gradient Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.darkBgGradient,
            ),
          ),

          // Cosmic Nebula background glow
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPurple.withValues(alpha: 0.06),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.04),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // Main Responsive Panel Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Section: Project description panel
                        Expanded(
                          flex: 2,
                          child: _buildDetailsSidebar(context, textTheme),
                        ),
                        const SizedBox(width: 24),
                        // Right Section: Full Interactive IFrame HTML view
                        Expanded(
                          flex: 3,
                          child: _buildIFrameView(htmlUrl, platformViewId),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildDetailsSidebar(context, textTheme),
                          const SizedBox(height: 24),
                          // Give standard responsive height on mobile iframe views
                          SizedBox(
                            height: 600,
                            child: _buildIFrameView(htmlUrl, platformViewId),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSidebar(BuildContext context, TextTheme textTheme) {
    return GlassContainer(
      padding: const EdgeInsets.all(32.0),
      borderColor: AppColors.glassBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryCyan.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'PROJECT ID: ${project.id}',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryCyan,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              if (project.role != null)
                Text(
                  project.role!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            project.title,
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            project.subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryPurple,
            ),
          ),
          const Divider(height: 40),
          Expanded(
            flex: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Executive Abstract',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    project.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Technology Diagnostics',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.technologies.map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.glassBorder.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          tech,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Divider(height: 40),
          // Interactive Action coordinate items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (project.gitHubUrl != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _launchUrl(project.gitHubUrl!),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(color: AppColors.glassBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.github,
                          color: AppColors.textPrimary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Source Code',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (project.gitHubUrl != null && project.liveUrl != null)
                const SizedBox(width: 16),
              if (project.liveUrl != null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _launchUrl(project.liveUrl!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCyan,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bolt, color: Colors.black, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Inspect Live',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIFrameView(String url, String platformViewId) {
    return GlassContainer(
      padding: const EdgeInsets.all(6.0),
      borderColor: AppColors.glassBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Frame address simulation bar (Looks extremely high-end!)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Window controls dot
                Row(
                  children: List.generate(3, (i) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == 0
                            ? Colors.redAccent
                            : (i == 1
                                  ? Colors.amberAccent
                                  : Colors.greenAccent),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Supabase Dynamic Frame: $url',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable iframe element container
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                child: HtmlView(
                  viewId: platformViewId,
                  url: url,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
