import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\governance_module\lib\data\gov_data.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

# Expand schemes
new_schemes = """
    GovernmentScheme(
      id: 'scheme_pmsvanidhi',
      title: 'PM SVANidhi (Micro-credit for Street Vendors)',
      ministry: 'Ministry of Housing and Urban Affairs',
      beneficiaries: 'Street vendors, hawkers in urban/semi-urban areas',
      category: 'Finance',
      eligibilityCriteria: [
        'Vendors operating before March 24, 2020.',
        'Possession of Certificate of Vending/Identity Card issued by ULBs.',
      ],
      requiredDocuments: [
        'Aadhaar Card linked with mobile number',
        'Voter ID',
        'Bank Passbook',
      ],
      benefits: 'Working capital loan up to Rs. 10,000 at subsidized interest rate, with incentive of 7% interest subvention for timely repayment.',
      officialWebsite: 'https://pmsvanidhi.mohua.gov.in/',
    ),
    GovernmentScheme(
      id: 'scheme_ujjwala',
      title: 'Pradhan Mantri Ujjwala Yojana (PMUY)',
      ministry: 'Ministry of Petroleum and Natural Gas',
      beneficiaries: 'Women belonging to BPL families',
      category: 'Welfare',
      eligibilityCriteria: [
        'Applicant must be a woman above 18 years of age.',
        'Must belong to BPL household without any existing LPG connection.',
        'Included in SECC 2011 list or SC/ST households, PMAY-G, AAY.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Ration Card (BPL)',
        'Bank Account Details',
        'Passport size photo',
      ],
      benefits: 'Financial support of Rs. 1600 for LPG connection, free first refill and hotplate.',
      officialWebsite: 'https://www.pmuy.gov.in/',
    ),
    GovernmentScheme(
      id: 'scheme_m मुद्रा',
      title: 'Pradhan Mantri Mudra Yojana (PMMY)',
      ministry: 'Ministry of Finance',
      beneficiaries: 'Micro and small enterprises, non-corporate small businesses',
      category: 'Finance',
      eligibilityCriteria: [
        'Any Indian citizen with a business plan for a non-farm income generating activity.',
        'Manufacturing, processing, trading, or service sector.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'PAN Card',
        'Business Registration Certificate (if applicable)',
        'Project Report',
      ],
      benefits: 'Loans up to Rs. 10 Lakhs categorized as Shishu (up to 50k), Kishore (50k-5L), and Tarun (5L-10L) without collateral.',
      officialWebsite: 'https://www.mudra.org.in/',
    ),
    GovernmentScheme(
      id: 'scheme_atal_pension',
      title: 'Atal Pension Yojana (APY)',
      ministry: 'Ministry of Finance',
      beneficiaries: 'Unorganized sector workers',
      category: 'Finance',
      eligibilityCriteria: [
        'Indian citizen between the age of 18 and 40 years.',
        'Must have a savings bank account.',
        'Not a member of any statutory social security scheme.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Bank Passbook',
      ],
      benefits: 'Guaranteed minimum monthly pension of Rs. 1000 to Rs. 5000 from the age of 60 years.',
      officialWebsite: 'https://www.npscra.nsdl.co.in/scheme-details.php',
    ),
    GovernmentScheme(
      id: 'scheme_kanya_sumangala',
      title: 'Mukhya Mantri Kanya Sumangala Yojana (State Level)',
      ministry: 'Women and Child Development Department (UP)',
      beneficiaries: 'Girl children of the state',
      category: 'Women & Child',
      eligibilityCriteria: [
        'Resident of the state.',
        'Family income should be less than Rs. 3 Lakh per annum.',
        'Maximum 2 girls from a family can benefit.',
      ],
      requiredDocuments: [
        'Aadhaar Card of Parents/Guardian',
        'Income Certificate',
        'Birth Certificate of Girl Child',
        'Bank Account Details',
      ],
      benefits: 'Financial assistance of Rs. 15,000 provided in 6 phases from birth to graduation.',
      officialWebsite: 'https://mksy.up.gov.in/',
    ),"""

code = code.replace("static final List<GovernmentScheme> schemes = [", "static final List<GovernmentScheme> schemes = [\n" + new_schemes)

# Expand documents
new_docs = """
    CitizenDocument(id: 'doc_pan', docName: 'PAN Card', category: 'Identity & Tax', issuanceAuthority: 'Income Tax Department', description: 'Permanent Account Number for financial tracking.'),
    CitizenDocument(id: 'doc_voter', docName: 'Voter ID (EPIC)', category: 'Identity & Voting', issuanceAuthority: 'Election Commission of India', description: 'Proof of citizenship and voting rights.'),
    CitizenDocument(id: 'doc_driving', docName: 'Driving License', category: 'Identity & Transport', issuanceAuthority: 'RTO', description: 'Valid proof of identity and driving authorization.'),
    CitizenDocument(id: 'doc_passport', docName: 'Indian Passport', category: 'Identity & Travel', issuanceAuthority: 'Ministry of External Affairs', description: 'International travel identity document.'),
    CitizenDocument(id: 'doc_kcc', docName: 'Kisan Credit Card', category: 'Agriculture & Finance', issuanceAuthority: 'Banks', description: 'Credit card for agricultural expenses.'),
    CitizenDocument(id: 'doc_mgnrega', docName: 'MGNREGA Job Card', category: 'Employment & Rural', issuanceAuthority: 'Gram Panchayat', description: 'Proof of registration for rural employment.'),
"""
code = code.replace("static final List<CitizenDocument> initialDocuments = [", "static final List<CitizenDocument> initialDocuments = [\n" + new_docs)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
