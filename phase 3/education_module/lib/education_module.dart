library education_module;

import 'package:flutter/material.dart';
import 'core/theme/edu_theme.dart';
import 'features/home/edu_home_screen.dart';

export 'models/models.dart';
export 'services/edu_storage_service.dart';
export 'features/home/edu_home_screen.dart';

class AdyutaEducationApp extends StatelessWidget {
  const AdyutaEducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adyuta E-Learn',
      theme: EduTheme.theme,
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
      home: const EduHomeScreen(),
    );
  }
}
