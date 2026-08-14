import sqlite3
import os
import json

def create_schema(cursor):
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS mothers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        lmp_date TEXT,
        edd TEXT,
        blood_group TEXT,
        high_risk_flag INTEGER
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS pregnancy_weeks (
        week_no INTEGER PRIMARY KEY,
        baby_growth TEXT,
        mother_changes TEXT,
        diet_tip TEXT,
        activity_tip TEXT,
        warning_signs TEXT,
        audio_key TEXT
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS maternal_vaccines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE,
        title TEXT,
        recommended_time TEXT
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS children (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mother_id INTEGER,
        name TEXT,
        dob TEXT,
        sex TEXT,
        birth_weight REAL,
        FOREIGN KEY(mother_id) REFERENCES mothers(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS child_vaccines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE,
        title TEXT,
        age_label TEXT,
        min_age_days INTEGER,
        max_age_days INTEGER,
        optional_region_flag INTEGER
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS vaccine_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_type TEXT,
        person_id INTEGER,
        vaccine_code TEXT,
        due_date TEXT,
        taken_date TEXT,
        status TEXT
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS nutrition_cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stage TEXT,
        title TEXT,
        tip_text TEXT,
        local_food_examples TEXT
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS danger_signs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stage TEXT,
        sign_text TEXT,
        referral_level TEXT
    )
    ''')

def generate_pregnancy_weeks():
    weeks = []
    for w in range(1, 43):
        weeks.append({
            "week_no": w,
            "baby_growth": f"At week {w}, the baby is growing rapidly. Organs are developing." if w < 13 else (f"At week {w}, the baby is gaining weight." if w < 28 else f"At week {w}, the baby is preparing for birth."),
            "mother_changes": f"You may feel fatigue and nausea." if w < 13 else (f"You might feel the baby move." if w < 28 else f"You may experience Braxton Hicks contractions and backache."),
            "diet_tip": "Focus on folic acid and iron-rich foods.",
            "activity_tip": "Take short walks and rest when tired.",
            "warning_signs": "Severe abdominal pain or bleeding. Seek immediate help.",
            "audio_key": f"audio_week_{w}"
        })
    return weeks

def insert_data(cursor, json_path):
    data = {'pregnancy_weeks': [], 'maternal_vaccines': [], 'child_vaccines': [], 'nutrition_cards': [], 'danger_signs': []}
    if os.path.exists(json_path):
        with open(json_path, 'r') as f:
            data = json.load(f)

    existing_weeks = {w['week_no'] for w in data.get('pregnancy_weeks', [])}
    for generated_week in generate_pregnancy_weeks():
        if generated_week['week_no'] not in existing_weeks:
            data['pregnancy_weeks'].append(generated_week)

    # Insert Pregnancy Weeks
    for w in data.get('pregnancy_weeks', []):
        cursor.execute('''
        INSERT INTO pregnancy_weeks (week_no, baby_growth, mother_changes, diet_tip, activity_tip, warning_signs, audio_key)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (w['week_no'], w['baby_growth'], w['mother_changes'], w['diet_tip'], w['activity_tip'], w['warning_signs'], w['audio_key']))

    # Insert Maternal Vaccines
    for v in data.get('maternal_vaccines', []):
        cursor.execute('''
        INSERT INTO maternal_vaccines (code, title, recommended_time)
        VALUES (?, ?, ?)
        ''', (v['code'], v['title'], v['recommended_time']))

    # Insert Child Vaccines
    for cv in data.get('child_vaccines', []):
        cursor.execute('''
        INSERT INTO child_vaccines (code, title, age_label, min_age_days, max_age_days, optional_region_flag)
        VALUES (?, ?, ?, ?, ?, ?)
        ''', (cv['code'], cv['title'], cv['age_label'], cv['min_age_days'], cv['max_age_days'], cv['optional_region_flag']))

    # Insert Nutrition Cards
    for nc in data.get('nutrition_cards', []):
        cursor.execute('''
        INSERT INTO nutrition_cards (stage, title, tip_text, local_food_examples)
        VALUES (?, ?, ?, ?)
        ''', (nc['stage'], nc['title'], nc['tip_text'], nc['local_food_examples']))

    # Insert Danger Signs
    for ds in data.get('danger_signs', []):
        cursor.execute('''
        INSERT INTO danger_signs (stage, sign_text, referral_level)
        VALUES (?, ?, ?)
        ''', (ds['stage'], ds['sign_text'], ds['referral_level']))

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, '..', '..', '..'))
    db_path = os.path.join(project_root, 'assets', 'offline', 'health', 'mch.db')
    json_path = os.path.join(script_dir, 'mch_data.json')

    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    
    if os.path.exists(db_path):
        os.remove(db_path)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    create_schema(cursor)
    insert_data(cursor, json_path)

    conn.commit()
    conn.close()
    
    print(f"Success! MCH DB generated at: {db_path}")

if __name__ == '__main__':
    main()
