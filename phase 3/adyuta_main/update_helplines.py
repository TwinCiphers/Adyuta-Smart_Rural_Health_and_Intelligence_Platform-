import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\safety_module\lib\core\services\helpline_service.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

new_core = """      final core = [
        ('112', 'National Emergency (ERSS)', 'All-in-one Emergency', 'Govt of India'),
        ('100', 'Police Control Room', 'Emergency Police', 'Police Dept'),
        ('101', 'Fire Brigade', 'Fire & Rescue', 'Fire Dept'),
        ('102', 'Ambulance', 'Emergency Medical', 'Health Dept'),
        ('108', 'Emergency Disaster Medical', 'Disaster Medical Response', 'Govt of India'),
        ('104', 'Health Helpline', 'Medical Advice & Info', 'Health Dept'),
        ('1091', 'Women Helpline', 'Women in Distress', 'NCW'),
        ('181', 'Women Helpline (Domestic Abuse)', 'Domestic Abuse', 'Govt of India'),
        ('1098', 'Child Helpline (Childline)', 'Child Protection', 'Ministry of WCD'),
        ('14567', 'Senior Citizens (Elder Line)', 'Elder Care', 'Govt of India'),
        ('1930', 'Cyber Crime Helpline', 'Financial Fraud & Cyber', 'MHA'),
        ('155260', 'Cyber Fraud (Alternate)', 'Cyber Crime reporting', 'MHA'),
        ('1073', 'Road Accident', 'Highway Rescue', 'NHAI'),
        ('1033', 'National Highway Helpline', 'Highway Emergency', 'NHAI'),
        ('1363', 'Tourist Helpline', 'Assistance for Tourists', 'Tourism Dept'),
        ('1072', 'Train Accident', 'Railways Helpline', 'Indian Railways'),
        ('139', 'Railway Security & Enquiry', 'Railway Security', 'Indian Railways'),
        ('1070', 'Relief Commissioner', 'Natural Disasters', 'NDMA'),
        ('1077', 'Earthquake / Flood', 'Disaster Management', 'NDMA'),
        ('1800110456', 'Kisan Call Centre', 'Agricultural Assistance', 'Agri Dept'),
        ('1906', 'LPG Leak Helpline', 'Gas Leak Emergency', 'MoPNG'),
        ('1097', 'AIDS Helpline', 'HIV/AIDS Information', 'NACO'),
        ('1800114000', 'Anti-Ragging Helpline', 'Students Anti-Ragging', 'UGC'),
        ('1056', 'Emergency Relief Centre', 'State Emergency Relief', 'Govt of India'),
        ('14443', 'Ayush Covid Helpline', 'Ayush Health Services', 'Ministry of Ayush'),
        ('1094', 'Missing Children/Women', 'Missing Persons', 'Police Dept'),
        ('1090', 'Anti-Terror Helpline', 'Terrorism Alert', 'Police Dept'),
        ('1800111363', 'Tourist Helpline (Toll Free)', 'Tourist Safety', 'Tourism Dept'),
        ('112', 'Pan-India Emergency', 'Single Emergency Number', 'Govt of India'),
        ('15100', 'Army Helpine', 'Indian Army Assistance', 'Indian Army'),
      ];"""

code = re.sub(r'final core = \[.*?\];', new_core, code, flags=re.DOTALL)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
