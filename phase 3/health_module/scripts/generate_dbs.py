import sqlite3
import os

db_dir = r"c:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\assets\offline\health"
os.makedirs(db_dir, exist_ok=True)

# 1. Medicines
conn = sqlite3.connect(os.path.join(db_dir, "medicines.db"))
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS medicines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    system TEXT,
    brand_name TEXT,
    generic_name TEXT,
    uses TEXT,
    dosage_and_form TEXT,
    source_ref TEXT
)''')
c.execute("DELETE FROM medicines") # Clear existing
medicines_data = [
    ("Allopathic", "Paracetamol", "Acetaminophen", "Fever and mild to moderate pain.", "Tablet 500mg", "WHO Model List"),
    ("Allopathic", "Amoxicillin", "Amoxicillin", "Bacterial infections.", "Capsule 250mg", "WHO Model List"),
    ("Ayurvedic", "Ashwagandha", "Withania somnifera", "Stress, anxiety, and immunity.", "Powder 5g", "Ayurvedic Pharmacopoeia"),
    ("Allopathic", "Cetirizine", "Cetirizine", "Allergies, hay fever.", "Tablet 10mg", "WHO Model List"),
    ("Ayurvedic", "Triphala", "Terminalia chebula", "Digestive issues, constipation.", "Capsule 500mg", "Ayurvedic Pharmacopoeia"),
]
c.executemany("INSERT INTO medicines (system, brand_name, generic_name, uses, dosage_and_form, source_ref) VALUES (?, ?, ?, ?, ?, ?)", medicines_data)
conn.commit()
conn.close()

# 2. First Aid
conn = sqlite3.connect(os.path.join(db_dir, "firstaid.db"))
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS emergency_topics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    description TEXT,
    category TEXT,
    urgency_level TEXT,
    icon_name TEXT
)''')
c.execute('''CREATE TABLE IF NOT EXISTS emergency_steps (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    topic_id INTEGER,
    step_no INTEGER,
    type TEXT,
    text_content TEXT,
    image_path TEXT
)''')
c.execute("DELETE FROM emergency_topics")
c.execute("DELETE FROM emergency_steps")
topics_data = [
    ("Snake Bite", "Emergency response for venomous snake bites.", "Bites & Stings", "Critical", "snake"),
    ("Burns", "First aid for thermal burns.", "Injuries", "High", "fire"),
    ("Choking", "Heimlich maneuver and airway clearance.", "Breathing", "Critical", "choking"),
]
c.executemany("INSERT INTO emergency_topics (title, description, category, urgency_level, icon_name) VALUES (?, ?, ?, ?, ?)", topics_data)

steps_data = [
    (1, 1, "Immediate Action", "Keep the person completely still and calm to slow the spread of venom.", None),
    (1, 2, "Positioning", "Keep the bitten area below the level of the heart.", None),
    (1, 3, "Medical Help", "Call emergency services immediately. Do not try to suck the venom out.", None),
    (2, 1, "Cooling", "Run cool (not cold) water over the burn for 10-15 minutes.", None),
    (2, 2, "Protection", "Cover the burn with a sterile, non-stick bandage.", None),
    (3, 1, "Action", "Stand behind the person and wrap your arms around their waist. Give 5 quick inward and upward thrusts.", None),
]
c.executemany("INSERT INTO emergency_steps (topic_id, step_no, type, text_content, image_path) VALUES (?, ?, ?, ?, ?)", steps_data)
conn.commit()
conn.close()

# 3. MCH
conn = sqlite3.connect(os.path.join(db_dir, "mch.db"))
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS pregnancy_weeks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    week_no INTEGER,
    baby_growth TEXT,
    mother_changes TEXT,
    diet_tip TEXT,
    activity_tip TEXT,
    warning_signs TEXT
)''')
c.execute("DELETE FROM pregnancy_weeks")
mch_data = [
    (12, "Baby is the size of a plum. Organs are fully formed.", "Morning sickness may start to fade.", "Increase iron and folic acid intake.", "Light walking or prenatal yoga.", "Severe cramping or bleeding."),
    (20, "Baby is the size of a banana. You might feel first kicks.", "Belly is noticeably expanding.", "Calcium-rich foods for baby's bones.", "Avoid lying flat on your back.", "Severe headaches or swelling."),
    (28, "Baby is the size of an eggplant. Eyes can open and close.", "Backaches and leg cramps common.", "Small, frequent meals for heartburn.", "Stay hydrated and rest often.", "Decreased baby movement."),
]
c.executemany("INSERT INTO pregnancy_weeks (week_no, baby_growth, mother_changes, diet_tip, activity_tip, warning_signs) VALUES (?, ?, ?, ?, ?, ?)", mch_data)
conn.commit()
conn.close()

# 4. Nutrition
conn = sqlite3.connect(os.path.join(db_dir, "nutrition.db"))
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS foods (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    local_name TEXT,
    category TEXT,
    serving_size_g INTEGER,
    calories REAL
)''')
c.execute("DELETE FROM foods")
nutrition_data = [
    ("Ragi", "Finger Millet", "Grains", 100, 328.0),
    ("Moong Dal", "Green Gram", "Legumes", 100, 347.0),
    ("Palak", "Spinach", "Vegetables", 100, 23.0),
    ("Papaya", "Papita", "Fruits", 100, 43.0),
]
c.executemany("INSERT INTO foods (name, local_name, category, serving_size_g, calories) VALUES (?, ?, ?, ?, ?)", nutrition_data)
conn.commit()
conn.close()

# 5. Directory
conn = sqlite3.connect(os.path.join(db_dir, "directory.db"))
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS facilities (
    facility_id INTEGER PRIMARY KEY AUTOINCREMENT,
    facility_name TEXT,
    facility_type TEXT,
    system_of_medicine TEXT,
    address TEXT,
    phone TEXT,
    working_hours TEXT,
    is_24x7 INTEGER
)''')
c.execute("DELETE FROM facilities")
dir_data = [
    ("City General Hospital", "Hospital", "Allopathic", "123 Main St, Bangalore", "080-12345678", "Open 24 Hours", 1),
    ("Rural Health Center", "PHC", "Allopathic", "Village Rd, Tumkur", "0816-8765432", "9 AM - 4 PM", 0),
    ("Ayush Wellness Clinic", "Clinic", "Ayurvedic", "45 Temple St, Mysore", "0821-2345678", "10 AM - 6 PM", 0),
]
c.executemany("INSERT INTO facilities (facility_name, facility_type, system_of_medicine, address, phone, working_hours, is_24x7) VALUES (?, ?, ?, ?, ?, ?, ?)", dir_data)
conn.commit()
conn.close()

print("Successfully created SQLite databases!")
