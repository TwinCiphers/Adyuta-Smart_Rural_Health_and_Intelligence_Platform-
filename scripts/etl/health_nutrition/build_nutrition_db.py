import sqlite3
import os
import json

def create_schema(cursor):
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS foods (
        id INTEGER PRIMARY KEY,
        name TEXT,
        local_name TEXT,
        category TEXT,
        serving_size_g INTEGER,
        calories REAL,
        protein_g REAL,
        iron_mg REAL,
        calcium_mg REAL,
        fibre_g REAL,
        fat_g REAL,
        carbs_g REAL,
        sugar_g REAL,
        sodium_mg REAL,
        source_ref TEXT
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS recipes (
        id INTEGER PRIMARY KEY,
        name TEXT,
        local_name TEXT,
        serving_size_g INTEGER,
        calories REAL,
        protein_g REAL,
        iron_mg REAL,
        notes TEXT
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS diet_tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        food_id INTEGER,
        tag TEXT,
        FOREIGN KEY(food_id) REFERENCES foods(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS ayurveda_food_meta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        food_id INTEGER,
        rasa TEXT,
        guna TEXT,
        virya TEXT,
        notes TEXT,
        FOREIGN KEY(food_id) REFERENCES foods(id)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS condition_guides (
        id INTEGER PRIMARY KEY,
        slug TEXT,
        title TEXT,
        safe_foods TEXT,
        limit_foods TEXT,
        referral_warning TEXT
    )
    ''')

def generate_mock_foods(start_id=100, count=250):
    import random
    foods = []
    base_names = ["Rice", "Wheat", "Lentils", "Spinach", "Chicken", "Fish", "Egg", "Milk", "Yogurt", "Apple", "Banana", "Mango", "Potato", "Tomato", "Onion"]
    categories = ["Cereals", "Pulses", "Vegetables", "Meat", "Dairy", "Fruits", "Spices", "Oils"]
    for i in range(count):
        cat = random.choice(categories)
        name = f"Mock {random.choice(base_names)} {i}"
        foods.append({
            'id': start_id + i,
            'name': name,
            'local_name': f"Local {name}",
            'category': cat,
            'serving_size_g': 100,
            'calories': random.uniform(50, 400),
            'protein_g': random.uniform(0, 30),
            'iron_mg': random.uniform(0, 10),
            'calcium_mg': random.uniform(0, 300),
            'fibre_g': random.uniform(0, 15),
            'fat_g': random.uniform(0, 20),
            'carbs_g': random.uniform(0, 80),
            'sugar_g': random.uniform(0, 20),
            'sodium_mg': random.uniform(0, 500),
            'source_ref': 'Mock Data'
        })
    return foods

def insert_data(cursor, json_path):
    data = {'foods': [], 'recipes': [], 'diet_tags': [], 'ayurveda_food_meta': [], 'condition_guides': []}
    if os.path.exists(json_path):
        with open(json_path, 'r') as f:
            data = json.load(f)

    # Generate 250 more foods
    mock_foods = generate_mock_foods(start_id=len(data.get('foods', [])) + 1, count=250)
    data['foods'].extend(mock_foods)

    # Insert Foods
    for food in data.get('foods', []):
        cursor.execute('''
        INSERT INTO foods (
            id, name, local_name, category, serving_size_g, calories, protein_g, 
            iron_mg, calcium_mg, fibre_g, fat_g, carbs_g, sugar_g, sodium_mg, source_ref
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            food['id'], food['name'], food.get('local_name', ''), food.get('category', ''), food.get('serving_size_g', 100),
            food.get('calories', 0), food.get('protein_g', 0), food.get('iron_mg', 0), food.get('calcium_mg', 0),
            food.get('fibre_g', 0), food.get('fat_g', 0), food.get('carbs_g', 0), food.get('sugar_g', 0), food.get('sodium_mg', 0),
            food.get('source_ref', '')
        ))

    # Insert Recipes
    for r in data.get('recipes', []):
        cursor.execute('''
        INSERT INTO recipes (id, name, local_name, serving_size_g, calories, protein_g, iron_mg, notes)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', (r['id'], r['name'], r.get('local_name', ''), r.get('serving_size_g', 100), r.get('calories', 0), r.get('protein_g', 0), r.get('iron_mg', 0), r.get('notes', '')))

    # Insert Diet Tags
    for tag in data.get('diet_tags', []):
        cursor.execute('''
        INSERT INTO diet_tags (food_id, tag)
        VALUES (?, ?)
        ''', (tag['food_id'], tag['tag']))

    # Add dummy diet tags for mock foods
    import random
    for mf in mock_foods:
        cursor.execute('''
        INSERT INTO diet_tags (food_id, tag)
        VALUES (?, ?)
        ''', (mf['id'], random.choice(['Diabetes Friendly', 'Heart Healthy', 'High Protein', 'Keto', 'Vegan'])))

    # Insert Ayurveda Meta
    for meta in data.get('ayurveda_food_meta', []):
        cursor.execute('''
        INSERT INTO ayurveda_food_meta (food_id, rasa, guna, virya, notes)
        VALUES (?, ?, ?, ?, ?)
        ''', (meta['food_id'], meta.get('rasa', ''), meta.get('guna', ''), meta.get('virya', ''), meta.get('notes', '')))

    # Insert Condition Guides
    for guide in data.get('condition_guides', []):
        cursor.execute('''
        INSERT INTO condition_guides (id, slug, title, safe_foods, limit_foods, referral_warning)
        VALUES (?, ?, ?, ?, ?, ?)
        ''', (guide['id'], guide['slug'], guide['title'], guide.get('safe_foods', ''), guide.get('limit_foods', ''), guide.get('referral_warning', '')))

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, '..', '..', '..'))
    db_path = os.path.join(project_root, 'assets', 'offline', 'health', 'nutrition.db')
    json_path = os.path.join(script_dir, 'nutrition_data.json')

    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    
    if os.path.exists(db_path):
        os.remove(db_path)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    create_schema(cursor)
    insert_data(cursor, json_path)

    conn.commit()
    conn.close()
    
    print(f"Success! Nutrition DB generated at: {db_path}")

if __name__ == '__main__':
    main()
