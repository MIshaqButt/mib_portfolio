import 'dart:io';

void main(List<String> arguments) async {
  final bool isSilent = arguments.contains('--silent');

  print('==================================================');
  print('    🚀 FLUTTER PORTFOLIO PROJECT SHEET GENERATOR   ');
  print('==================================================\n');

  final Directory currentDir = Directory.current;
  final File pubspecFile = File('${currentDir.path}/pubspec.yaml');

  if (!await pubspecFile.exists()) {
    print('❌ Error: pubspec.yaml not found in this directory.');
    print('Please run this command from the root of your Flutter project.');
    exit(1);
  }

  print('📦 Found Flutter project at: ${currentDir.path}');
  print('🔍 Analyzing pubspec dependencies...\n');

  final pubspecContent = await pubspecFile.readAsString();
  final String projectName = _parseYamlValue(pubspecContent, 'name');
  final String rawDescription = _parseYamlValue(pubspecContent, 'description');
  final String formattedName = projectName.replaceAll('_', ' ').toUpperCase();

  // Automatically extract tech chips based on dependencies
  final List<String> techList = ['Flutter', 'Dart'];
  if (pubspecContent.contains('flutter_bloc:')) techList.add('BLoC Architecture');
  if (pubspecContent.contains('flutter_cubit:')) techList.add('Cubit State');
  if (pubspecContent.contains('provider:')) techList.add('Provider Pattern');
  if (pubspecContent.contains('get:')) techList.add('GetX Framework');
  if (pubspecContent.contains('firebase_core:')) techList.add('Firebase Suite');
  if (pubspecContent.contains('supabase_flutter:')) techList.add('Supabase Backend');
  if (pubspecContent.contains('dio:')) techList.add('Dio REST Services');
  if (pubspecContent.contains('http:')) techList.add('HTTP Networking');
  if (pubspecContent.contains('hive:') || pubspecContent.contains('hive_flutter:')) techList.add('Hive Local Cache');
  if (pubspecContent.contains('isar:')) techList.add('Isar Database');
  if (pubspecContent.contains('sqflite:')) techList.add('SQLite Cache');
  if (pubspecContent.contains('google_maps_flutter:')) techList.add('Google Maps SDK');

  String role = 'Senior Flutter Developer';
  String appStore = '';
  String playStore = '';
  String github = '';
  String screenshotCsv = '';

  if (isSilent) {
    print('⚡ Running in silent mode! Skipping all interactive prompts...');
  } else {
    // Prompt the user for details
    role = _promptUser('💼 Enter your Developer Role (e.g., Senior Flutter Developer):', 'Senior Flutter Developer');
    appStore = _promptUser('🍎 Enter Apple App Store URL (or press Enter for none):', '');
    playStore = _promptUser('🤖 Enter Google Play Store URL (or press Enter for none):', '');
    github = _promptUser('🌐 Enter GitHub Source URL (or press Enter for none):', '');
    screenshotCsv = _promptUser('📸 Enter Screenshot URLs (comma-separated, or press Enter for default placeholders):', '');
  }

  final List<String> screenshots = screenshotCsv.isNotEmpty
      ? screenshotCsv.split(',').map((s) => s.trim()).toList()
      : [
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?auto=format&fit=crop&w=800&q=80'
        ];

  print('\n📝 Generating premium HTML showcase sheet...');

  final String htmlOutput = _generateHtml(
    projectName: formattedName,
    description: rawDescription.isNotEmpty ? rawDescription : 'A high-performance cross-platform application engineered with Flutter.',
    role: role,
    techStack: techList,
    appStore: appStore,
    playStore: playStore,
    githubUrl: github,
    screenshots: screenshots,
  );

  final File outputFile = File('${currentDir.path}/project_details.html');
  await outputFile.writeAsString(htmlOutput);

  print('\n✨ SUCCESS! Beautiful showcase sheet created successfully!');
  print('📍 Saved as: ${outputFile.path}');
  print('==================================================');
  print('Now upload this "project_details.html" file through your Admin CMS Panel!');
}

String _promptUser(String prompt, String defaultValue) {
  stdout.write('$prompt ');
  if (defaultValue.isNotEmpty) {
    stdout.write('[$defaultValue]: ');
  }
  final input = stdin.readLineSync()?.trim();
  if (input == null || input.isEmpty) {
    return defaultValue;
  }
  return input;
}

String _parseYamlValue(String yaml, String key) {
  final regExp = RegExp('^$key:\\s*[\'\"]?([^\n\'\"]+)[\'\"]?', multiLine: true);
  final match = regExp.firstMatch(yaml);
  return match != null ? match.group(1)?.trim() ?? '' : '';
}

String _generateHtml({
  required String projectName,
  required String description,
  required String role,
  required List<String> techStack,
  required String appStore,
  required String playStore,
  required String githubUrl,
  required List<String> screenshots,
}) {
  final String techChips = techStack.map((tech) => '<span class="badge">$tech</span>').join('\n');
  final String gallery = screenshots.map((url) => '<img src="$url" alt="Screenshot" />').join('\n');

  final String appStoreBtn = appStore.isNotEmpty
      ? '<a href="$appStore" target="_blank" class="store-button apple"><i class="fab fa-apple"></i> App Store</a>'
      : '';

  final String playStoreBtn = playStore.isNotEmpty
      ? '<a href="$playStore" target="_blank" class="store-button google"><i class="fab fa-google-play"></i> Play Store</a>'
      : '';

  final String githubBtn = githubUrl.isNotEmpty
      ? '<a href="$githubUrl" target="_blank" class="store-button github"><i class="fab fa-github"></i> Source Code</a>'
      : '';

  return '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$projectName - Project Details</title>
  <!-- Outfit Google Font -->
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  
  <style>
    :root {
      --primary-cyan: #00F2FE;
      --primary-purple: #4FACFE;
      --bg-dark: #0A0E17;
      --card-bg: rgba(255, 255, 255, 0.03);
      --border-color: rgba(255, 255, 255, 0.08);
      --text-main: #FFFFFF;
      --text-muted: #A0AEC0;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      background-color: var(--bg-dark);
      font-family: 'Inter', sans-serif;
      color: var(--text-main);
      padding: 24px;
      line-height: 1.6;
    }

    .container {
      max-width: 900px;
      margin: 0 auto;
      background: var(--card-bg);
      border: 1px solid var(--border-color);
      border-radius: 16px;
      padding: 32px;
      backdrop-filter: blur(10px);
    }

    header {
      margin-bottom: 24px;
      border-bottom: 1px solid var(--border-color);
      padding-bottom: 24px;
    }

    h1 {
      font-family: 'Outfit', sans-serif;
      font-size: 36px;
      font-weight: 800;
      letter-spacing: -0.5px;
      background: linear-gradient(135deg, var(--primary-cyan), var(--primary-purple));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 8px;
    }

    .role-tag {
      display: inline-block;
      font-family: 'Outfit', sans-serif;
      font-weight: 600;
      color: var(--primary-cyan);
      font-size: 14px;
      letter-spacing: 1px;
      text-transform: uppercase;
      margin-bottom: 16px;
    }

    p.description {
      font-size: 15px;
      color: var(--text-muted);
      margin-bottom: 24px;
    }

    .section-title {
      font-family: 'Outfit', sans-serif;
      font-size: 18px;
      font-weight: 600;
      color: #FFFFFF;
      margin-bottom: 12px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .tech-stack {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-bottom: 32px;
    }

    .badge {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid var(--border-color);
      color: var(--text-main);
      padding: 6px 12px;
      border-radius: 8px;
      font-size: 12px;
      font-weight: 600;
    }

    .button-group {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-bottom: 32px;
    }

    .store-button {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 12px 20px;
      border-radius: 8px;
      font-family: 'Outfit', sans-serif;
      font-size: 14px;
      font-weight: 600;
      text-decoration: none;
      color: #FFFFFF;
      transition: all 0.3s ease;
      border: 1px solid var(--border-color);
    }

    .store-button i {
      margin-right: 8px;
      font-size: 16px;
    }

    .store-button.apple {
      background: #111;
      border-color: rgba(255, 255, 255, 0.2);
    }

    .store-button.google {
      background: #0F5132;
      border-color: rgba(255, 255, 255, 0.2);
    }

    .store-button.github {
      background: rgba(255, 255, 255, 0.08);
    }

    .store-button:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 242, 254, 0.2);
    }

    .gallery-title {
      border-top: 1px solid var(--border-color);
      padding-top: 24px;
      margin-bottom: 16px;
    }

    .gallery {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 16px;
    }

    .gallery img {
      width: 100%;
      height: 380px;
      object-fit: cover;
      border-radius: 12px;
      border: 1px solid var(--border-color);
      transition: transform 0.3s ease;
    }

    .gallery img:hover {
      transform: scale(1.02);
    }

    @media (max-width: 600px) {
      .container {
        padding: 20px;
      }
      h1 {
        font-size: 28px;
      }
      .gallery img {
        height: 300px;
      }
    }
  </style>
</head>
<body>

  <div class="container">
    <header>
      <div class="role-tag">$role</div>
      <h1>$projectName</h1>
    </header>

    <p class="description">$description</p>

    <div class="section-title">Core Technology Stack</div>
    <div class="tech-stack">
      $techChips
    </div>

    <div class="section-title">Platform & Code Coordinates</div>
    <div class="button-group">
      $appStoreBtn
      $playStoreBtn
      $githubBtn
    </div>

    <div class="section-title gallery-title">Product Showcase Gallery</div>
    <div class="gallery">
      $gallery
    </div>
  </div>

</body>
</html>
''';
}
