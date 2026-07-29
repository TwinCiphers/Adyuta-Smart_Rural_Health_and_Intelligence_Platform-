import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/agri_theme.dart';
import 'kissan_xml_viewer_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'General Agriculture',
    'Gov & Advisory',
    'Crop Management',
    'Market & Economics',
    'Research Study',
    'Data & Statistics',
    'Modern Techniques',
    'Weather & Disaster',
    'Digital Agri',
    'Education & Training',
  ];

  final List<Map<String, dynamic>> _articles = const [
    {
      'title': 'Comprehensive Indian Agriculture Manual & Best Practices',
      'author': 'National Agricultural Extension Board / ICAR',
      'readTime': '45 min read • XML Manual',
      'likes': '890',
      'comments': '145',
      'category': 'General Agriculture',
      'icon': Icons.menu_book,
      'color': Color(0xFFE0F2FE),
      'iconColor': Color(0xFF0284C7),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/AGRICULTURE.xml',
      'fileType': 'xml',
      'description': 'The definitive handbook covering agronomy, soil fertility management, organic fertilization, irrigation systems, crop rotation, and sustainable farming methodologies.',
    },
    {
      'title': 'Kisan Call Centre (KCC) & Knowledge Management System Guide',
      'author': 'Dept. of Agriculture, Karnataka & Ministry of Agri',
      'readTime': '20 min read • XML Guide',
      'likes': '512',
      'comments': '89',
      'category': 'Gov & Advisory',
      'icon': Icons.support_agent,
      'color': Color(0xFFE8F5EE),
      'iconColor': Color(0xFF1E6B3B),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2017-18_KCC_Knowledge_System_Karnataka.xml',
      'fileType': 'xml',
      'description': 'Detailed operational guidelines and impact assessment of Kisan Call Centres (KCC), Kisan Knowledge Management System (KKMS), Farmer Portal, and mKisan SMS advisories in Karnataka.',
    },
    {
      'title': 'Impact of PM-KISAN Scheme on Farm Income in Uttar Pradesh',
      'author': 'Ministry of Agriculture & Farmers Welfare Research',
      'readTime': '14 min read • XML Report',
      'likes': '640',
      'comments': '112',
      'category': 'Gov & Advisory',
      'icon': Icons.account_balance,
      'color': Color(0xFFFEF3C7),
      'iconColor': Color(0xFFD97706),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2022-23_PM_KISAN_Impact_UP.xml',
      'fileType': 'xml',
      'description': 'Empirical evaluation of direct income support (₹6,000/year) under PM-KISAN, analyzing input purchase capacity and agricultural productivity gains among UP farmers.',
    },
    {
      'title': 'NFSM Package of Practices for Pulses, Wheat & Rice',
      'author': 'National Food Security Mission (NFSM)',
      'readTime': '28 min read • XML Package',
      'likes': '610',
      'comments': '83',
      'category': 'Crop Management',
      'icon': Icons.workspace_premium,
      'color': Color(0xFFF3E8FF),
      'iconColor': Color(0xFF9333EA),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/NFSM_Package.xml',
      'fileType': 'xml',
      'description': 'Approved package of practices under NFSM to enhance productivity of rice, wheat, commercial crops, and pulses through improved seed varieties and micronutrient application.',
    },
    {
      'title': 'Appendix 1: Standard Operating Protocols for Crop Production',
      'author': 'Agricultural Extension Division',
      'readTime': '12 min read • XML Protocol',
      'likes': '475',
      'comments': '67',
      'category': 'Crop Management',
      'icon': Icons.eco,
      'color': Color(0xFFE8F5EE),
      'iconColor': Color(0xFF1E6B3B),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/Appendix_1_Crop_Production.xml',
      'fileType': 'xml',
      'description': 'Concise reference guide detailing seed rate, spacing, fertilizer dosage, weeding schedules, and harvesting timing for major Kharif and Rabi crops.',
    },
    {
      'title': 'FAOSTAT Global & National Agricultural Dataset (2026 Update)',
      'author': 'Food and Agriculture Organization (UN FAO)',
      'readTime': '4,250 Rows • CSV Dataset',
      'likes': '720',
      'comments': '104',
      'category': 'Data & Statistics',
      'icon': Icons.table_chart,
      'color': Color(0xFFFEF3C7),
      'iconColor': Color(0xFFD97706),
      'filePath': 'assets/Kissan_knowledge_base/FAOSTAT_data_en_7-27-2026.csv',
      'fileType': 'csv',
      'description': 'Comprehensive CSV tabular dataset featuring crop production quantities, harvested area, yield per hectare, and import/export trade statistics for India from FAOSTAT.',
    },
    {
      'title': 'Agricultural Statistics & Index Report (ASI - November 2022)',
      'author': 'Directorate of Economics and Statistics (DES)',
      'readTime': '30 min read • XML Bulletin',
      'likes': '215',
      'comments': '28',
      'category': 'Data & Statistics',
      'icon': Icons.analytics,
      'color': Color(0xFFE0F2FE),
      'iconColor': Color(0xFF0284C7),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/ASI-Novemebr-2022.xml',
      'fileType': 'xml',
      'description': 'Monthly statistical bulletin detailing wholesale price indices (WPI), crop production estimates, fertilizer consumption, and rainfall distribution data across Indian states.',
    },
    {
      'title': 'Farmers\' Participation in India\'s Agricultural Futures Markets',
      'author': 'National Institute of Agricultural Marketing (NIAM)',
      'readTime': '25 min read • XML Analysis',
      'likes': '410',
      'comments': '56',
      'category': 'Market & Economics',
      'icon': Icons.trending_up,
      'color': Color(0xFFF3E8FF),
      'iconColor': Color(0xFF9333EA),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2019-20_Farmers_Futures_Markets.xml',
      'fileType': 'xml',
      'description': 'Analytical report on commodity derivatives, price risk management, and hedging strategies for Indian farmers and FPOs in agricultural futures markets.',
    },
    {
      'title': 'Farm Profitability & Market Imperfections in Bihar Agriculture',
      'author': 'Agro-Economic Research Centre, Bihar',
      'readTime': '22 min read • XML Study',
      'likes': '385',
      'comments': '48',
      'category': 'Market & Economics',
      'icon': Icons.account_balance_wallet,
      'color': Color(0xFFE8F5EE),
      'iconColor': Color(0xFF1E6B3B),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2020-21_Farm_Profitability_Bihar.xml',
      'fileType': 'xml',
      'description': 'In-depth analysis of agricultural marketing bottlenecks, middleman margins, APMC price realization, and policy recommendations to boost farm profitability in Bihar.',
    },
    {
      'title': 'Emerging Agricultural Technologies & Precision Farming (2025)',
      'author': 'AgriTech Futures Forum & ICAR AI Lab',
      'readTime': '12 min read • XML Review',
      'likes': '820',
      'comments': '134',
      'category': 'Modern Techniques',
      'icon': Icons.precision_manufacturing,
      'color': Color(0xFFFEF3C7),
      'iconColor': Color(0xFFD97706),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/technologies-E-2025.xml',
      'fileType': 'xml',
      'description': 'Cutting-edge review of drone spraying, IoT soil sensors, AI disease detection, smart irrigation controllers, and robotic harvesting technologies for 2025 and beyond.',
    },
    {
      'title': 'National Weather Contingency & Disaster Mitigation Crop Plan',
      'author': 'CRIDA & ICAR Climate Resilient Agriculture Team',
      'readTime': '35 min read • XML Plan',
      'likes': '530',
      'comments': '94',
      'category': 'Weather & Disaster',
      'icon': Icons.thunderstorm,
      'color': Color(0xFFE0F2FE),
      'iconColor': Color(0xFF0284C7),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/Contingency.xml',
      'fileType': 'xml',
      'description': 'Actionable contingency crop planning for monsoon delay, drought, flash floods, heatwaves, and emergency pest outbreaks across various agro-climatic zones.',
    },
    {
      'title': 'Impact of COVID-19 on Sugarcane Farmers in Haryana & Uttarakhand',
      'author': 'ICAR & Agricultural Economics Research Centre',
      'readTime': '18 min read • XML Study',
      'likes': '280',
      'comments': '32',
      'category': 'Crop Analysis',
      'icon': Icons.grass,
      'color': Color(0xFFF3E8FF),
      'iconColor': Color(0xFF9333EA),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2020-21_Covid_Impact_Sugarcane.xml',
      'fileType': 'xml',
      'description': 'An assessment of supply chain disruptions, labor availability, sugar mill payments, and resilience measures adopted by sugarcane growers during the pandemic.',
    },
    {
      'title': 'Agricultural Research & Farmer Welfare Initiatives in Rural India',
      'author': 'Dr. Ritu Nagdev, Senior Agricultural Researcher',
      'readTime': '15 min read • XML Study',
      'likes': '342',
      'comments': '45',
      'category': 'Research Study',
      'icon': Icons.science,
      'color': Color(0xFFE8F5EE),
      'iconColor': Color(0xFF1E6B3B),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/1_Ritu_Nagdev.xml',
      'fileType': 'xml',
      'description': 'A comprehensive study on agricultural research, farmer welfare initiatives, and socio-economic development in rural farming communities.',
    },
    {
      'title': 'Annual Agronomic Research Report on Crop Management',
      'author': 'ICAR Agronomy Research Directorate',
      'readTime': '16 min read • XML Report',
      'likes': '195',
      'comments': '22',
      'category': 'Research Study',
      'icon': Icons.biotech,
      'color': Color(0xFFFEF3C7),
      'iconColor': Color(0xFFD97706),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/crop-management-AR-2011-12_1.xml',
      'fileType': 'xml',
      'description': 'Detailed trial findings on integrated nutrient management, conservation agriculture, weed control efficacy, and cropping systems research.',
    },
    {
      'title': 'Guidelines for Kisan Mobile Apps & Digital m-Governance',
      'author': 'Digital India & Kisan E-Gov Taskforce',
      'readTime': '10 min read • XML Guidelines',
      'likes': '310',
      'comments': '41',
      'category': 'Digital Agri',
      'icon': Icons.phone_android,
      'color': Color(0xFFE0F2FE),
      'iconColor': Color(0xFF0284C7),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/Mobile-APP-Guidelines-1.xml',
      'fileType': 'xml',
      'description': 'Technical and user interface guidelines for developing agricultural mobile applications, USSD services, and voice-enabled farmer advisories.',
    },
    {
      'title': 'HESC 101: Fundamentals of Agricultural Extension Education',
      'author': 'State Agricultural Universities (SAU) Course Manual',
      'readTime': '40 min read • XML Manual',
      'likes': '450',
      'comments': '59',
      'category': 'Education & Training',
      'icon': Icons.school,
      'color': Color(0xFFF3E8FF),
      'iconColor': Color(0xFF9333EA),
      'filePath': 'assets/Kissan_knowledge_base/PDF_to_XML_Results/hesc101.xml',
      'fileType': 'xml',
      'description': 'Academic curriculum manual on rural sociology, agricultural extension communication methods, technology transfer models, and farmer training programs.',
    },
  ];

  List<Map<String, dynamic>> get _filteredArticles {
    if (_selectedCategory == 'All') return _articles;
    return _articles.where((a) => a['category'] == _selectedCategory).toList();
  }

  void _showDocumentDetails(BuildContext context, Map<String, dynamic> doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: doc['color'] as Color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              doc['category'],
                              style: GoogleFonts.outfit(
                                color: doc['iconColor'] as Color,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AgriTheme.lightGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              doc['fileType'].toString().toUpperCase(),
                              style: GoogleFonts.outfit(
                                color: AgriTheme.primaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            doc['readTime'],
                            style: GoogleFonts.outfit(fontSize: 13, color: AgriTheme.textMuted, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              doc['title'],
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AgriTheme.textDark,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: doc['color'] as Color,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(doc['icon'] as IconData, color: doc['iconColor'] as Color, size: 32),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 14,
                            backgroundColor: AgriTheme.primaryGreen,
                            child: Icon(Icons.person, size: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc['author'],
                                  style: GoogleFonts.outfit(fontSize: 13, color: AgriTheme.textDark, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Kisan Knowledge Base Source',
                                  style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.textMuted),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.thumb_up_alt_outlined, size: 16, color: AgriTheme.textMuted),
                              const SizedBox(width: 4),
                              Text(doc['likes'], style: GoogleFonts.outfit(fontSize: 13, color: AgriTheme.textMuted)),
                              const SizedBox(width: 14),
                              const Icon(Icons.mode_comment_outlined, size: 16, color: AgriTheme.textMuted),
                              const SizedBox(width: 4),
                              Text(doc['comments'], style: GoogleFonts.outfit(fontSize: 13, color: AgriTheme.textMuted)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(color: AgriTheme.borderLight.withOpacity(0.8), height: 1),
                      const SizedBox(height: 20),
                      Text(
                        '📋 Executive Summary & Insights',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AgriTheme.textDark),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AgriTheme.borderLight),
                        ),
                        child: Text(
                          doc['description'],
                          style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF334155), height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.folder_shared, color: AgriTheme.primaryGreen, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Offline Asset Repository Path',
                                    style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.textMuted, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    doc['filePath'],
                                    style: GoogleFonts.outfit(fontSize: 12, color: AgriTheme.primaryGreen, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (doc['fileType'] == 'csv') _CsvViewerWidget(filePath: doc['filePath']),
                      if (doc['fileType'] == 'xml') _XmlViewerWidget(filePath: doc['filePath']),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            if (doc['fileType'] == 'xml') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => KissanXmlViewerScreen(
                                    filePath: doc['filePath'],
                                    title: doc['title'],
                                    author: doc['author'],
                                    category: doc['category'],
                                    categoryColor: doc['color'] as Color,
                                    categoryTextColor: doc['iconColor'] as Color,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening ${doc['fileType'].toString().toUpperCase()} document from Kissan Knowledge Base...'),
                                  backgroundColor: AgriTheme.primaryGreen,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AgriTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.file_open_outlined, size: 20),
                          label: Text(
                            doc['fileType'] == 'xml'
                                ? 'Open / Read Interactive XML Document'
                                : 'Open / View Full ${doc['fileType'].toString().toUpperCase()} Document',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added "${doc['title']}" to your offline bookmarks.'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AgriTheme.primaryGreen,
                            side: const BorderSide(color: AgriTheme.primaryGreen, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                          label: Text(
                            'Bookmark for Offline Reading',
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Kisan Knowledge Hub & Forum'),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Create Post / Question Dialog...')),
              );
            },
            icon: const Icon(Icons.add_circle_outline, color: AgriTheme.primaryGreen),
            label: Text('Ask Community', style: GoogleFonts.outfit(color: AgriTheme.primaryGreen, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    labelStyle: GoogleFonts.outfit(
                      color: isSelected ? Colors.white : AgriTheme.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AgriTheme.primaryGreen,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AgriTheme.primaryGreen : AgriTheme.borderLight),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                final a = _filteredArticles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AgriTheme.cardShadow,
                    border: Border.all(color: AgriTheme.borderLight),
                  ),
                  child: InkWell(
                    onTap: () => _showDocumentDetails(context, a),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: a['color'] as Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  a['category'],
                                  style: GoogleFonts.outfit(color: a['iconColor'] as Color, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AgriTheme.lightGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  a['fileType'].toString().toUpperCase(),
                                  style: GoogleFonts.outfit(color: AgriTheme.primaryGreen, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                a['readTime'],
                                style: GoogleFonts.outfit(fontSize: 12, color: AgriTheme.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  a['title'],
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17, color: AgriTheme.textDark, height: 1.3),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: a['color'] as Color,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(a['icon'] as IconData, color: a['iconColor'] as Color, size: 28),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Divider(color: AgriTheme.borderLight.withOpacity(0.6), height: 1),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 12,
                                backgroundColor: AgriTheme.primaryGreen,
                                child: Icon(Icons.person, size: 14, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  a['author'],
                                  style: GoogleFonts.outfit(fontSize: 12, color: AgriTheme.textMuted, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.thumb_up_alt_outlined, size: 16, color: AgriTheme.textMuted),
                                  const SizedBox(width: 4),
                                  Text(a['likes'], style: GoogleFonts.outfit(fontSize: 12, color: AgriTheme.textMuted)),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.mode_comment_outlined, size: 16, color: AgriTheme.textMuted),
                                  const SizedBox(width: 4),
                                  Text(a['comments'], style: GoogleFonts.outfit(fontSize: 12, color: AgriTheme.textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _XmlViewerWidget extends StatelessWidget {
  final String filePath;

  const _XmlViewerWidget({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString(filePath).catchError((_) => rootBundle.loadString('packages/agri_module/$filePath')),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: AgriTheme.primaryGreen),
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(14)),
            child: Text('Could not load XML preview: ${snapshot.error}', style: GoogleFonts.outfit(color: const Color(0xFF991B1B), fontSize: 13)),
          );
        }

        final xml = snapshot.data!;
        final pageMatches = RegExp(r'<page\s+number="([^"]+)">([\s\S]*?)</page>', caseSensitive: false).allMatches(xml);
        final pageCount = pageMatches.length;
        String previewText = '';
        if (pageMatches.isNotEmpty) {
          final firstPageBody = pageMatches.first.group(2) ?? '';
          final textMatches = RegExp(r'<text>([^<]*)</text>', caseSensitive: false).allMatches(firstPageBody);
          final List<String> lines = [];
          for (final tm in textMatches) {
            final line = (tm.group(1) ?? '')
                .replaceAll('&amp;', '&')
                .replaceAll('&lt;', '<')
                .replaceAll('&gt;', '>')
                .replaceAll('&quot;', '"')
                .replaceAll('&#39;', "'")
                .trim();
            if (line.isNotEmpty) lines.add(line);
          }
          previewText = lines.take(6).join(' ');
        }
        if (previewText.isEmpty) previewText = 'Interactive XML Knowledge Document ready for offline reading and keyword searching.';

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.code, size: 18, color: AgriTheme.primaryGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Interactive XML Knowledge Base ($pageCount Pages Extracted)',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: AgriTheme.primaryGreen),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AgriTheme.primaryGreen, borderRadius: BorderRadius.circular(6)),
                      child: Text('OFFLINE READY', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Page 1 Content Preview:',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AgriTheme.textMuted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"$previewText..."',
                      style: GoogleFonts.outfit(fontSize: 13, color: AgriTheme.textDark, fontStyle: FontStyle.italic, height: 1.4),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search, size: 14, color: AgriTheme.primaryGreen),
                            const SizedBox(width: 4),
                            Text('Full keyword indexing active', style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.primaryGreen, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.volume_up_outlined, size: 14, color: AgriTheme.primaryGreen),
                            const SizedBox(width: 4),
                            Text('AI Voice read-aloud ready', style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.primaryGreen, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CsvViewerWidget extends StatelessWidget {
  final String filePath;

  const _CsvViewerWidget({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString(filePath).catchError((_) => rootBundle.loadString('packages/agri_module/$filePath')),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(color: AgriTheme.primaryGreen),
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(14)),
            child: Text('Could not load CSV data preview: ${snapshot.error}', style: GoogleFonts.outfit(color: const Color(0xFF991B1B), fontSize: 13)),
          );
        }

        final lines = snapshot.data!.split('\n');
        final sampleLines = lines.where((l) => l.trim().isNotEmpty).take(12).toList();
        if (sampleLines.isEmpty) return const SizedBox();

        final headers = _selectRelevantColumns(_parseCsvLine(sampleLines.first));

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AgriTheme.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.table_chart, size: 18, color: Color(0xFF334155)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Live CSV Dataset Preview (${lines.length} Total Rows)',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF334155)),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: DataTable(
                  headingRowHeight: 40,
                  dataRowMinHeight: 36,
                  dataRowMaxHeight: 40,
                  horizontalMargin: 8,
                  columnSpacing: 20,
                  columns: headers.map((h) => DataColumn(label: Text(h, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12, color: AgriTheme.textDark)))).toList(),
                  rows: sampleLines.skip(1).map((line) {
                    final rowData = _selectRelevantColumns(_parseCsvLine(line));
                    return DataRow(
                      cells: List.generate(headers.length, (index) {
                        final val = index < rowData.length ? rowData[index] : '';
                        return DataCell(Text(val, style: GoogleFonts.outfit(fontSize: 12, color: AgriTheme.textMuted)));
                      }),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    bool inQuotes = false;
    StringBuffer current = StringBuffer();
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString().trim());
        current.clear();
      } else {
        current.write(char);
      }
    }
    result.add(current.toString().trim());
    return result;
  }

  List<String> _selectRelevantColumns(List<String> row) {
    if (row.length >= 12) {
      return [row[3], row[5], row[7], row[9], row[10], row[11]];
    }
    return row.take(6).toList();
  }
}

