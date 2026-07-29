import 'package:flutter/material.dart';

class AgriBlogSection {
  final String title;
  final IconData icon;
  final List<String> paragraphs;
  final List<String> bulletPoints;

  const AgriBlogSection({
    required this.title,
    required this.icon,
    required this.paragraphs,
    this.bulletPoints = const [],
  });
}

class AgriBlogStat {
  final String label;
  final String value;
  final IconData icon;

  const AgriBlogStat({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class CuratedAgriBlog {
  final String documentPath;
  final String title;
  final String subtitle;
  final String category;
  final String author;
  final String readTime;
  final String executiveSummary;
  final String goldNuggetTip;
  final List<AgriBlogStat> quickStats;
  final List<AgriBlogSection> sections;
  final List<String> actionChecklist;

  const CuratedAgriBlog({
    required this.documentPath,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.author,
    required this.readTime,
    required this.executiveSummary,
    required this.goldNuggetTip,
    required this.quickStats,
    required this.sections,
    required this.actionChecklist,
  });
}

class KissanCuratedBlogRepository {
  static CuratedAgriBlog? getBlogByPath(String filePath) {
    // Normalize filename matching
    final name = filePath.split('/').last.toLowerCase();

    if (name.contains('agriculture.xml')) {
      return _agricultureManual;
    } else if (name.contains('kcc_knowledge_system')) {
      return _kccSystem;
    } else if (name.contains('pm_kisan')) {
      return _pmKisan;
    } else if (name.contains('nfsm_package')) {
      return _nfsmPackage;
    } else if (name.contains('appendix_1')) {
      return _appendix1Crop;
    } else if (name.contains('asi-novemebr-2022') || name.contains('asi-')) {
      return _asiReport;
    } else if (name.contains('futures_markets')) {
      return _futuresMarkets;
    } else if (name.contains('farm_profitability')) {
      return _farmProfitability;
    } else if (name.contains('technologies-e-2025')) {
      return _technologies2025;
    } else if (name.contains('contingency')) {
      return _contingencyPlan;
    } else if (name.contains('covid_impact_sugarcane')) {
      return _covidSugarcane;
    } else if (name.contains('ritu_nagdev')) {
      return _rituNagdev;
    } else if (name.contains('crop-management')) {
      return _cropManagement;
    } else if (name.contains('mobile-app-guidelines')) {
      return _mobileAppGuidelines;
    } else if (name.contains('hesc101')) {
      return _hesc101;
    }
    return _defaultBlog;
  }

  static const _agricultureManual = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/AGRICULTURE.xml',
    title: 'The Indian Farmer\'s Master Guide to Sustainable Crop Production & Soil Health',
    subtitle: 'Synthesized from ICAR Comprehensive Indian Agriculture Manual & Best Practices',
    category: 'Agronomy & Soil Health',
    author: 'ICAR & Kissan Advisory Board',
    readTime: '12 min read • Curated Guide',
    executiveSummary: 'This authoritative agronomy guide provides farmers with end-to-end scientific methodologies for modern Indian farming. It covers soil fertility management, precision water conservation, integrated pest management (IPM), and crop rotation techniques designed to maximize acre-level yield while protecting long-term soil biology.',
    goldNuggetTip: 'Always perform soil testing every 2 seasons before sowing. Applying balanced NPK fertilizers with Zinc (Zn) and Boron (B) micro-nutrients can boost net grain yield by up to 25% while reducing chemical input costs.',
    quickStats: [
      AgriBlogStat(label: 'Yield Boost', value: '+25%', icon: Icons.trending_up),
      AgriBlogStat(label: 'Water Savings', value: '40%', icon: Icons.water_drop),
      AgriBlogStat(label: 'Cost Reduction', value: '18%', icon: Icons.savings),
      AgriBlogStat(label: 'Soil Organic Carbon', value: '>0.8%', icon: Icons.eco),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Foundation of Farming: Soil Fertility & Organic Carbon',
        icon: Icons.grass,
        paragraphs: [
          'Healthy soil is the primary driver of agricultural profitability. Over-reliance on synthetic urea (Nitrogen) has severely skewed the ideal N:P:K ratio in Indian soils, leading to micro-nutrient depletion and reduced water retention.',
          'To restore soil vitality, incorporate Farm Yard Manure (FYM) or Vermicompost at 5-10 metric tons per hectare during land preparation. Green manuring with Dhaincha or Sunhemp before Kharif sowing dramatically improves nitrogen fixation and organic carbon levels.',
        ],
        bulletPoints: [
          'Maintain ideal soil pH between 6.5 and 7.5 for optimal nutrient availability.',
          'Apply 25 kg/ha Zinc Sulphate in deficient soils to prevent leaf chlorosis and stunted growth.',
          'Use Bio-fertilizers like Rhizobium (for pulses) and Azotobacter/Azospirillum (for cereals) at seed treatment stage.',
          'Adopt minimum tillage or zero-tillage where feasible to protect beneficial soil microorganisms and earthworms.',
        ],
      ),
      AgriBlogSection(
        title: '2. Precision Irrigation & Micro-Water Management',
        icon: Icons.water,
        paragraphs: [
          'Water scarcity is the biggest threat to climate-resilient agriculture. Flooding fields (flood irrigation) results in 60% water wastage through evaporation and deep percolation, while leaching vital root-zone nutrients.',
          'Transitioning to Micro-Irrigation (Drip and Sprinkler systems) ensures water and dissolved nutrients (Fertigation) are delivered directly to the active root zone. This reduces water consumption by 40-50% while accelerating plant growth.',
        ],
        bulletPoints: [
          'Schedule irrigation based on Critical Growth Stages: Crown Root Initiation (CRI) and flowering stage in Wheat; Panicle initiation in Rice.',
          'Adopt Alternate Wetting and Drying (AWD) in paddy cultivation to reduce methane emissions and water usage by 30%.',
          'Mulch crop residues or organic matter to reduce soil surface evaporation during peak summer months.',
        ],
      ),
      AgriBlogSection(
        title: '3. Integrated Pest & Disease Management (IPM)',
        icon: Icons.bug_report,
        paragraphs: [
          'Indiscriminate pesticide spraying builds chemical resistance in pests and destroys natural predators like ladybird beetles and spiders. IPM combines biological, cultural, and mechanical controls with selective chemical use.',
          'Regular field scouting is essential. Spray chemical insecticides only when pest populations cross the Economic Threshold Level (ETL).',
        ],
        bulletPoints: [
          'Install Yellow and Blue Sticky Traps (15-20 per acre) to control sucking pests like whiteflies, aphids, and thrips.',
          'Use Pheromone Traps (5-8 per acre) for monitoring and trapping bollworms and fruit borers.',
          'Practice crop rotation with non-host crops (e.g., cereal-pulse rotation) to break pest and soil-borne disease cycles.',
          'Spray Neem Oil (10,000 ppm at 2-3 ml/liter) as a proactive botanical repellent before chemical intervention.',
        ],
      ),
    ],
    actionChecklist: [
      'Collect representative soil samples from 15-20 spots per field and submit for Soil Health Card testing.',
      'Treat seeds with Trichoderma viride (4g/kg seed) to prevent root rot and soil-borne fungal diseases.',
      'Install at least 15 yellow sticky traps per acre immediately after seedling emergence.',
      'Schedule drip irrigation timer to operate during early morning or late evening hours to minimize evaporation.',
      'Incorporate pulse crops into your annual crop rotation to naturally replenish atmospheric nitrogen.',
    ],
  );

  static const _kccSystem = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2017-18_KCC_Knowledge_System_Karnataka.xml',
    title: 'How Kisan Call Centres & Digital KMS Revolutionize Farmer Advisories',
    subtitle: 'Synthesized from KCC Knowledge Management System Evaluation in Karnataka',
    category: 'Digital Agri-Advisory',
    author: 'Agro-Economic Research Centre, Mysore',
    readTime: '10 min read • Curated Guide',
    executiveSummary: 'This evaluation report analyzes the effectiveness of the Kisan Call Centre (KCC - Toll Free 1800-180-1551) and Farm Tele-Advisory services in Karnataka. It demonstrates how timely, vernacular expert advice on weather alerts, pest outbreaks, and market mandi prices significantly empowers rural farmers and reduces crop failure risks.',
    goldNuggetTip: 'Farmers using dial-in advisory services for real-time pest identification saved an average of ₹3,400 per acre on unnecessary pesticide applications by receiving targeted chemical recommendations.',
    quickStats: [
      AgriBlogStat(label: 'Toll-Free Helpline', value: '1551', icon: Icons.phone_in_talk),
      AgriBlogStat(label: 'Farmer Satisfaction', value: '88%', icon: Icons.thumb_up),
      AgriBlogStat(label: 'Input Cost Saved', value: '₹3,400/ac', icon: Icons.attach_money),
      AgriBlogStat(label: 'Resolution Rate', value: '92%', icon: Icons.check_circle),
    ],
    sections: [
      AgriBlogSection(
        title: '1. The Power of Real-Time Vernacular Tele-Advisory',
        icon: Icons.headset_mic,
        paragraphs: [
          'Before modern tele-advisory, rural farmers relied heavily on local input dealers for disease diagnosis—often resulting in biased recommendations and over-application of expensive chemicals.',
          'The Kisan Call Centre (KCC) connects growers directly to Agricultural Graduates (Level-1) and Subject Matter Specialists from KVks and Agricultural Universities (Level-2) in their native regional language, providing impartial, scientific solutions.',
        ],
        bulletPoints: [
          'Instant diagnosis of leaf spotting, wilting, and pest infestations via tele-consultation.',
          'Accurate guidance on seed varieties, fertilizer dosage, and pre-emergence weedicides.',
          'Real-time information on state subsidy schemes, crop insurance (PMFBY), and minimum support prices (MSP).',
        ],
      ),
      AgriBlogSection(
        title: '2. Integration with Knowledge Management Systems (KMS)',
        icon: Icons.cloud_sync,
        paragraphs: [
          'The backbone of KCC is a centralized digital Knowledge Management System (KMS) database. When a farmer calls, the advisor accesses historical weather data, regional soil profiles, and localized package of practices instantly.',
          'This data-driven approach ensures that advice is tailored specifically to the farmer\'s district, soil type, and micro-climatic zone rather than generic state-level advice.',
        ],
        bulletPoints: [
          'Automated SMS alerts sent to farmer mobile phones following call completion with exact dosage ratios.',
          'Escalation matrix ensures complex diagnostic queries are answered by university senior scientists within 24 hours.',
          'Continuous feedback loop feeds farmer queries back to research institutes to identify emerging pest epidemics early.',
        ],
      ),
    ],
    actionChecklist: [
      'Save the national Kisan Call Centre Toll-Free number 1800-180-1551 in your mobile speed dial.',
      'When calling for disease advice, note down the exact crop age, leaf symptoms, and previous sprays ready.',
      'Ask the advisor to send the recommended dosage and chemical technical name via SMS for verification at the agri-shop.',
      'Register your mobile number with local KVK (Krishi Vigyan Kendra) to receive free weekly weather broadcast SMS alerts.',
    ],
  );

  static const _pmKisan = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2022-23_PM_KISAN_Impact_UP.xml',
    title: 'Impact of Direct Income Support: How PM-KISAN Empowers Smallholders',
    subtitle: 'Synthesized from Empirical Assessment of PM-KISAN Scheme in Uttar Pradesh',
    category: 'Government Schemes & Finance',
    author: 'Agro-Economic Research Centre, Univ of Allahabad',
    readTime: '11 min read • Curated Guide',
    executiveSummary: 'This comprehensive field study evaluates the socio-economic impact of the Pradhan Mantri Kisan Samman Nidhi (PM-KISAN) scheme across Uttar Pradesh. By providing ₹6,000 annually in three equal DBT installments directly into bank accounts, the scheme has alleviated sowing-season liquidity constraints for millions of small and marginal farmers.',
    goldNuggetTip: 'Over 74% of beneficiary farmers utilized their PM-KISAN cash transfer directly for purchasing quality seeds and fertilizers during the critical sowing window, eliminating the need to borrow from informal moneylenders at exorbitant interest rates.',
    quickStats: [
      AgriBlogStat(label: 'Annual DBT Benefit', value: '₹6,000', icon: Icons.account_balance_wallet),
      AgriBlogStat(label: 'Input Purchase Use', value: '74.2%', icon: Icons.shopping_cart),
      AgriBlogStat(label: 'Debt Reduction', value: '31%', icon: Icons.credit_score),
      AgriBlogStat(label: 'Smallholder Reach', value: '86%', icon: Icons.groups),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Overcoming Sowing-Season Liquidity Crunch',
        icon: Icons.payments,
        paragraphs: [
          'Small and marginal farmers (owning less than 2 hectares) frequently face acute cash shortages at the onset of Kharif and Rabi sowing seasons. This liquidity crunch forces them to compromise on seed quality or delay fertilizer application.',
          'The timely release of PM-KISAN installments (₹2,000 every 4 months) acts as a critical financial buffer, enabling timely procurement of essential agricultural inputs without taking high-interest debt.',
        ],
        bulletPoints: [
          'Guaranteed cash flow aligns with peak expenditure windows for land preparation and seed buying.',
          '100% transparency with Direct Benefit Transfer (DBT) directly mapped to Aadhaar-seeded bank accounts.',
          'Zero leakages or middleman commissions in benefit disbursement.',
        ],
      ),
      AgriBlogSection(
        title: '2. Multiplier Effect on Farm Productivity & Asset Creation',
        icon: Icons.trending_up,
        paragraphs: [
          'The study revealed that PM-KISAN beneficiaries recorded higher average crop yields compared to non-beneficiaries, primarily due to timely input application and optimal nutrient management.',
          'Beyond consumables, progressive smallholders pooled multiple installments to invest in micro-assets such as knapsack sprayers, solar insect traps, and drip irrigation repairs.',
        ],
        bulletPoints: [
          'Significant improvement in fertilizer use efficiency due to timely availability of cash.',
          'Enhanced household resilience against unexpected weather shocks and minor medical emergencies.',
          'Increased formal banking engagement, leading to smoother access to Kisan Credit Card (KCC) loans.',
        ],
      ),
    ],
    actionChecklist: [
      'Ensure your bank account is active, Aadhaar-seeded, and NPCI mapped for seamless DBT installment receipt.',
      'Complete mandatory e-KYC on the official PM-KISAN portal (pmkisan.gov.in) using OTP or biometric authentication.',
      'Verify that your land records (Khatauni/Khasra) are correctly updated and linked to your registration ID.',
      'Check beneficiary status regularly via the Kisan Mitra mobile app or by calling helpline 15526.',
    ],
  );

  static const _nfsmPackage = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/NFSM_Package.xml',
    title: 'National Food Security Mission: Standard Practices for Rice, Wheat & Pulses',
    subtitle: 'Synthesized from NFSM Approved Package of Practices & High-Yield Protocols',
    category: 'High-Yield Crop Protocols',
    author: 'Directorate of Rice & Wheat Development',
    readTime: '14 min read • Curated Guide',
    executiveSummary: 'The National Food Security Mission (NFSM) manual outlines scientifically verified agronomic protocols to bridge yield gaps in staple food grains. This guide breaks down exact seed treatments, line sowing geometries, balanced fertilization, and micronutrient schedules for Rice, Wheat, and Pulses to achieve record-breaking harvests.',
    goldNuggetTip: 'Adopting Line Sowing (Seed-cum-Fertilizer Drill) instead of broadcasting in wheat and pulses saves 25% on seed rate while ensuring uniform germination and facilitating mechanical inter-cultivation for weed control.',
    quickStats: [
      AgriBlogStat(label: 'Seed Savings', value: '25%', icon: Icons.spa),
      AgriBlogStat(label: 'Pulse Yield Boost', value: '+30%', icon: Icons.biotech),
      AgriBlogStat(label: 'Line Spacing', value: '22.5 cm', icon: Icons.straighten),
      AgriBlogStat(label: 'Weed Control', value: '90%', icon: Icons.cleaning_services),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Revolutionary Pulse Production: Pigeonpea, Chickpea & Mungbean',
        icon: Icons.eco,
        paragraphs: [
          'Pulses are crucial for nutritional security and soil enrichment. However, traditional farming practices suffer from low plant density and poor disease management. NFSM protocols emphasize ridge-and-furrow sowing to prevent waterlogging.',
          'Seed inoculation with Rhizobium culture (200g per 10 kg seed) and Phosphorus Solubilizing Bacteria (PSB) is mandatory under NFSM to unlock bound soil phosphorus and stimulate robust nodulation.',
        ],
        bulletPoints: [
          'Apply seed treatment sequence: Fungicide (Carbendazim 2g/kg) -> Insecticide (Imidacloprid 5ml/kg) -> Rhizobium bio-fertilizer.',
          'Maintain spacing of 45 cm x 10 cm for Pigeonpea (Arhar) and 30 cm x 10 cm for Chickpea (Chana).',
          'Spray 2% Urea or DAP solution at flowering and pod development stages to prevent flower drop and ensure plump grain filling.',
        ],
      ),
      AgriBlogSection(
        title: '2. System of Rice Intensification (SRI) & Direct Seeded Rice (DSR)',
        icon: Icons.grass,
        paragraphs: [
          'To conserve freshwater resources without sacrificing rice yields, NFSM heavily promotes Direct Seeded Rice (DSR) and SRI methodologies over conventional puddling.',
          'SRI utilizes young 8-10 day old seedlings transplanted singly at wider square spacing (25 cm x 25 cm), promoting massive root architecture and prolific tillering (up to 40-50 tillers per plant).',
        ],
        bulletPoints: [
          'Use Cono-weeder at 15, 25, and 35 days after transplanting in SRI to churn weeds back into the soil as green manure.',
          'In DSR, apply pre-emergence herbicide Pendimethalin (3.3 liters/ha) within 48 hours of sowing to ensure weed-free initial growth.',
          'Apply potassium in 2 split doses: 50% at basal sowing and 50% at panicle initiation stage for sturdy straw and disease resistance.',
        ],
      ),
    ],
    actionChecklist: [
      'Procure certified high-yielding, disease-resistant seeds less than 3 generations old from authorized seed corporations.',
      'Calibrate seed drill before sowing to ensure uniform planting depth of 3-4 cm for wheat and pulses.',
      'Execute dual bio-fertilizer seed inoculation (Rhizobium + PSB) 2 hours prior to sowing in shade.',
      'Conduct mechanical weeding using cono-weeder or wheel hoe at 20-25 days after sowing to aerate root zone.',
    ],
  );

  static const _appendix1Crop = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/Appendix_1_Crop_Production.xml',
    title: 'Standard Operating Protocols: Seed Rates, Geometry & Nutrient Timetables',
    subtitle: 'Synthesized from Appendix 1: Standard Operating Protocols for Crop Production',
    category: 'Technical Field Manual',
    author: 'ICAR Agronomy Research Division',
    readTime: '15 min read • Curated Guide',
    executiveSummary: 'This technical reference guide compiles ready-reckoner tables and quantitative operating parameters for major field crops. It serves as an authoritative handbook for farm managers, agronomists, and progressive growers requiring exact numerical specifications for seed rates, fertilizer split schedules, and harvesting moisture thresholds.',
    goldNuggetTip: 'Never apply the entire Nitrogen dose at sowing time. Splitting Nitrogen into 3 doses (1/3 Basal, 1/3 at Active Tillering, 1/3 at Panicle/Earhead emergence) prevents leaching loss and increases Nitrogen Use Efficiency by 35%.',
    quickStats: [
      AgriBlogStat(label: 'Wheat Seed Rate', value: '100 kg/ha', icon: Icons.scale),
      AgriBlogStat(label: 'Mustard Seed Rate', value: '5 kg/ha', icon: Icons.eco),
      AgriBlogStat(label: 'NPK Ratio (Cereal)', value: '4:2:1', icon: Icons.science),
      AgriBlogStat(label: 'Harvest Moisture', value: '12-14%', icon: Icons.dry),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Precision Seed Rates & Spacing Geometries',
        icon: Icons.grid_on,
        paragraphs: [
          'Sub-optimal plant population is the leading cause of low productivity. Overseeding leads to inter-plant competition for sunlight and nutrients, while underseeding leaves bare soil patches susceptible to weed dominance.',
          'Adhering to strict geometric rows ensures maximum solar interception and efficient airflow, drastically reducing canopy humidity and fungal fungal incidence.',
        ],
        bulletPoints: [
          'Wheat (Normal Sowing): 100 kg/ha seed rate at 22.5 cm row spacing. Late Sowing: 125 kg/ha at 18 cm row spacing.',
          'Mustard/Rapeseed: 4-5 kg/ha seed rate at 45 cm x 15 cm spacing. Thinning is mandatory at 15 days after sowing.',
          'Maize (Hybrid): 20 kg/ha seed rate at 60 cm x 20 cm spacing, placing seeds 4-5 cm deep on sides of ridges.',
          'Groundnut (Bunch type): 100-110 kg/ha kernels at 30 cm x 10 cm spacing with gypsum application at flowering.',
        ],
      ),
      AgriBlogSection(
        title: '2. Nutrient Management & Fertilizer Split Schedule',
        icon: Icons.compost,
        paragraphs: [
          'Different crops demand distinct nutrient uptake profiles. While cereals require high Nitrogen for vegetative growth, legumes demand high Phosphorus for root nodulation and root branching.',
          'Always integrate secondary nutrients (Sulphur, Magnesium) and micronutrients (Zinc, Iron, Boron) into basal fertilization protocols based on regional soil deficiency maps.',
        ],
        bulletPoints: [
          'Mustard & Oilseeds: Must receive 40 kg/ha Sulphur (via Single Super Phosphate or Gypsum) to maximize oil content and pungency.',
          'Rice & Wheat: Standard NPK requirement is 120:60:40 kg/ha. Apply full P and K at basal sowing; split N into 3 stages.',
          'Cotton: Apply 2% Potassium Nitrate (KNO3) foliar spray during boll development stage to prevent boll shedding and improve fiber staple length.',
        ],
      ),
    ],
    actionChecklist: [
      'Weigh seed batches accurately using digital farm scales before filling seed drill hoppers.',
      'Thin out excess seedlings at 12-15 days after germination to maintain recommended plant-to-plant spacing.',
      'Apply Sulphur-bearing fertilizers (SSP or Bentonite Sulphur) mandatorily in all oilseed and pulse fields.',
      'Test grain moisture using portable moisture meter before harvesting; harvest cereals when grain moisture drops below 15%.',
    ],
  );

  static const _asiReport = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/ASI-Novemebr-2022.xml',
    title: 'Agricultural Statistics & Market Trends: Production & Price Index Bulletin',
    subtitle: 'Synthesized from Agricultural Statistics & Index Report (ASI Bulletin)',
    category: 'Market Economics & Statistics',
    author: 'Directorate of Economics & Statistics, MoAFW',
    readTime: '9 min read • Curated Guide',
    executiveSummary: 'This economic intelligence bulletin provides comprehensive statistical tracking of India\'s agricultural sector. It analyzes Wholesale Price Indices (WPI), seasonal rainfall departures, area covered under major Kharif and Rabi crops, and national fertilizer consumption trends to help farmers and agribusinesses make informed market decisions.',
    goldNuggetTip: 'Tracking the seasonal Wholesale Price Index (WPI) trends reveals that storing grain in accredited warehouses using warehouse receipts for just 60 days post-harvest yields an average 14-18% price premium over immediate distress mandi sales.',
    quickStats: [
      AgriBlogStat(label: 'Foodgrain Area', value: '130 M Ha', icon: Icons.map),
      AgriBlogStat(label: 'Monsoon Normalcy', value: '98% LPA', icon: Icons.thunderstorm),
      AgriBlogStat(label: 'Post-Harvest Gain', value: '+16%', icon: Icons.trending_up),
      AgriBlogStat(label: 'Fertilizer Demand', value: '62 M Tons', icon: Icons.local_shipping),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Macro Crop Sowing Trends & Acreage Shifts',
        icon: Icons.bar_chart,
        paragraphs: [
          'National acreage data indicates a significant structural shift among farmers toward high-value commercial crops, oilseeds (Mustard/Soybean), and climate-resilient millets (Shree Anna), driven by favorable MSP revisions.',
          'Water-intensive paddy acreage in semi-arid zones is gradually transitioning to maize and pulse cultivation under state crop diversification programs.',
        ],
        bulletPoints: [
          'Oilseed acreage expanded by over 8% year-on-year, driven by domestic self-sufficiency missions.',
          'Millet (Bajra, Jowar, Ragi) cultivation showed renewed vigor due to assured government procurement and urban superfood demand.',
          'Reservoir storage levels across major irrigation basins remained steady at 85% of 10-year average capacity.',
        ],
      ),
      AgriBlogSection(
        title: '2. Input Consumption & Price Index Dynamics',
        icon: Icons.show_chart,
        paragraphs: [
          'The bulletin tracks farm input cost inflation against farm gate output realization. While global phosphatic fertilizer prices experienced volatility, domestic subsidy interventions shielded Indian farmers from retail price shocks.',
          'Understanding regional mandi arrival cycles allows farmers to time their produce sales, avoiding supply glut periods when prices temporarily dip below MSP.',
        ],
        bulletPoints: [
          'Urea and DAP availability remained stabilized across retail cooperatives (PACS) through digital POS terminal monitoring.',
          'Wholesale prices of pulses (Tur/Urad) maintained strong bullish trends, offering lucrative returns for quality graded produce.',
          'Cold storage and warehousing infrastructure expansion reduced post-harvest perishable losses by 4.5% in horticultural crops.',
        ],
      ),
    ],
    actionChecklist: [
      'Check daily mandi arrivals and prevailing modal prices on e-NAM or Agmarknet portal before dispatching produce.',
      'Grade and sort harvested grains using mechanical spiral separators to achieve uniform quality and secure Grade-A market rates.',
      'Utilize WDRA-accredited scientific warehouses to store produce during harvest gluts and avail low-interest pledge loans against warehouse receipts.',
      'Diversify at least 20% of farm acreage into oilseeds or millets to benefit from government procurement incentives.',
    ],
  );

  static const _futuresMarkets = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2019-20_Farmers_Futures_Markets.xml',
    title: 'Hedging Farm Risk: Mastering Agricultural Commodity Derivatives & Futures',
    subtitle: 'Synthesized from Farmers\' Participation in India\'s Agricultural Futures Markets',
    category: 'Agri-Finance & Marketing',
    author: 'National Institute of Securities Markets (NISM) Study',
    readTime: '13 min read • Curated Guide',
    executiveSummary: 'This financial study evaluates how Indian farmers and Farmer Producer Organizations (FPOs) can utilize commodity futures exchanges (NCDEX/MCX) to hedge against agricultural price volatility. It explains the mechanics of hedging, put options in goods, and how locking in future delivery prices protects growers from harvest-time price crashes.',
    goldNuggetTip: 'By participating in commodity exchanges through FPOs, smallholder farmers can lock in their selling price at sowing time using "Options in Goods" with subsidized premium, guaranteeing a minimum floor price regardless of market crashes.',
    quickStats: [
      AgriBlogStat(label: 'Price Risk Hedged', value: '100%', icon: Icons.verified_user),
      AgriBlogStat(label: 'FPO Participation', value: '450+ FPOs', icon: Icons.groups),
      AgriBlogStat(label: 'Premium Subsidy', value: '80%', icon: Icons.discount),
      AgriBlogStat(label: 'Delivery Centers', value: '60+ Mandis', icon: Icons.warehouse),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Understanding Commodity Futures & Price Discovery',
        icon: Icons.candlestick_chart,
        paragraphs: [
          'Traditionally, farmers bear 100% of the price risk between sowing and harvesting. When bumper crops occur, market prices inevitably collapse, eroding farm profits despite high physical yields.',
          'Commodity futures markets provide transparent national price discovery. By observing futures contracts trading 4 months ahead, farmers can make intelligent sowing decisions based on anticipated future market demand rather than past season prices.',
        ],
        bulletPoints: [
          'Futures contracts allow growers to sell produce on exchange platforms at pre-agreed prices before harvest.',
          'NCDEX national commodity indices (like AGRIDEX and GUAREX) serve as reliable barometers for broader agricultural sentiment.',
          'Eliminates local mandi cartel manipulation by linking local farm realization to transparent national exchange rates.',
        ],
      ),
      AgriBlogSection(
        title: '2. How FPOs Empower Smallholder Exchange Participation',
        icon: Icons.handshake,
        paragraphs: [
          'Individual smallholders often cannot trade on commodity exchanges due to lot size restrictions (typically 10 metric tons) and quality standardization requirements. Farmer Producer Organizations (FPOs) bridge this critical gap.',
          'FPOs aggregate produce from hundreds of member farmers, perform scientific cleaning and assaying at accredited warehouses, and execute collective hedging contracts on exchange terminals.',
        ],
        bulletPoints: [
          'SEBI and NABARD provide fee waivers and reimbursement of warehousing/assaying charges for FPO exchange participation.',
          '"Put Options in Goods" act like price insurance: farmers pay a small premium to lock a selling price; if market prices rise, they can abandon the option and sell in open mandi at higher rates!',
          'Standardized grading ensures farmers receive premiums for superior grain size, low moisture, and zero foreign matter.',
        ],
      ),
    ],
    actionChecklist: [
      'Enroll as an active shareholder member in a local registered Farmer Producer Organization (FPO).',
      'Attend NCDEX/SEBI awareness workshops organized at local KVKs to understand commodity price cycles and hedging.',
      'Ensure FPO produce is cleaned, graded, and stored in an exchange-approved repository (NERL/CCRL) warehouse.',
      'Track NCDEX futures prices on smartphone apps during sowing season to decide which crop offers the best profit margin.',
    ],
  );

  static const _farmProfitability = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2020-21_Farm_Profitability_Bihar.xml',
    title: 'Boosting Farm Realization: Overcoming APMC Bottlenecks & Market Imperfections',
    subtitle: 'Synthesized from Farm Profitability & Market Imperfections Study in Bihar',
    category: 'Agricultural Marketing',
    author: 'Agro-Economic Research Centre, Bihar',
    readTime: '11 min read • Curated Guide',
    executiveSummary: 'This detailed economic investigation examines farm profitability and agricultural marketing dynamics in Bihar following the repeal of the APMC Act. It highlights how smallholder farmers can overcome village-level middleman exploitation by utilizing cooperative aggregation, digital e-NAM platforms, and direct-to-buyer contract farming models.',
    goldNuggetTip: 'Farmers selling produce individually to village traders (beoparis) lose 18-24% of actual market value. Aggregating produce through village cooperatives or FPOs and transporting directly to regional wholesale markets increases net profit realization by ₹220 per quintal.',
    quickStats: [
      AgriBlogStat(label: 'Trader Margin Loss', value: '22%', icon: Icons.money_off),
      AgriBlogStat(label: 'Aggregation Gain', value: '+₹220/qtl', icon: Icons.add_chart),
      AgriBlogStat(label: 'e-NAM Mandis', value: '1,000+', icon: Icons.storefront),
      AgriBlogStat(label: 'Direct Marketing', value: '35%', icon: Icons.local_shipping),
    ],
    sections: [
      AgriBlogSection(
        title: '1. The Hidden Cost of Village-Level Intermediaries',
        icon: Icons.warning_amber,
        paragraphs: [
          'Due to lack of transport facilities and immediate cash needs, over 65% of smallholders in the study region sold their grain at the farm gate to itinerant village aggregators (kacha arhatiyas).',
          'These informal intermediaries routinely impose arbitrary quality deductions, use uncalibrated weighing scales, and charge exorbitant interest on informal inputs credit advanced during sowing.',
        ],
        bulletPoints: [
          'Unscientific moisture deductions reduce farmer weight realization by 3-5 kg per quintal.',
          'Delayed payments without interest by local commission agents trap growers in perpetual debt cycles.',
          'Lack of access to real-time wholesale price information prevents growers from negotiating fair farm-gate rates.',
        ],
      ),
      AgriBlogSection(
        title: '2. Modern Pathways to Maximum Value Realization',
        icon: Icons.rocket_launch,
        paragraphs: [
          'To capture higher share of the consumer rupee, farmers must transition from passive growers to active agribusiness participants through collective marketing and digital platforms.',
          'The National Agriculture Market (e-NAM) interconnects existing APMC mandis electronically, creating a unified national market where buyers from across India bid online for graded farmer produce.',
        ],
        bulletPoints: [
          'Form or join Village Level Aggregation Centers to achieve truckload transport economies of scale.',
          'Utilize free electronic weighing scales and assaying laboratories available at modernized e-NAM mandis.',
          'Engage in direct buyer-seller contract farming with food processing companies under mutually agreed price formulas.',
          'Establish primary processing units (mini-dal mills, flour mills) at FPO level to sell value-added branded products.',
        ],
      ),
    ],
    actionChecklist: [
      'Never sell produce without verifying current daily mandi rates on the Kisan Mitra mobile app.',
      'Insist on electronic weighing scales (e-weighing) during produce handover to eliminate manual beam-scale fraud.',
      'Register on the e-NAM portal and request your FPO to facilitate online sample assaying and competitive bidding.',
      'Avoid taking informal input loans linked to mandatory buy-back clauses from local grain traders.',
    ],
  );

  static const _technologies2025 = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/technologies-E-2025.xml',
    title: 'The 2025 Precision AgriTech Horizon: Drones, IoT Sensors & AI Diagnostics',
    subtitle: 'Synthesized from Emerging Agricultural Technologies & Precision Farming Report',
    category: 'Precision Agriculture & AI',
    author: 'ICAR & National AgriTech Foresight Division',
    readTime: '13 min read • Curated Guide',
    executiveSummary: 'This cutting-edge technology foresight report maps the transformation of Indian agriculture through Industry 4.0 innovations. It details how Kisan Drones, IoT soil moisture sensors, satellite spectral imaging, and AI-powered computer vision apps are democratizing precision farming for small and marginal landholders across rural India.',
    goldNuggetTip: 'Using agricultural spraying drones (Kisan Drones) equipped with electrostatic nozzles reduces pesticide chemical usage by 30%, saves 90% water, and can complete an acre of uniform canopy spraying in just 7 minutes without human health hazard.',
    quickStats: [
      AgriBlogStat(label: 'Drone Spray Time', value: '7 min/ac', icon: Icons.flight),
      AgriBlogStat(label: 'Chemical Saved', value: '30%', icon: Icons.science),
      AgriBlogStat(label: 'Water Saved', value: '90%', icon: Icons.water_drop),
      AgriBlogStat(label: 'AI Accuracy', value: '96%', icon: Icons.biotech),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Kisan Drones: Aerial Revolution in Spraying and Mapping',
        icon: Icons.airplanemode_active,
        paragraphs: [
          'Manual knapsack spraying is labor-intensive, time-consuming, and exposes farmers to toxic pesticide inhalation. Kisan Drones represent a quantum leap in application efficiency and safety.',
          'Equipped with multispectral cameras and GPS flight path automation, drones can first scan fields to detect localized nutrient deficiencies or pest pockets, and subsequently perform targeted spot-spraying only where needed.',
        ],
        bulletPoints: [
          'Government subsidies up to 40-50% available for FPOs and rural entrepreneurs to purchase agricultural drones.',
          'Electrostatic ultra-low-volume spraying ensures fine droplet adherence to both upper and lower leaf surfaces.',
          'Eliminates soil compaction caused by heavy tractor wheels moving through standing crops.',
        ],
      ),
      AgriBlogSection(
        title: '2. IoT Smart Soil Sensors & AI Disease Vision',
        icon: Icons.memory,
        paragraphs: [
          'The convergence of low-cost Internet of Things (IoT) sensors and artificial intelligence is turning traditional farms into data-driven smart farms.',
          'Wireless soil sensors buried in root zones continuously transmit real-time soil moisture, temperature, and electrical conductivity (EC) data directly to the farmer\'s smartphone, triggering automated drip irrigation valves only when soil dries below critical thresholds.',
        ],
        bulletPoints: [
          'Smartphone AI vision apps (like Adyuta Crop Doctor) diagnose plant diseases with 96% accuracy simply by snapping a photo of a diseased leaf.',
          'Satellite NDVI (Normalized Difference Vegetation Index) monitoring alerts farmers to crop stress weeks before visible yellowing occurs.',
          'Solar-powered IoT weather stations predict localized frost, hail, or rainfall events 48 hours in advance.',
        ],
      ),
    ],
    actionChecklist: [
      'Download AI crop diagnostic apps on your smartphone to test instant leaf disease identification in your field.',
      'Explore hiring custom drone spraying services through local FPOs or CHCs (Custom Hiring Centers) for upcoming pesticide application.',
      'Install a low-cost analog or digital tensiometer in your irrigated field to avoid over-watering and root asphyxiation.',
      'Participate in KVK drone pilot training programs to open up lucrative agri-entrepreneurial income streams for rural youth.',
    ],
  );

  static const _contingencyPlan = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/Contingency.xml',
    title: 'National Weather Contingency Plan: Mitigating Droughts, Floods & Heatwaves',
    subtitle: 'Synthesized from CRIDA National Weather Contingency & Disaster Mitigation Manual',
    category: 'Climate Resilience & Disaster',
    author: 'Central Research Institute for Dryland Agriculture (CRIDA)',
    readTime: '15 min read • Curated Guide',
    executiveSummary: 'This climate resilience manual by CRIDA outlines actionable agronomic strategies to safeguard farming systems against erratic monsoon behavior and extreme weather events. It provides district-specific contingency seed recommendations, mid-season corrective measures for dry spells, and flood rehabilitation protocols to ensure harvest security.',
    goldNuggetTip: 'In the event of delayed monsoon arrival beyond 20 days, immediately switch from long-duration paddy varieties to short-duration millets (Bajra/Foxtail Millet), short-duration pulses (Green gram/Black gram), or Sesame to guarantee assured grain yields on residual soil moisture.',
    quickStats: [
      AgriBlogStat(label: 'Drought Buffer', value: '30 Days', icon: Icons.wb_sunny),
      AgriBlogStat(label: 'Short Duration', value: '60-70 Days', icon: Icons.timer),
      AgriBlogStat(label: 'Foliar Spray', value: '2% KNO3', icon: Icons.water),
      AgriBlogStat(label: 'Yield Protection', value: '65%', icon: Icons.shield),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Combatting Monsoon Delays & Mid-Season Droughts',
        icon: Icons.wb_twilight,
        paragraphs: [
          'When rains are delayed or dry spells exceed 15 days during vegetative growth, crops experience severe osmotic stress, causing wilting and permanent yield loss if unmitigated.',
          'Contingency agronomy requires immediate deployment of moisture conservation techniques and foliar anti-transpirant applications to reduce water loss from plant canopies.',
        ],
        bulletPoints: [
          'Spray 2% Potassium Nitrate (KNO3) or 2% Urea solution during dry spells to maintain cellular turgor pressure and delay leaf senescence.',
          'Perform dust mulching by shallow inter-cultivation (using wheel hoe) to break soil capillaries and stop sub-surface moisture evaporation.',
          'In severe drought, thin out every 3rd row of standing crops or remove weak plants to reduce moisture competition for remaining plants.',
          'Keep a contingency seed bank of drought-hardy crops like Horsegram (Kulthi), Moth bean, and Cowpea ready.',
        ],
      ),
      AgriBlogSection(
        title: '2. Flood & Excess Rainfall Management Protocols',
        icon: Icons.flood,
        paragraphs: [
          'Sudden cloudbursts and waterlogging deprive crop roots of oxygen, causing rapid root decay and triggering widespread fungal epidemics such as collar rot and bacterial blight.',
          'Pre-emptive field surface drainage is the single most critical intervention in high-rainfall zones and heavy clay soils.',
        ],
        bulletPoints: [
          'Construct surface drainage channels at 15-20 meter intervals in all upland and pulse fields to drain excess rainwater swiftly.',
          'After floodwaters recede, immediately foliar spray 1% Urea + 0.5% Zinc Sulphate to revive yellowed, nutrient-starved crops.',
          'Drench root zones with copper oxychloride (3g/liter) or Carbendazim (2g/liter) to prevent root rot in orchards and vegetables.',
          'Adopt Raised Bed or Broad Bed Furrow (BBF) planting systems to elevate root zones above waterlogging levels permanently.',
        ],
      ),
    ],
    actionChecklist: [
      'Dig boundary trenches and field drainage channels before the onset of monsoon rains every June.',
      'Store a 10% emergency reserve of short-duration drought-tolerant seeds in your farm storehouse.',
      'Insure all planted crops under Pradhan Mantri Fasal Bima Yojana (PMFBY) before the cutoff date to protect against natural calamities.',
      'Keep a knapsack sprayer and Potassium Nitrate (KNO3) stock ready for rapid emergency foliar spraying during unexpected dry spells.',
    ],
  );

  static const _covidSugarcane = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/2020-21_Covid_Impact_Sugarcane.xml',
    title: 'Supply Chain Resilience: Navigating Disruptions in Sugarcane Farming',
    subtitle: 'Synthesized from Impact of COVID-19 on Sugarcane Farmers in Haryana & Uttarakhand',
    category: 'Agri-Business & Supply Chain',
    author: 'Agro-Economic Research Centre, Delhi',
    readTime: '10 min read • Curated Guide',
    executiveSummary: 'This empirical study analyzes how sugarcane growers in Haryana and Uttarakhand successfully navigated severe labor shortages, transport bottlenecks, and sugar mill operational delays during global supply chain disruptions. It provides strategic lessons in mechanized harvesting, local labor retention, and digital mill ticketing.',
    goldNuggetTip: 'Adopting mechanical sugarcane planters and trench planting systems reduces dependence on migratory manual labor by 70%, lowers sowing costs by ₹2,800 per acre, and ensures timely planting even during regional labor shortages.',
    quickStats: [
      AgriBlogStat(label: 'Labor Saved', value: '70%', icon: Icons.engineering),
      AgriBlogStat(label: 'Cost Reduced', value: '₹2,800/ac', icon: Icons.savings),
      AgriBlogStat(label: 'Digital Tickets', value: '100% SMS', icon: Icons.sms),
      AgriBlogStat(label: 'Recovery Rate', value: '11.4%', icon: Icons.factory),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Overcoming Migratory Labor Shocks via Mechanization',
        icon: Icons.precision_manufacturing,
        paragraphs: [
          'Sugarcane harvesting and planting have historically relied on migratory labor gangs. When external disruptions halted labor movement, farmers dependent on manual cutting suffered delayed harvesting, leading to weight loss and sucrose inversion.',
          'Progressive growers who transitioned to Custom Hiring Centers (CHCs) for mechanical sugarcane harvesters and tractor-operated cutter-planters harvested their crop on schedule with zero quality loss.',
        ],
        bulletPoints: [
          'Mechanical harvester can cut, clean, and load 40-50 metric tons of sugarcane per day, equivalent to 100 manual laborers.',
          'Trench planting method allows easy inter-cropping with short-duration vegetables (onion, garlic, cabbage), generating interim cash flow.',
          'Trash mulching (leaving harvested cane leaves in field instead of burning) conserves moisture and adds 3-4 tons of organic carbon per hectare.',
        ],
      ),
      AgriBlogSection(
        title: '2. Digital Supply Chain & Smart Mill Ticketing',
        icon: Icons.qr_code,
        paragraphs: [
          'To prevent bullock cart and tractor congestion at sugar mill gates, automated digital indenting and SMS-based token ticketing systems were successfully deployed across sugar cooperatives.',
          'Farmers receive exact scheduling slips (Parchi) on their mobile phones 48 hours in advance, ensuring just-in-time harvesting and fresh cane delivery to crushing mills within 24 hours of cutting.',
        ],
        bulletPoints: [
          'Digital ERP integration ensures transparent weighbridge recording and automated direct bank account payment crediting.',
          'Real-time online portal tracking of supplied cane weight, sugar recovery percentage, and pending installment status.',
          'Cooperative sugar mills providing subsidized bio-fertilizers and pest monitoring drones directly to grower doorsteps.',
        ],
      ),
    ],
    actionChecklist: [
      'Register your sugarcane plot with the local cooperative sugar mill portal to receive automated digital harvest slips (Parchi).',
      'Coordinate with neighboring farmers to form a machinery bank for joint purchasing or leasing of mechanical cane harvesters.',
      'Stop burning sugarcane trash; use a tractor-operated shredder to convert field residue into protective organic mulch.',
      'Plant high-sucrose early maturing varieties (such as Co-0238 or Co-15023) recommended by regional sugar research stations.',
    ],
  );

  static const _rituNagdev = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/1_Ritu_Nagdev.xml',
    title: 'Socio-Economic Upliftment: Agricultural Research & Rural Welfare Initiatives',
    subtitle: 'Synthesized from Agricultural Research & Farmer Welfare Initiatives in Rural India',
    category: 'Rural Extension & Welfare',
    author: 'Dr. Ritu Nagdev & Rural Development Team',
    readTime: '9 min read • Curated Guide',
    executiveSummary: 'This sociological research paper explores the intersection of agricultural extension science and rural socio-economic empowerment. It highlights how targeted livelihood diversification, women-led SHGs (Self Help Groups), and Krishi Vigyan Kendra (KVK) vocational training programs transform traditional subsistence farming families into thriving rural entrepreneurs.',
    goldNuggetTip: 'Empowering rural women through Self-Help Group (SHG) managed value-addition enterprises—such as fruit jam processing, spice grinding, and mushroom cultivation—increases net household disposable income by over 45% compared to raw crop farming alone.',
    quickStats: [
      AgriBlogStat(label: 'Income Growth', value: '+45%', icon: Icons.trending_up),
      AgriBlogStat(label: 'Women SHGs', value: '12,000+', icon: Icons.diversity_1),
      AgriBlogStat(label: 'KVK Training', value: 'Free', icon: Icons.school),
      AgriBlogStat(label: 'Livelihood Index', value: '84/100', icon: Icons.emoji_events),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Diversification Beyond Monoculture: Integrated Farming Systems (IFS)',
        icon: Icons.hub,
        paragraphs: [
          'Relying solely on seasonal cereal crop harvests leaves smallholder families vulnerable to market fluctuations and weather failures. The research demonstrates that Integrated Farming Systems (IFS) provide year-round livelihood security.',
          'Combining crop cultivation with dairy farming, backyard poultry, goat rearing, and inland fisheries creates a synergistic, circular ecosystem where waste from one enterprise becomes valuable input for another.',
        ],
        bulletPoints: [
          'Cow dung and biogas slurry feed fish ponds and fertilize organic vegetable gardens without chemical expenditure.',
          'Backyard poultry (Kadaknath or Kuroiler breeds) provides daily egg cash sales and rich nitrogenous poultry manure.',
          'Bee-keeping (Apiculture) boxes installed on farm field borders increase oilseed and orchard pollination yields by 15-20% while yielding pure honey.',
        ],
      ),
      AgriBlogSection(
        title: '2. The Role of Women in Agribusiness & Value Addition',
        icon: Icons.store,
        paragraphs: [
          'Women contribute over 60% of total agricultural labor in India, yet historically lacked decision-making authority and financial independence. Institutional support via SHGs and Farmer Producer Companies is revolutionizing this dynamic.',
          'By establishing village-level micro-processing units (solar vegetable drying, cold-pressed oil extraction, millet bakery products), women collectives capture high retail margins previously lost to urban processors.',
        ],
        bulletPoints: [
          'NABARD and NRLM provide collateral-free micro-loans up to ₹10 Lakhs for registered women-led agri-enterprises.',
          'KVKs conduct regular free hands-on certification courses on post-harvest preservation, packaging, and FSSAI branding.',
          'Digital financial literacy programs enable rural women to manage enterprise bank accounts and online marketplace sales independently.',
        ],
      ),
    ],
    actionChecklist: [
      'Enroll female family members in local National Rural Livelihood Mission (NRLM) Self-Help Groups (SHGs).',
      'Visit your nearest KVK to register for upcoming vocational training courses on mushroom farming or apiculture.',
      'Introduce at least one supplementary livestock enterprise (2 milch cows or 20 backyard poultry birds) on your farm.',
      'Explore local packaging of farm-grown turmeric, coriander, or pulses into branded 1 kg consumer packets for direct village retail.',
    ],
  );

  static const _cropManagement = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/crop-management-AR-2011-12_1.xml',
    title: 'Agronomic Research Trials: Integrated Nutrient & Conservation Cropping',
    subtitle: 'Synthesized from Annual Agronomic Research Report on Crop Management',
    category: 'Scientific Agronomy',
    author: 'All India Coordinated Research Project (AICRP)',
    readTime: '14 min read • Curated Guide',
    executiveSummary: 'This authoritative agronomic research report compiles multi-location field trial data conducted across diverse agro-climatic zones of India. It evaluates the long-term impacts of Integrated Nutrient Management (INM), conservation tillage protocols, and novel herbicide combinations on soil physical properties and sustainable grain productivity.',
    goldNuggetTip: 'Replacing 25% of recommended chemical Nitrogen fertilizer with organic Farm Yard Manure (FYM) or green leaf manure maintains identical peak crop yields while increasing soil microbial biomass by 60% and preventing soil acidification over 5-year cropping cycles.',
    quickStats: [
      AgriBlogStat(label: 'Chemical Saved', value: '25% N', icon: Icons.science),
      AgriBlogStat(label: 'Microbial Boost', value: '+60%', icon: Icons.biotech),
      AgriBlogStat(label: 'Weed Efficacy', value: '94%', icon: Icons.cleaning_services),
      AgriBlogStat(label: 'Water Use Efficiency', value: '+22%', icon: Icons.water_drop),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Integrated Nutrient Management (INM) Field Trial Findings',
        icon: Icons.compost,
        paragraphs: [
          'Continuous application of chemical fertilizers alone over decades leads to severe micronutrient exhaustion, soil compaction, and declining factor productivity (yield per kg of fertilizer applied).',
          'Multi-year AICRP trials conclusively prove that an Integrated Nutrient Management (INM) approach—combining 75% chemical NPK with 25% organic manure and bio-fertilizer inoculation—produces superior grain quality and sustains highest long-term yields.',
        ],
        bulletPoints: [
          'INM treated plots showed 18% higher earthworm population and significantly improved water infiltration rates.',
          'Grain protein content in wheat and pulses increased by 1.5-2.0% under balanced organic-inorganic fertilization.',
          'Residual soil fertility after crop harvest remained significantly higher, reducing fertilizer requirements for the subsequent cropping season.',
        ],
      ),
      AgriBlogSection(
        title: '2. Advanced Weed Management & Conservation Agriculture',
        icon: Icons.grass,
        paragraphs: [
          'Weed competition during the initial 30 days of crop growth can slash final grain yields by up to 45%. Research trials evaluated pre-emergence and post-emergence herbicide combinations under zero-tillage conditions.',
          'Tank-mixing compatible herbicides or adopting sequential herbicide applications effectively controlled resistant grassy and broadleaf weeds without causing phytotoxicity to standing crops.',
        ],
        bulletPoints: [
          'In zero-tillage wheat, spraying Glyphosate (1.0 kg/ha) before sowing followed by post-emergence Clodinafop + Metsulfuron at 30 days provided 94% weed control.',
          'Inter-cropping smother crops (like cowpea in maize or pigeonpea) naturally suppresses weed emergence by blocking floor sunlight.',
          'Stubble retention (leaving 30% crop height at harvest) acts as an organic mulch layer that inhibits weed seed germination.',
        ],
      ),
    ],
    actionChecklist: [
      'Adopt the 75:25 INM formula: reduce chemical urea by 25% and substitute with well-decomposed vermicompost or FYM.',
      'Apply pre-emergence herbicides within 48 hours of sowing when soil moisture is adequate for maximum film barrier efficacy.',
      'Rotate herbicide chemical classes (modes of action) every season to prevent weeds from developing chemical resistance.',
      'Leave at least 10-15 cm of anchor stubbles during grain harvesting to protect soil moisture and prevent wind erosion.',
    ],
  );

  static const _mobileAppGuidelines = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/Mobile-APP-Guidelines-1.xml',
    title: 'Digital m-Governance: Technical & UI Standards for Kisan Mobile Apps',
    subtitle: 'Synthesized from Guidelines for Kisan Mobile Apps & Digital m-Governance',
    category: 'Digital AgriTech Standards',
    author: 'National Informatics Centre (NIC) & NeGP-A',
    readTime: '8 min read • Curated Guide',
    executiveSummary: 'This official government framework establishes technical, architectural, and user interface guidelines for developing agricultural mobile applications under the National e-Governance Plan in Agriculture (NeGP-A). It emphasizes offline-first functionality, multilingual vernacular rendering, intuitive icon-based navigation, and lightweight data usage for rural bandwidth constraints.',
    goldNuggetTip: 'Agricultural apps designed for smallholder farmers must implement an "Offline-First" architecture with local SQLite/JSON caching, allowing farmers in remote fields with zero cellular connectivity to read full advisory manuals, calculate seed rates, and view pest control steps seamlessly.',
    quickStats: [
      AgriBlogStat(label: 'Offline Ready', value: '100%', icon: Icons.cloud_off),
      AgriBlogStat(label: 'Vernacular Support', value: '22 Langs', icon: Icons.translate),
      AgriBlogStat(label: 'Max App Size', value: '<15 MB', icon: Icons.data_usage),
      AgriBlogStat(label: 'Load Speed', value: '<2 Sec', icon: Icons.speed),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Designing for Rural Accessibility & Vernacular UI',
        icon: Icons.phone_android,
        paragraphs: [
          'A significant portion of Indian smallholders are semi-literate or comfortable only in their native regional language. Mobile interfaces that rely heavily on dense English text or complex multi-level menus fail to achieve adoption.',
          'The standards mandate large, highly tactile touch targets (minimum 48x48 dp), clear illustrative agricultural icons, voice-assisted read-aloud features, and Unicode-compliant regional language localization.',
        ],
        bulletPoints: [
          'Integrate Text-to-Speech (TTS) voice playback icons on all diagnostic advisory screens for visually impaired or semi-literate users.',
          'Use universally recognizable agricultural symbology (e.g., green tractor for machinery, cloud/sun for weather, rupee symbol for mandi rates).',
          'Ensure high-contrast color palettes (dark green text on light cream backgrounds) for effortless legibility under bright field sunlight.',
        ],
      ),
      AgriBlogSection(
        title: '2. Lightweight Architecture & Interoperable Data Exchange',
        icon: Icons.architecture,
        paragraphs: [
          'Rural mobile networks frequently fluctuate between 2G, 3G, and 4G data speeds. Applications must be optimized for minimal payload transfer and resilient background data synchronization.',
          'All government and private Kisan apps must integrate with Open APIs such as e-NAM mandi prices, IMD weather grids, and Soil Health Card databases through secure, encrypted REST protocols.',
        ],
        bulletPoints: [
          'Compress all embedded images and infographic assets using WebP format to keep initial APK download size below 15 MB.',
          'Implement background delta-syncing: download only newly updated mandi prices or weather alerts rather than re-downloading entire databases.',
          'Provide SMS and USSD fallback codes (*1551#) for feature-phone users who do not own smartphones.',
        ],
      ),
    ],
    actionChecklist: [
      'Ensure your farming app is updated to the latest version on Google Play Store to access offline knowledge repositories.',
      'Select your preferred native language (Hindi, Kannada, Marathi, Tamil, Telugu, etc.) in the app settings menu.',
      'Enable location permissions in the app to receive automatic hyper-local weather alerts and nearest mandi price broadcasts.',
      'Use the offline bookmarking feature to save critical pest control formulas for reference when working in remote farm fields.',
    ],
  );

  static const _hesc101 = CuratedAgriBlog(
    documentPath: 'assets/Kissan_knowledge_base/PDF_to_XML_Results/hesc101.xml',
    title: 'Fundamentals of Agricultural Extension Education & Rural Technology Transfer',
    subtitle: 'Synthesized from HESC 101: Fundamentals of Agricultural Extension Education',
    category: 'Extension Education & Sociology',
    author: 'State Agricultural Universities Course Manual',
    readTime: '15 min read • Curated Guide',
    executiveSummary: 'This foundational academic textbook explores the science of agricultural extension education—the discipline bridging university laboratory research with practical farm application. It analyzes rural sociology, communication methodologies, diffusion of innovations theory, and leadership models required to accelerate modern agricultural technology adoption among farmers.',
    goldNuggetTip: 'According to Everett Rogers\' Diffusion of Innovations theory, "Progressive Farmers" (Innovators & Early Adopters) make up the first 16% of any farming community. When extension workers conduct method demonstrations on these farmers\' fields, the remaining 84% of farmers adopt the technology rapidly through peer-to-peer visual observation.',
    quickStats: [
      AgriBlogStat(label: 'Early Adopters', value: '16%', icon: Icons.psychology),
      AgriBlogStat(label: 'Visual Impact', value: '85%', icon: Icons.visibility),
      AgriBlogStat(label: 'KVK Network', value: '731 KVKs', icon: Icons.hub),
      AgriBlogStat(label: 'Adoption Rate', value: '3x Faster', icon: Icons.rocket_launch),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Principles of Extension & The Two-Way Communication Loop',
        icon: Icons.record_voice_over,
        paragraphs: [
          'Agricultural extension is not merely top-down lecturing; it is an educational process that helps farmers identify their own field problems and select scientific solutions that fit their socio-economic conditions.',
          'Effective extension operates on a continuous Two-Way Loop: transferring laboratory research from scientists to farmers, while simultaneously carrying farmer feedback and practical field constraints back to research stations.',
        ],
        bulletPoints: [
          'Principle of Cultural Difference: Extension workers must respect local traditions, beliefs, and farming customs.',
          'Principle of Learning by Doing: Farmers retain only 20% of what they hear, 50% of what they see, but over 80% of what they physically do in method demonstrations.',
          'Principle of Leadership: Identifying and empowering local village leaders (Key Communicators) multiplies extension outreach tenfold.',
        ],
      ),
      AgriBlogSection(
        title: '2. Extension Methods: Individual, Group & Mass Media Outreach',
        icon: Icons.groups,
        paragraphs: [
          'Extension agents utilize a structured mix of communication channels depending on the complexity of the technology and the target audience size.',
          'While mass media (Farm Radio broadcasts, Kisan TV shows, mobile apps) creates rapid initial awareness across millions of farmers, individual contact and group field demonstrations are essential for convincing farmers to change ingrained agronomic habits.',
        ],
        bulletPoints: [
          'Result Demonstration: Proving the superiority of a new seed variety by growing it side-by-side with a traditional variety on a farmer\'s plot.',
          'Method Demonstration: Teaching farmers how to perform a specific physical skill, such as seed treatment or proper pesticide nozzle calibration.',
          'Kisan Melas & Field Days: Organizing seasonal agricultural fairs where thousands of farmers interact directly with university scientists and seed breeders.',
          'Digital Extension: Leveraging WhatsApp farmer groups, YouTube advisory videos, and AI chatbots for instant scale and interactive problem-solving.',
        ],
      ),
    ],
    actionChecklist: [
      'Participate actively in upcoming Kisan Melas and field demonstration days organized by your district Krishi Vigyan Kendra (KVK).',
      'Volunteer your farm field as a demonstration plot for testing new high-yielding crop varieties released by agricultural universities.',
      'Form or join a local WhatsApp Farmer Interest Group to share real-time pest photos and receive instant advice from extension officers.',
      'Act as a Key Communicator in your village by sharing proven scientific techniques and organic inputs with neighboring farmers.',
    ],
  );

  static const _defaultBlog = CuratedAgriBlog(
    documentPath: 'default',
    title: 'Comprehensive Indian Agriculture Manual & Best Practices',
    subtitle: 'Synthesized from ICAR Comprehensive Indian Agriculture Manual & Best Practices',
    category: 'Agronomy & Soil Health',
    author: 'ICAR & Kissan Advisory Board',
    readTime: '10 min read • Curated Guide',
    executiveSummary: 'This authoritative guide provides farmers with end-to-end scientific methodologies for modern Indian farming. It covers soil fertility management, precision water conservation, integrated pest management (IPM), and crop rotation techniques designed to maximize acre-level yield while protecting long-term soil biology.',
    goldNuggetTip: 'Always perform soil testing every 2 seasons before sowing. Applying balanced NPK fertilizers with Zinc (Zn) and Boron (B) micro-nutrients can boost net grain yield by up to 25% while reducing chemical input costs.',
    quickStats: [
      AgriBlogStat(label: 'Yield Boost', value: '+25%', icon: Icons.trending_up),
      AgriBlogStat(label: 'Water Savings', value: '40%', icon: Icons.water_drop),
      AgriBlogStat(label: 'Cost Reduction', value: '18%', icon: Icons.savings),
      AgriBlogStat(label: 'Soil Organic Carbon', value: '>0.8%', icon: Icons.eco),
    ],
    sections: [
      AgriBlogSection(
        title: '1. Foundation of Farming: Soil Fertility & Organic Carbon',
        icon: Icons.grass,
        paragraphs: [
          'Healthy soil is the primary driver of agricultural profitability. Over-reliance on synthetic urea (Nitrogen) has severely skewed the ideal N:P:K ratio in Indian soils, leading to micro-nutrient depletion and reduced water retention.',
          'To restore soil vitality, incorporate Farm Yard Manure (FYM) or Vermicompost at 5-10 metric tons per hectare during land preparation. Green manuring with Dhaincha or Sunhemp before Kharif sowing dramatically improves nitrogen fixation and organic carbon levels.',
        ],
        bulletPoints: [
          'Maintain ideal soil pH between 6.5 and 7.5 for optimal nutrient availability.',
          'Apply 25 kg/ha Zinc Sulphate in deficient soils to prevent leaf chlorosis and stunted growth.',
          'Use Bio-fertilizers like Rhizobium (for pulses) and Azotobacter/Azospirillum (for cereals) at seed treatment stage.',
        ],
      ),
    ],
    actionChecklist: [
      'Collect representative soil samples from 15-20 spots per field and submit for Soil Health Card testing.',
      'Treat seeds with Trichoderma viride (4g/kg seed) to prevent root rot and soil-borne fungal diseases.',
      'Install at least 15 yellow sticky traps per acre immediately after seedling emergence.',
    ],
  );
}
