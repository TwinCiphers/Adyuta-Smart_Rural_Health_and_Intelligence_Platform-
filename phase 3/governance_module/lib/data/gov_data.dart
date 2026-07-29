import '../models/models.dart';

class GovCatalog {
  // 1. AUTHENTIC GOVERNMENT SCHEMES (From SchemeSaathi & Official National Portals)
  static final List<GovernmentScheme> schemes = [
    GovernmentScheme(
      id: 'scheme_pmkisan',
      title: 'Pradhan Mantri Kisan Samman Nidhi (PM-KISAN)',
      ministry: 'Ministry of Agriculture & Farmers Welfare',
      beneficiaries: 'Small and Marginal Landholding Farmer Families',
      category: 'Agri & Rural',
      eligibilityCriteria: [
        'Must be a landholding farmer family with cultivable land holding in their names.',
        'Must possess an active Aadhaar card linked to a bank account.',
        'Institutional landholders, constitutional post holders, and income tax payers are excluded.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Land Ownership Proof (Khata / Khesra / 7-12 Extract)',
        'Bank Passbook with IFSC Code',
      ],
      benefits: 'Financial assistance of Rs. 6,000 per year transferred in three equal installments of Rs. 2,000 directly into bank accounts via DBT.',
      officialWebsite: 'https://pmkisan.gov.in/',
    ),
    GovernmentScheme(
      id: 'scheme_pmfby',
      title: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
      ministry: 'Ministry of Agriculture & Farmers Welfare',
      beneficiaries: 'All Farmers growing notified crops in notified areas',
      category: 'Agri & Rural',
      eligibilityCriteria: [
        'Open to all farmers including sharecroppers and tenant farmers growing notified crops.',
        'Compulsory for loanee farmers possessing Kisan Credit Card (KCC) account for notified crops.',
        'Must apply before the cut-off date defined for Kharif and Rabi seasons.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Bank Passbook with IFSC Code',
        'Land Possession Certificate / Patta / Tenancy Agreement',
        'Sowing Certificate / Crop Declaration',
      ],
      benefits: 'Comprehensive insurance cover against crop failure due to non-preventable natural risks at minimal premium (2% for Kharif, 1.5% for Rabi, 5% for commercial/horticultural crops).',
      officialWebsite: 'https://pmfby.gov.in/',
    ),
    GovernmentScheme(
      id: 'scheme_kcc',
      title: 'Kisan Credit Card (KCC) Scheme',
      ministry: 'Department of Financial Services & RBI',
      beneficiaries: 'Farmers, Tenant Farmers, Oral Lessees, Sharecroppers, SHGs',
      category: 'Finance',
      eligibilityCriteria: [
        'Individual farmers who are owner-cultivators.',
        'Tenant farmers, oral lessees, and sharecroppers.',
        'Self Help Groups (SHGs) or Joint Liability Groups (JLGs) of farmers.',
        'Also extended to animal husbandry and fisheries farmers.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'PAN Card or Form 60',
        'Land Ownership Proof or Tenancy Agreement',
        'Passport-sized photograph',
      ],
      benefits: 'Short-term credit limit for crop cultivation, post-harvest expenses, and working capital at an effective interest rate of 4% per annum (after RBI interest subvention and prompt repayment incentives).',
      officialWebsite: 'https://www.myscheme.gov.in/schemes/kcc',
    ),
    GovernmentScheme(
      id: 'scheme_mgnrega',
      title: 'Mahatma Gandhi National Rural Employment Guarantee Act (MGNREGA)',
      ministry: 'Ministry of Rural Development',
      beneficiaries: 'Rural households whose adult members volunteer to do unskilled manual work',
      category: 'Welfare',
      eligibilityCriteria: [
        'Must be an Indian citizen residing in a rural area.',
        'Applicant must be 18 years of age or older.',
        'Must volunteer for unskilled manual labor.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'MGNREGA Job Card',
        'Bank or Post Office Account Passbook',
        'Residence Proof / Gram Panchayat Registration',
      ],
      benefits: 'Statutory guarantee of at least 100 days of wage employment in a financial year to every rural household whose adult members volunteer to do unskilled manual work.',
      officialWebsite: 'https://nrega.nic.in/',
    ),
    GovernmentScheme(
      id: 'scheme_pmjdy',
      title: 'Pradhan Mantri Jan Dhan Yojana (PMJDY)',
      ministry: 'Department of Financial Services, Ministry of Finance',
      beneficiaries: 'All Indian citizens especially unbanked rural individuals',
      category: 'Finance',
      eligibilityCriteria: [
        'Any individual who is an Indian citizen and aged 10 years and above.',
        'Should not already possess a bank account.',
      ],
      requiredDocuments: [
        'Aadhaar Card (or any officially valid document like Voter ID, PAN, Passport)',
        'Passport-sized photograph',
      ],
      benefits: 'Zero-balance basic savings bank account, free RuPay debit card with in-built accident insurance cover of Rs. 2 lakh, and overdraft facility up to Rs. 10,000.',
      officialWebsite: 'https://pmjdy.gov.in/',
    ),
    GovernmentScheme(
      id: 'scheme_pmayg',
      title: 'Pradhan Mantri Awas Yojana - Gramin (PMAY-G)',
      ministry: 'Ministry of Rural Development',
      beneficiaries: 'Rural homeless households and those living in dilapidated houses',
      category: 'Welfare',
      eligibilityCriteria: [
        'Households without a house or living in zero/one/two room houses with kutcha roof as per SECC 2011 data.',
        'Priority given to SC/ST minorities, freed bonded laborers, and families with differently-abled members.',
      ],
      requiredDocuments: [
        'Aadhaar Card of all family members',
        'Bank Account Passbook',
        'MGNREGA Job Card Number',
        'Swachh Bharat Mission (SBM) Beneficiary Number',
      ],
      benefits: 'Financial assistance of Rs. 1.20 lakh in plain areas and Rs. 1.30 lakh in hilly/difficult areas for construction of a pucca house with basic amenities.',
      officialWebsite: 'https://pmayg.nic.in/',
    ),
    GovernmentScheme(
      id: 'scheme_pmjay',
      title: 'Ayushman Bharat Pradhan Mantri Jan Arogya Yojana (PM-JAY)',
      ministry: 'National Health Authority & Ministry of Health and Family Welfare',
      beneficiaries: 'Over 12 crore poor and vulnerable families (approx. 55 crore beneficiaries)',
      category: 'Health',
      eligibilityCriteria: [
        'Households identified under Socio-Economic Caste Census (SECC) 2011 deprivation criteria.',
        'No restriction on family size, age, or gender.',
        'All senior citizens aged 70 years and above (recently expanded).',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Ration Card / Family ID / SECC Name list entry',
      ],
      benefits: 'Health insurance cover of Rs. 5,000,000 per family per year for secondary and tertiary care hospitalization across public and empanelled private hospitals.',
      officialWebsite: 'https://pmjay.gov.in/',
    ),
    GovernmentScheme(
      id: 'scheme_ssy',
      title: 'Sukanya Samriddhi Yojana (SSY)',
      ministry: 'Department of Posts & Ministry of Finance',
      beneficiaries: 'Girl children below 10 years of age',
      category: 'Women & Child',
      eligibilityCriteria: [
        'Account can be opened by parents or legal guardian for a girl child below 10 years of age.',
        'Maximum of two accounts per family (one for each girl child).',
      ],
      requiredDocuments: [
        'Birth Certificate of the girl child',
        'Aadhaar Card and PAN of the parent/guardian',
        'Residence Proof',
      ],
      benefits: 'High-interest savings account (approx. 8.2% p.a.) with triple tax benefits under Section 80C, ensuring financial security for education and marriage of girl children.',
      officialWebsite: 'https://www.nsiindia.gov.in/',
    ),
    GovernmentScheme(
      id: 'scheme_standup',
      title: 'Stand-Up India Scheme',
      ministry: 'Department of Financial Services, Ministry of Finance',
      beneficiaries: 'SC/ST and Women Entrepreneurs',
      category: 'Skills',
      eligibilityCriteria: [
        'SC/ST and/or women entrepreneurs above 18 years of age.',
        'Loans are available for greenfield enterprises in manufacturing, services, agri-allied activities, or trading.',
        'In case of non-individual enterprises, at least 51% shareholding must be held by SC/ST or women entrepreneur.',
      ],
      requiredDocuments: [
        'Aadhaar Card & PAN Card',
        'Caste Certificate (if applying under SC/ST category)',
        'Business Project Report & Address Proof',
      ],
      benefits: 'Bank loans between Rs. 10 lakh and Rs. 1 Crore from Scheduled Commercial Banks for setting up new enterprises.',
      officialWebsite: 'https://www.standupmitra.in/',
    ),
  ];

  // 2. AUTHENTIC STATUTORY LAWS & CITIZEN RIGHTS (Verbatim Citations, No Mock Data)
  static final List<StatutoryLaw> laws = [
    // CONSTITUTIONAL RIGHTS
    StatutoryLaw(
      id: 'law_const_14',
      title: 'Right to Equality before Law & Equal Protection',
      domain: 'Constitution',
      actCitation: 'The Constitution of India, Part III (Fundamental Rights)',
      sectionNumber: 'Article 14 & Article 15',
      plainExplanation: 'Article 14 mandates that the State shall not deny to any person equality before the law or the equal protection of the laws within the territory of India. Article 15 strictly prohibits discrimination against any citizen on grounds only of religion, race, caste, sex, or place of birth.',
      citizenRights: [
        'Right to equal treatment by police, revenue officers, and government departments.',
        'Right to challenge discriminatory government schemes or local panchayat decisions in court.',
        'Action: File a writ petition under Article 226 in the High Court or Article 32 in the Supreme Court if equal rights are denied.',
      ],
      officialUrl: 'https://www.india.gov.in/my-government/constitution-india',
    ),
    StatutoryLaw(
      id: 'law_const_21',
      title: 'Right to Life, Personal Liberty & Livelihood',
      domain: 'Constitution',
      actCitation: 'The Constitution of India, Part III (Fundamental Rights)',
      sectionNumber: 'Article 21 & Article 21A',
      plainExplanation: 'No person shall be deprived of his life or personal liberty except according to procedure established by law. The Supreme Court has expanded Article 21 to include the Right to Livelihood, Right to Clean Environment, Right to Health, and Right to Shelter. Article 21A mandates free and compulsory education for all children aged 6 to 14 years.',
      citizenRights: [
        'Right to emergency medical treatment at government hospitals without procedural delay.',
        'Right to protection against illegal detention or harassment by authorities.',
        'Right to free education in neighborhood schools for children up to age 14 under RTE Act.',
      ],
      officialUrl: 'https://www.india.gov.in/my-government/constitution-india',
    ),
    StatutoryLaw(
      id: 'law_const_73',
      title: 'Panchayati Raj & Gram Sabha Statutory Powers',
      domain: 'Constitution',
      actCitation: 'The Constitution (Seventy-third Amendment) Act, 1992',
      sectionNumber: 'Article 243A to Article 243O (Part IX)',
      plainExplanation: 'Constitutional recognition of Panchayats as institutions of rural self-government. Article 243A empowers the Gram Sabha (body consisting of all registered voters in the village) to exercise powers and perform functions at the village level, including auditing village work and selecting beneficiaries for poverty alleviation schemes.',
      citizenRights: [
        'Right to attend Gram Sabha meetings and inspect village development budgets.',
        'Right to participate in beneficiary selection for PMAY-G, MGNREGA, and pension schemes.',
        'Action: Demand transparency and social audit reports during mandatory Gram Sabha sessions.',
      ],
      officialUrl: 'https://panchayat.gov.in/',
    ),

    // RBI & FINANCIAL REGULATIONS
    StatutoryLaw(
      id: 'law_rbi_kcc',
      title: 'Kisan Credit Card (KCC) Interest Subvention Mandate',
      domain: 'RBI & Finance',
      actCitation: 'RBI Master Direction - Priority Sector Lending (PSL) & KCC Guidelines',
      sectionNumber: 'FIDD.CO.FSD.BC.No.6/05.05.010/2018-19 (Updated 2023)',
      plainExplanation: 'Under RBI directions and Government of India directives, short-term crop loans up to Rs. 3 lakh under KCC must be provided by banks at a concessional interest rate of 7% per annum. Furthermore, an Interest Subvention of 2% and a Prompt Repayment Incentive (PRI) of 3% is granted to farmers who repay on time, reducing the effective interest rate to just 4% p.a.',
      citizenRights: [
        'Right to receive crop loans up to Rs. 1.60 lakh without any collateral requirement (as per RBI circular).',
        'Right to 3% interest rebate for timely repayment within one year of disbursement.',
        'Action: File a formal grievance with the Banking Ombudsman if any bank branch refuses KCC without valid written grounds.',
      ],
      officialUrl: 'https://rbi.org.in/',
    ),
    StatutoryLaw(
      id: 'law_rbi_zerolib',
      title: 'Customer Zero Liability for Unauthorized Electronic Banking Fraud',
      domain: 'RBI & Finance',
      actCitation: 'RBI Circular on Limiting Liability of Customers in Unauthorized Electronic Banking Transactions',
      sectionNumber: 'DBR.No.Leg.BC.78/09.07.005/2017-18',
      plainExplanation: 'As per RBI statutory mandate, a banking customer has ZERO liability in case of unauthorized electronic transactions (cyber fraud / phishing) if the fraud occurred due to contributory fraud/negligence/deficiency on the part of the bank, OR if the customer notifies the bank within three (3) working days of receiving the SMS/email alert.',
      citizenRights: [
        'Right to 100% refund / zero liability if unauthorized debit is reported to the bank within 3 working days.',
        'Right to get the fraudulent amount credited back to the account within 10 working days of reporting.',
        'Action: Immediately call bank helpline, block debit card/UPI, and obtain written acknowledgment with date/time stamp.',
      ],
      officialUrl: 'https://rbi.org.in/',
    ),

    // POLICE RULES & FIR PROCEDURES
    StatutoryLaw(
      id: 'law_police_zerofir',
      title: 'Mandatory Registration of Zero FIR & Citizen Reporting Rights',
      domain: 'Police & FIR',
      actCitation: 'Bharatiya Nagarik Suraksha Sanhita, 2023 (BNSS) / CrPC Section 154',
      sectionNumber: 'Section 173 BNSS (Formerly Section 154 CrPC)',
      plainExplanation: 'Every police station is statutorily mandated to record information relating to the commission of a cognizable offense regardless of territorial jurisdiction—known as a "Zero FIR". The station house officer (SHO) cannot refuse registration on grounds that the crime occurred outside their police station limits; they must register it and transfer it to the jurisdictional police station.',
      citizenRights: [
        'Right to file a Zero FIR at the nearest police station in case of emergency or cognizable offense.',
        'Right to receive a free copy of the recorded FIR immediately upon registration.',
        'Action: If an officer refuses to register an FIR, send the written complaint by registered post to the Superintendent of Police (SP) under Section 173(4) BNSS.',
      ],
      officialUrl: 'https://bprd.nic.in/',
    ),
    StatutoryLaw(
      id: 'law_police_arrest',
      title: 'Statutory Rights of Arrested Persons & Women Protection',
      domain: 'Police & FIR',
      actCitation: 'Bharatiya Nagarik Suraksha Sanhita, 2023 (BNSS) / D.K. Basu Guidelines',
      sectionNumber: 'Section 47, Section 48, Section 50 & Section 58 BNSS',
      plainExplanation: 'An arrested person has the statutory right to be informed immediately of the full particulars and grounds of the arrest, and the right to bail if arrested for a bailable offense. Under Section 47 BNSS, no woman shall be arrested after sunset and before sunrise except in exceptional circumstances with the prior written permission of a Judicial Magistrate.',
      citizenRights: [
        'Right to inform a relative, friend, or nominated person immediately upon arrest (Section 58 BNSS).',
        'Right to be examined by a registered medical officer every 48 hours during custody.',
        'Right of women to be searched only by a female police officer with strict decency.',
      ],
      officialUrl: 'https://mha.gov.in/',
    ),

    // CYBERLAWS & DIGITAL SAFETY
    StatutoryLaw(
      id: 'law_cyber_itact',
      title: 'Protection against Cyber Fraud, Identity Theft & Phishing',
      domain: 'Cyberlaws',
      actCitation: 'The Information Technology Act, 2000 (As amended by IT Act 2008)',
      sectionNumber: 'Section 66C (Identity Theft) & Section 66D (Cheating by Personation)',
      plainExplanation: 'Section 66C prescribes imprisonment up to 3 years and fine up to Rs. 1 lakh for fraudulently making use of another person\'s electronic signature, password, Aadhaar, or unique identification feature. Section 66D criminalizes cheating by personation using a computer resource or smartphone.',
      citizenRights: [
        'Right to report online financial fraud, UPI scams, and OTP fraud to the National Cyber Crime Reporting Portal.',
        'Right to immediate assistance via National Cybercrime Helpline 1930 to freeze fraudulent bank transfers before withdrawal.',
        'Action: Dial 1930 immediately or log on to cybercrime.gov.in within 24 hours of unauthorized transaction.',
      ],
      officialUrl: 'https://cybercrime.gov.in/',
    ),

    // FARMER RIGHTS & LAND LAWS
    StatutoryLaw(
      id: 'law_agri_ppvfr',
      title: 'Farmers\' Statutory Right to Seed & Plant Varieties',
      domain: 'Farmer Rights',
      actCitation: 'Protection of Plant Varieties and Farmers\' Rights (PPV&FR) Act, 2001',
      sectionNumber: 'Section 39 (Farmers\' Rights)',
      plainExplanation: 'Section 39 statutorily recognizes that a farmer shall be entitled to save, use, sow, resow, exchange, share, or sell his farm produce including seed of a variety protected under the Act in the same manner as he was entitled before the coming into force of this Act, provided the farmer does not sell branded seed of a protected variety.',
      citizenRights: [
        'Right to save, replant, and exchange farm seeds without paying royalties to seed corporations.',
        'Right to claim compensation from seed breeders if protected seed varieties fail to provide expected yield under specified conditions.',
        'Action: File a claim with the PPV&FR Authority if commercial seeds fail to perform as advertised.',
      ],
      officialUrl: 'https://plantauthority.gov.in/',
    ),

    // LABOR & MGNREGA STATUTORY RIGHTS
    StatutoryLaw(
      id: 'law_labor_mgnrega',
      title: 'Statutory Right to Guaranteed Wage Employment & Unemployment Allowance',
      domain: 'Labor & MGNREGA',
      actCitation: 'Mahatma Gandhi National Rural Employment Guarantee Act, 2005',
      sectionNumber: 'Section 7 (Unemployment Allowance) & Schedule II',
      plainExplanation: 'MGNREGA is not just a welfare scheme but a legally binding statutory right. If an applicant for employment under the Act is not provided work within fifteen (15) days of receipt of application, they shall be entitled to a daily unemployment allowance paid by the State Government at a rate not less than one-fourth of the wage rate for the first 30 days.',
      citizenRights: [
        'Right to receive wage payment within 15 days of work completion; delay entitles workers to statutory compensation.',
        'Right to demand unemployment allowance if work is not allotted within 15 days of formal written demand.',
        'Action: Submit written demand for work with dated receipt to Gram Rozgar Sevak or Panchayat Secretary.',
      ],
      officialUrl: 'https://nrega.nic.in/',
    ),
  ];

  // 3. CITIZEN DOCUMENT VAULT ITEMS
  static final List<CitizenDocument> initialDocuments = [
    CitizenDocument(
      id: 'doc_aadhaar',
      docName: 'Aadhaar Card (UIDAI)',
      issuer: 'Unique Identification Authority of India',
      description: 'Mandatory 12-digit biometric identity number for all DBT scheme subsidies, PM-KISAN, and e-KYC.',
    ),
    CitizenDocument(
      id: 'doc_pan',
      docName: 'PAN Card / Form 60',
      issuer: 'Income Tax Department, Govt of India',
      description: 'Required for Kisan Credit Card (KCC), Stand-Up India loans, and banking transactions above Rs. 50,000.',
    ),
    CitizenDocument(
      id: 'doc_land',
      docName: 'Land Ownership Proof (Khata / Patta / 7-12)',
      issuer: 'State Revenue & Land Records Department',
      description: 'Essential proof of agricultural landholding required for PM-KISAN, PMFBY crop insurance, and KCC crop loans.',
    ),
    CitizenDocument(
      id: 'doc_bank',
      docName: 'Bank Passbook with IFSC Code',
      issuer: 'Scheduled Commercial Bank / Post Office',
      description: 'Active savings account linked with Aadhaar for receiving direct benefit transfers (DBT).',
    ),
    CitizenDocument(
      id: 'doc_caste',
      docName: 'Caste Certificate (SC / ST / OBC / EWS)',
      issuer: 'District Magistrate / Tehsildar / Revenue Officer',
      description: 'Required for Stand-Up India entrepreneurship loans, scholarship schemes, and reservation benefits.',
    ),
    CitizenDocument(
      id: 'doc_income',
      docName: 'Annual Income Certificate / BPL Card',
      issuer: 'Tehsildar / Revenue Department / Gram Panchayat',
      description: 'Proof of family income required for Ayushman Bharat (PM-JAY), housing grants, and welfare subsidies.',
    ),
    CitizenDocument(
      id: 'doc_jobcard',
      docName: 'MGNREGA Job Card',
      issuer: 'Gram Panchayat / Ministry of Rural Development',
      description: 'Mandatory registration card for claiming 100 days guaranteed employment and PMAY-G housing assistance.',
    ),
  ];
}
