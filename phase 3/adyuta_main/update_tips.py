import re

path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\core\services\safety_guide_service.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

# Define the 100+ tips
tips = [
    # Women
    ('Protection of Women from Domestic Violence Act, 2005', 'Right to reside in a shared household, protection orders, and monetary relief against abuse.', 'Women'),
    ('Sexual Harassment of Women at Workplace Act, 2013', 'Mandates an Internal Complaints Committee (ICC) in workplaces with 10+ employees.', 'Women'),
    ('Right to Zero FIR', 'A woman can file a police complaint at ANY police station, regardless of jurisdiction.', 'Women'),
    ('Free Legal Aid', 'Women are entitled to free legal aid under the Legal Services Authorities Act.', 'Women'),
    ('No Arrests at Night', 'Women cannot be arrested between sunset and sunrise except under exceptional circumstances by a woman officer with a magistrate\'s order.', 'Women'),
    ('Right to Privacy during Interrogation', 'A woman can request a female police officer to interrogate her in the presence of family or friends.', 'Women'),
    ('Maternity Benefit Act', 'Right to 26 weeks of paid maternity leave for women working in establishments with 10 or more employees.', 'Women'),
    ('Equal Remuneration Act', 'Employers must pay equal wages to men and women for the same work.', 'Women'),
    ('Right against Workplace Harassment', 'Any unwelcome physical, verbal, or non-verbal conduct of a sexual nature is illegal.', 'Women'),
    ('Right to Anonymity', 'Victims of sexual assault have the right to keep their identity anonymous.', 'Women'),
    ('Cyber Harassment Protection', 'Under IT Act Sec 67, publishing explicit images without consent is a punishable offense.', 'Women'),
    ('Dowry Prohibition Act', 'Giving or taking dowry is a criminal offense punishable by imprisonment.', 'Women'),
    ('Right to Safe Abortion', 'Medical Termination of Pregnancy Act allows abortion up to 24 weeks under specific conditions.', 'Women'),
    ('Stalking is a Crime', 'Repeatedly following or contacting a woman against her will (physical or digital) is punishable under IPC 354D.', 'Women'),
    ('Voyeurism Protection', 'Watching or capturing images of a woman engaging in a private act without consent is illegal under IPC 354C.', 'Women'),
    ('Right to Virtual Complaints', 'Women can register complaints via email or registered post to the police commissioner.', 'Women'),
    ('Police Cannot Refuse FIR', 'Refusal to register an FIR for serious offenses (like assault) by an officer is a punishable crime.', 'Women'),
    
    # Farmers
    ('Kisan Credit Card Scheme', 'Provides farmers with timely and adequate credit support for agricultural expenses.', 'Farmers'),
    ('PM-KISAN Scheme', 'Direct income support of ₹6,000 per year transferred directly to the bank accounts of landholding farmers.', 'Farmers'),
    ('Pradhan Mantri Fasal Bima Yojana', 'Crop insurance scheme offering financial support against natural calamities, pests, and diseases.', 'Farmers'),
    ('Minimum Support Price (MSP)', 'The government guarantees a minimum price for 23 major agricultural commodities.', 'Farmers'),
    ('e-NAM (National Agriculture Market)', 'A pan-India electronic trading portal networking APMC mandis to create a unified national market.', 'Farmers'),
    ('Right to Fair Compensation in Land Acquisition', 'Ensures fair compensation, resettlement, and rehabilitation for land acquired by the government.', 'Farmers'),
    ('Soil Health Card Scheme', 'Provides crop-wise recommendations of nutrients and fertilizers required for specific farms.', 'Farmers'),
    ('Pesticide Safety', 'Always wear protective gear (gloves, masks, long sleeves) when spraying chemical pesticides.', 'Farmers'),
    ('Safe Storage of Chemicals', 'Store fertilizers and pesticides in a locked, dry place away from children and animal feed.', 'Farmers'),
    ('Tractor Safety', 'Never allow children to ride on tractors. Ensure ROPS (Roll-Over Protective Structures) are installed.', 'Farmers'),
    ('Protection of Plant Varieties Act', 'Farmers have the right to save, use, sow, resow, exchange, share, or sell their farm produce.', 'Farmers'),
    ('Machinery Maintenance', 'Always turn off the engine and wait for moving parts to stop before unclogging farm machinery.', 'Farmers'),
    ('Heat Stress Prevention', 'Work during cooler parts of the day and drink plenty of water to avoid heatstroke in fields.', 'Farmers'),
    ('Electrical Safety on Farms', 'Keep tall equipment and irrigation pipes away from overhead power lines.', 'Farmers'),
    ('Animal Handling', 'Approach livestock calmly. Avoid their blind spots and have a clear escape route.', 'Farmers'),
    ('Right to Dispute Resolution', 'Farmers can approach the Sub-Divisional Magistrate for disputes under contract farming agreements.', 'Farmers'),
    ('Organic Farming Certification', 'Farmers have the right to apply for Paramparagat Krishi Vikas Yojana for organic certification.', 'Farmers'),

    # Children
    ('Right to Education Act (RTE)', 'Free and compulsory education for all children between the ages of 6 and 14.', 'Children'),
    ('POCSO Act, 2012', 'Protects children from offenses of sexual assault, sexual harassment, and pornography.', 'Children'),
    ('Child Labour Prohibition Act', 'Employment of children below 14 years is completely prohibited in any occupation.', 'Children'),
    ('Juvenile Justice Act', 'Ensures care, protection, and rehabilitation of children in conflict with law or in need of care.', 'Children'),
    ('Right against Corporal Punishment', 'Physical punishment and mental harassment in schools are strictly prohibited under RTE.', 'Children'),
    ('Cyberbullying Protection', 'Children facing online bullying can report to Cyber Crime portals or call 1930.', 'Children'),
    ('Stranger Danger Rule', 'Teach children to never accept rides, gifts, or follow strangers without parental permission.', 'Children'),
    ('Good Touch vs Bad Touch', 'Educate children early about their body boundaries and safe vs unsafe touches.', 'Children'),
    ('Emergency Numbers Memory', 'Children should memorize their home address and at least two emergency family phone numbers.', 'Children'),
    ('Internet Safety Rules', 'Do not share personal information, photos, or passwords online.', 'Children'),
    ('Anti-Ragging Laws', 'Ragging in educational institutions is a criminal offense and can lead to immediate expulsion.', 'Children'),
    ('Bicycle Helmet Rule', 'Always wear a fitted helmet when riding a bicycle or skateboard.', 'Children'),
    ('Water Safety', 'Never swim alone. Children must always be supervised around pools or open water.', 'Children'),
    ('Fire Drill Knowledge', 'Children should know the fire escape plan at home and in their school.', 'Children'),
    ('Right to be Heard', 'Children have the right to express their views freely in all matters affecting them.', 'Children'),
    ('Protection from Child Marriage', 'The legal age for marriage is 18 for girls and 21 for boys; child marriage is a punishable offense.', 'Children'),

    # Elderly
    ('Maintenance and Welfare of Parents Act', 'Adult children or heirs are legally obligated to provide maintenance to senior citizens.', 'Elderly'),
    ('Right to Reclaim Property', 'Seniors who transferred property to children on the condition of care can revoke the transfer if abandoned.', 'Elderly'),
    ('Senior Citizen Helplines', 'Call 14567 (Elder Line) for rescue, legal guidance, and emotional support.', 'Elderly'),
    ('Special Tax Benefits', 'Senior citizens (60+) and super senior citizens (80+) enjoy higher income tax exemption limits.', 'Elderly'),
    ('Banking Privileges', 'Banks provide higher interest rates on FDs and special door-step banking services for seniors.', 'Elderly'),
    ('Concessions in Travel', 'Various concessions on train and flight tickets are available for senior citizens.', 'Elderly'),
    ('Fall Prevention', 'Keep floors clear of clutter, secure loose rugs, and install grab bars in bathrooms.', 'Elderly'),
    ('Medication Management', 'Use a pill organizer and keep an updated list of all medications and dosages.', 'Elderly'),
    ('Emergency Contacts', 'Keep a list of emergency contacts, doctors, and neighbors next to the phone.', 'Elderly'),
    ('Protection from Scams', 'Never share OTPs, PINs, or bank details over the phone. Bank officials will never ask for them.', 'Elderly'),
    ('Regular Health Checkups', 'Schedule routine eye, hearing, and physical exams to catch issues early.', 'Elderly'),
    ('Legal Will Preparation', 'Drafting a clear, registered will ensures property distribution as per your wishes.', 'Elderly'),
    ('Right to Dignity', 'Seniors have the right to live a life of dignity, free from verbal or physical abuse.', 'Elderly'),
    ('Pension Schemes', 'Eligible seniors can claim pensions under IGNOAPS and state-specific schemes.', 'Elderly'),
    ('Priority Hearings', 'Senior citizens are entitled to priority hearings in courts and tribunals.', 'Elderly'),

    # General Public
    ('Right to Information (RTI)', 'Citizens can request information from any public authority to ensure transparency.', 'General Public'),
    ('Consumer Protection Act', 'Consumers have the right to be protected against unfair trade practices and defective goods.', 'General Public'),
    ('Right to FIR Copy', 'You have the right to receive a free copy of the FIR immediately after it is registered.', 'General Public'),
    ('No Arrest for Minor Traffic Violations', 'Police cannot arrest you for standard traffic violations; they can only issue a challan.', 'General Public'),
    ('Right to Medical Care', 'Hospitals cannot refuse emergency medical treatment to a victim under any circumstances.', 'General Public'),
    ('Good Samaritan Law', 'Bystanders who help road accident victims are protected from civil/criminal liability and police harassment.', 'General Public'),
    ('Maximum Retail Price (MRP)', 'Shopkeepers cannot charge more than the printed MRP on packaged goods.', 'General Public'),
    ('Police Search Warrant', 'Police generally need a valid warrant to search your home, except in specific urgent scenarios.', 'General Public'),
    ('Right to Silence', 'An accused person cannot be forced to be a witness against themselves (Article 20(3)).', 'General Public'),
    ('Gas Cylinder Insurance', 'In case of an LPG cylinder blast, victims are entitled to insurance cover from the gas company.', 'General Public'),
    ('Bank Fraud Protection', 'If you report an unauthorized banking transaction within 3 days, your liability is zero.', 'General Public'),
    ('Cheque Bounce Rights', 'You can file a criminal case against the issuer of a bounced cheque under Section 138 of the NI Act.', 'General Public'),
    ('Right against Handcuffing', 'Routine handcuffing of an accused is illegal unless ordered by a magistrate or if there is a flight risk.', 'General Public'),
    ('Maternity Leave for Adoptive Mothers', 'Adoptive mothers are entitled to 12 weeks of maternity leave under the Act.', 'General Public'),
    ('First Aid Basics', 'Always keep a first aid kit in your vehicle and home.', 'General Public'),
    ('Fire Extinguisher PASS', 'Pull the pin, Aim the nozzle, Squeeze the handle, Sweep side to side.', 'General Public'),
    ('Earthquake Safety', 'Drop, Cover, and Hold on. Do not use elevators during an earthquake.', 'General Public'),
    ('Cyber Frauds (1930)', 'Call 1930 immediately if you are a victim of financial cyber fraud to freeze the transaction.', 'General Public'),

    # Students / Youth
    ('Right to Protest', 'Peaceful assembly without arms is a fundamental right (Article 19).', 'Students'),
    ('Anti-Ragging Protection', 'UGC mandates strict anti-ragging policies. Call 1800-180-5522 to report ragging.', 'Students'),
    ('Right to Re-evaluation', 'Students have the right to request re-evaluation or view their answer sheets under RTI.', 'Students'),
    ('Educational Loans', 'Banks cannot reject an education loan application arbitrarily if all criteria are met.', 'Students'),
    ('Protection against Police Harassment', 'Police cannot enter a university campus without permission from the university authorities.', 'Students'),
    ('Cyber Bullying', 'Spreading rumors, morphing photos, or threatening online is punishable under the IT Act.', 'Students'),
    ('Mental Health Act', 'Students have the right to access mental healthcare without discrimination or stigma.', 'Students'),
    ('Consent is Mandatory', 'Any physical relationship requires explicit, voluntary consent. Silence is not consent.', 'Students'),
    ('Revenge Porn Laws', 'Sharing intimate photos without consent is a crime under Section 67A of the IT Act.', 'Students'),
    ('Right to Vote', 'Every citizen above 18 years has the constitutional right to be registered as a voter.', 'Students'),
    ('Traffic Rules (No Helmet)', 'Riding without a helmet or license can lead to heavy fines and vehicle impounding.', 'Students'),
    ('Drunk Driving', 'Driving with alcohol limits above 30mg/100ml blood is a punishable offense with jail time.', 'Students'),
    ('Fake Job Offers', 'Verify company credentials before paying any "security deposit" for job offers.', 'Students'),
    ('Right to Hostel Safety', 'Hostel authorities are legally responsible for ensuring the physical safety of residents.', 'Students'),
    
    # Digital Users
    ('Data Privacy Rights', 'Under the DPDP Act, you have the right to know what personal data is collected and request its deletion.', 'Digital Users'),
    ('Two-Factor Authentication', 'Always enable 2FA on your email, banking, and social media accounts.', 'Digital Users'),
    ('Phishing Awareness', 'Never click on unverified links in SMS or emails claiming your bank account is blocked.', 'Digital Users'),
    ('Public Wi-Fi Danger', 'Avoid logging into banking apps or making transactions on free public Wi-Fi networks.', 'Digital Users'),
    ('Strong Passwords', 'Use complex passwords with a mix of letters, numbers, and symbols. Do not reuse them.', 'Digital Users'),
    ('Report Stolen Phone', 'Block your stolen phone\'s IMEI immediately via the CEIR government portal.', 'Digital Users'),
    ('Fake Customer Care', 'Never search for customer care numbers on Google. Only use official apps or websites.', 'Digital Users'),
    ('Screen Lock', 'Keep a strong screen lock/biometric on your phone to protect data if lost.', 'Digital Users'),
    ('App Permissions', 'Do not grant camera/microphone/contact permissions to apps that do not need them.', 'Digital Users'),
    ('Software Updates', 'Regularly update your phone\'s OS and apps to patch security vulnerabilities.', 'Digital Users'),
]

pack_str = "      final pack = [\n"
for t in tips:
    # Escape quotes
    content = t[1].replace("'", "\\'")
    pack_str += f"        ('{t[0]}', '{content}', '{t[2]}'),\n"
pack_str += "      ];"

# We replace the old pack definition
# The old file has:
#       final pack = [
#          ...
#       ];
# We will match from `final pack = [` until `];`
code = re.sub(r'final pack = \[\s*\(.*?\s*\];', pack_str, code, flags=re.DOTALL)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
