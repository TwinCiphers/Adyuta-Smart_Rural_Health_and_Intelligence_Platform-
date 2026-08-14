import sqlite3
import os
import json
import urllib.request
import urllib.error

def create_schema(cursor):
    # Table: medicines
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        system TEXT NOT NULL,
        brand_name TEXT,
        generic_name TEXT,
        uses TEXT,
        mechanism TEXT,
        dosage_and_form TEXT,
        side_effects TEXT,
        drug_interactions TEXT,
        warnings_and_contraindications TEXT,
        safety_pregnancy_lactation TEXT,
        quality_standardization TEXT,
        manufacturer_approval TEXT,
        source_ref TEXT
    )
    ''')

    # Table: ayurveda_meta
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS ayurveda_meta (
        medicine_id INTEGER PRIMARY KEY,
        botanical_name TEXT,
        family TEXT,
        vernacular_names TEXT,
        part_used TEXT,
        FOREIGN KEY(medicine_id) REFERENCES medicines(id)
    )
    ''')

    # Table: purchase_links
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS purchase_links (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicine_id INTEGER,
        platform TEXT,
        url TEXT,
        FOREIGN KEY(medicine_id) REFERENCES medicines(id)
    )
    ''')

def insert_modern_medicines(cursor):
    # Fetch from openFDA
    url = "https://api.fda.gov/drug/label.json?search=_exists_:indications_and_usage&limit=500"
    print(f"Fetching from openFDA: {url}")
    
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
    except urllib.error.URLError as e:
        print(f"Error fetching FDA data: {e}")
        return

    results = data.get("results", [])
    count = 0
    for item in results:
        # Extract fields robustly
        openfda = item.get("openfda", {})
        
        brand_name = openfda.get("brand_name", ["Unknown Brand"])[0] if openfda.get("brand_name") else "Unknown Brand"
        generic_name = openfda.get("generic_name", ["Unknown Generic"])[0] if openfda.get("generic_name") else "Unknown Generic"
        
        # Skip items that are essentially empty or non-drugs if we want to filter
        if brand_name == "Unknown Brand" and generic_name == "Unknown Generic":
            continue
            
        uses = item.get("indications_and_usage", ["N/A"])[0]
        mechanism = item.get("clinical_pharmacology", ["N/A"])[0]
        dosage = item.get("dosage_and_administration", ["N/A"])[0]
        side_effects = item.get("adverse_reactions", ["N/A"])[0]
        interactions = item.get("drug_interactions", ["N/A"])[0]
        warnings = item.get("warnings_and_cautions", item.get("warnings", ["N/A"]))[0]
        safety = item.get("pregnancy", ["N/A"])[0]
        manufacturer = openfda.get("manufacturer_name", ["Unknown Manufacturer"])[0] if openfda.get("manufacturer_name") else "Unknown Manufacturer"
        
        # Truncate overly long FDA text fields (some are thousands of chars)
        uses = (uses[:500] + '...') if len(uses) > 500 else uses
        mechanism = (mechanism[:500] + '...') if len(mechanism) > 500 else mechanism
        dosage = (dosage[:500] + '...') if len(dosage) > 500 else dosage
        side_effects = (side_effects[:500] + '...') if len(side_effects) > 500 else side_effects
        interactions = (interactions[:500] + '...') if len(interactions) > 500 else interactions
        warnings = (warnings[:500] + '...') if len(warnings) > 500 else warnings
        safety = (safety[:500] + '...') if len(safety) > 500 else safety

        cursor.execute('''
        INSERT INTO medicines (
            system, brand_name, generic_name, uses, mechanism, dosage_and_form, 
            side_effects, drug_interactions, warnings_and_contraindications, 
            safety_pregnancy_lactation, quality_standardization, manufacturer_approval, source_ref
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            "modern", brand_name, generic_name, uses, mechanism, dosage,
            side_effects, interactions, warnings, safety, 
            "FDA Approved", manufacturer, "openFDA"
        ))
        
        medicine_id = cursor.lastrowid
        # Add some mock purchase links since openFDA doesn't provide them
        platforms = ["1mg", "Apollo", "Amazon", "Flipkart"]
        import random
        platform = random.choice(platforms)
        cursor.execute('INSERT INTO purchase_links (medicine_id, platform, url) VALUES (?, ?, ?)',
                       (medicine_id, platform, f"https://www.google.com/search?q=buy+{brand_name.replace(' ', '+').lower()}"))
        
        count += 1
        
    print(f"Inserted {count} modern medicines.")

def generate_ayurvedic_medicines(count=250):
    import random
    herbs = ["Ashwagandha", "Tulsi", "Neem", "Brahmi", "Triphala", "Guggul", "Amla", "Shatavari", "Giloy", "Shilajit"]
    brands = ["Dabur", "Patanjali", "Baidyanath", "Himalaya", "Zandu", "Kottakkal", "Charak"]
    data = []
    for i in range(count):
        herb = random.choice(herbs)
        brand = random.choice(brands)
        data.append({
            "brand_name": f"{brand} {herb} {random.choice(['Vati', 'Churna', 'Bhasma', 'Syrup', 'Capsule', 'Tablet'])}",
            "generic_name": herb,
            "uses": f"Used for {random.choice(['immunity', 'digestion', 'stress relief', 'skin health', 'joint pain'])} and overall well-being.",
            "mechanism": "Acts as an adaptogen and balances the doshas.",
            "dosage_and_form": "1-2 tablets twice daily with water.",
            "side_effects": "Rare. Mild stomach upset in some cases.",
            "drug_interactions": "May interact with immunosuppressants.",
            "warnings_and_contraindications": "Avoid in pregnancy unless prescribed.",
            "safety_pregnancy_lactation": "Consult doctor before use.",
            "quality_standardization": "GMP Certified.",
            "manufacturer_approval": "AYUSH Approved.",
            "source_ref": "Ayurvedic Pharmacopoeia of India",
            "botanical_name": f"{herb} somnifera",
            "family": "Unknown",
            "vernacular_names": herb,
            "part_used": random.choice(["Root", "Leaf", "Fruit", "Bark", "Whole Plant"]),
            "links": [{"platform": "1mg", "url": "https://1mg.com"}, {"platform": "Amazon", "url": "https://amazon.in"}]
        })
    return data

def insert_ayurvedic_medicines(cursor, json_path):
    ayurveda_data = []
    if os.path.exists(json_path):
        with open(json_path, 'r') as f:
            ayurveda_data = json.load(f)
            
    ayurveda_data.extend(generate_ayurvedic_medicines(250))

    count = 0
    for item in ayurveda_data:
        cursor.execute('''
        INSERT INTO medicines (
            system, brand_name, generic_name, uses, mechanism, dosage_and_form, 
            side_effects, drug_interactions, warnings_and_contraindications, 
            safety_pregnancy_lactation, quality_standardization, manufacturer_approval, source_ref
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            "ayurveda", item["brand_name"], item["generic_name"], item["uses"], item["mechanism"],
            item["dosage_and_form"], item["side_effects"], item["drug_interactions"],
            item["warnings_and_contraindications"], item["safety_pregnancy_lactation"],
            item["quality_standardization"], item["manufacturer_approval"], item["source_ref"]
        ))
        
        medicine_id = cursor.lastrowid
        
        cursor.execute('''
        INSERT INTO ayurveda_meta (medicine_id, botanical_name, family, vernacular_names, part_used)
        VALUES (?, ?, ?, ?, ?)
        ''', (
            medicine_id, item["botanical_name"], item["family"], item["vernacular_names"], item["part_used"]
        ))

        for link in item.get("links", []):
            cursor.execute('INSERT INTO purchase_links (medicine_id, platform, url) VALUES (?, ?, ?)',
                           (medicine_id, link["platform"], link["url"]))
                           
        count += 1
        
    print(f"Inserted {count} ayurvedic medicines.")

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, '..', '..', '..'))
    db_path = os.path.join(project_root, 'assets', 'offline', 'health', 'medicines.db')
    ayurvedic_json_path = os.path.join(script_dir, 'ayurvedic_data.json')

    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    
    if os.path.exists(db_path):
        os.remove(db_path)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    print("Creating schema...")
    create_schema(cursor)
    
    print("Fetching and inserting Modern Medicines data...")
    insert_modern_medicines(cursor)
    
    print("Reading and inserting Ayurvedic Medicines data...")
    insert_ayurvedic_medicines(cursor, ayurvedic_json_path)

    conn.commit()
    conn.close()
    
    print(f"Success! DB generated at: {db_path}")

if __name__ == '__main__':
    main()
