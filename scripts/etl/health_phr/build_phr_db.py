import sqlite3
import os

def create_schema(cursor):
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        relation TEXT,
        dob TEXT,
        gender TEXT,
        blood_group TEXT,
        emergency_contact_name TEXT,
        emergency_contact_phone TEXT
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS conditions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        condition_type TEXT,
        condition_name TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY(profile_id) REFERENCES profiles(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS vitals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        timestamp TEXT NOT NULL,
        blood_pressure_sys INTEGER,
        blood_pressure_dia INTEGER,
        blood_sugar REAL,
        weight_kg REAL,
        temperature_f REAL,
        pulse INTEGER,
        FOREIGN KEY(profile_id) REFERENCES profiles(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        medicine_name TEXT NOT NULL,
        dosage TEXT,
        start_date TEXT,
        end_date TEXT,
        is_active INTEGER DEFAULT 1,
        FOREIGN KEY(profile_id) REFERENCES profiles(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS visits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        visit_date TEXT NOT NULL,
        doctor_name TEXT,
        facility_name TEXT,
        chief_complaint TEXT,
        advice_notes TEXT,
        FOREIGN KEY(profile_id) REFERENCES profiles(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS attachments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visit_id INTEGER,
        file_path TEXT NOT NULL,
        attachment_type TEXT,
        FOREIGN KEY(visit_id) REFERENCES visits(id)
    )
    ''')

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, '..', '..', '..'))
    db_path = os.path.join(project_root, 'assets', 'offline', 'health', 'phr.db')

    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    
    if os.path.exists(db_path):
        os.remove(db_path)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    create_schema(cursor)

    conn.commit()
    conn.close()
    
    print(f"Success! Empty PHR DB schema generated at: {db_path}")

if __name__ == '__main__':
    main()
