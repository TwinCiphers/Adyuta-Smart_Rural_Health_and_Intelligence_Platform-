import sqlite3
import os
import json

def create_schema(cursor):
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS emergency_topics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        slug TEXT UNIQUE,
        title TEXT,
        category TEXT,
        urgency_level TEXT,
        audio_key TEXT
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS emergency_steps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        step_no INTEGER,
        type TEXT,
        text_content TEXT,
        icon_asset TEXT,
        FOREIGN KEY(topic_id) REFERENCES emergency_topics(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS danger_signs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        sign_text TEXT,
        FOREIGN KEY(topic_id) REFERENCES emergency_topics(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS avoid_actions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        action_text TEXT,
        reason_text TEXT,
        FOREIGN KEY(topic_id) REFERENCES emergency_topics(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS referral_rules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        rule_text TEXT,
        referral_level TEXT,
        FOREIGN KEY(topic_id) REFERENCES emergency_topics(id)
    )
    ''')

def generate_mock_firstaid_scenarios(count=50):
    scenarios = []
    base_titles = ["Snake Bite", "Burns", "Choking", "Heat Stroke", "Electric Shock", "Bleeding", "Fracture", "Poisoning", "Fainting", "Drowning"]
    categories = ["Trauma", "Environmental", "Medical", "Toxicology"]
    
    for i in range(count):
        title = f"{base_titles[i % len(base_titles)]} Variation {i}"
        scenarios.append({
            "slug": title.lower().replace(" ", "_"),
            "title": title,
            "category": categories[i % len(categories)],
            "urgency_level": "High" if i % 2 == 0 else "Medium",
            "emergency_steps": [
                {"step_no": 1, "type": "Assess", "text_content": "Check for danger and ensure the area is safe."},
                {"step_no": 2, "type": "Action", "text_content": f"Apply first aid for {title}."},
                {"step_no": 3, "type": "Call", "text_content": "Call emergency services if necessary."}
            ],
            "danger_signs": [
                "Loss of consciousness",
                "Severe bleeding",
                "Difficulty breathing"
            ],
            "avoid_actions": [
                {"action_text": "Do not panic", "reason_text": "Panic worsens the situation."},
                {"action_text": "Do not move the victim unnecessarily", "reason_text": "Can cause further injury."}
            ],
            "referral_rules": [
                {"rule_text": "If symptoms persist or worsen, go to hospital.", "referral_level": "Hospital"}
            ]
        })
    return scenarios

def insert_data(cursor, json_path):
    topics = []
    if os.path.exists(json_path):
        with open(json_path, 'r') as f:
            topics = json.load(f)
            
    topics.extend(generate_mock_firstaid_scenarios(50))

    for t in topics:
        cursor.execute('''
        INSERT INTO emergency_topics (slug, title, category, urgency_level, audio_key)
        VALUES (?, ?, ?, ?, ?)
        ''', (t['slug'], t['title'], t['category'], t['urgency_level'], f"audio_{t['slug']}"))
        
        topic_id = cursor.lastrowid
        
        for step in t.get('emergency_steps', []):
            cursor.execute('''
            INSERT INTO emergency_steps (topic_id, step_no, type, text_content, icon_asset)
            VALUES (?, ?, ?, ?, ?)
            ''', (topic_id, step['step_no'], step['type'], step['text_content'], f"icon_{step['type'].lower()}.svg"))
            
        for sign in t.get('danger_signs', []):
            cursor.execute('''
            INSERT INTO danger_signs (topic_id, sign_text)
            VALUES (?, ?)
            ''', (topic_id, sign))
            
        for avoid in t.get('avoid_actions', []):
            cursor.execute('''
            INSERT INTO avoid_actions (topic_id, action_text, reason_text)
            VALUES (?, ?, ?)
            ''', (topic_id, avoid['action_text'], avoid['reason_text']))
            
        for rule in t.get('referral_rules', []):
            cursor.execute('''
            INSERT INTO referral_rules (topic_id, rule_text, referral_level)
            VALUES (?, ?, ?)
            ''', (topic_id, rule['rule_text'], rule['referral_level']))

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, '..', '..', '..'))
    db_path = os.path.join(project_root, 'assets', 'offline', 'health', 'firstaid.db')
    json_path = os.path.join(script_dir, 'firstaid_data.json')

    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    
    if os.path.exists(db_path):
        os.remove(db_path)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    create_schema(cursor)
    insert_data(cursor, json_path)

    conn.commit()
    conn.close()
    
    print(f"Success! DB generated at: {db_path}")

if __name__ == '__main__':
    main()
