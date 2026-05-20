import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mib_portfolio/core/theme/app_theme.dart';
import 'package:mib_portfolio/features/contact/cubit/contact_cubit.dart';
import 'package:mib_portfolio/features/home/cubit/navigation_cubit.dart';
import 'package:mib_portfolio/features/home/presentation/portfolio_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dynamic safe Supabase initialization.
  // If credentials are not set up or invalid, catches exception and runs in Sandbox Mode!
  try {
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://godjxddrsqezggyuvnqh.supabase.co'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'sb_publishable_w0MVejCG10BEiSOjHhhFnQ_4aUwh-fY'),
    );
  } catch (e) {
    debugPrint('Supabase initialization deferred: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider<ContactCubit>(
          create: (context) => ContactCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'M. Ishaq Butt | Senior Flutter & Cross-Platform Engineer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const PortfolioHomePage(),
      ),
    );
  }
}
