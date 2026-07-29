library governance_module;

import 'package:flutter/material.dart';
import 'core/theme/gov_theme.dart';
import 'features/home/gov_home_screen.dart';

export 'models/models.dart';
export 'data/gov_data.dart';
export 'services/gov_storage_service.dart';
export 'features/home/gov_home_screen.dart';
export 'features/schemes/scheme_detail_screen.dart';
export 'features/laws/law_detail_screen.dart';
export 'features/vault/doc_vault_screen.dart';

class AdyutaGovernanceApp extends StatelessWidget {
  const AdyutaGovernanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adyuta SchemeSaathi & Citizen Rights',
      debugShowCheckedModeBanner: false,
      theme: GovTheme.theme,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            image: DecorationImage(
              image: AssetImage('assets/images/app_bg.png'),
              fit: BoxFit.cover,
              opacity: 0.22,
            ),
          ),
          child: child,
        );
      },
      home: const GovHomeScreen(),
    );
  }
}
