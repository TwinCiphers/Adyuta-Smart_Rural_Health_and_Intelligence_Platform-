import sqlite3
import os

db_dir = 'c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase 3/health_module/assets/offline/health'

for filename in os.listdir(db_dir):
    if filename.endswith('.db'):
        db_path = os.path.join(db_dir, filename)
        print(f"\n--- {filename} ---")
        try:
            conn = sqlite3.connect(db_path)
            cursor = conn.cursor()
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
            tables = cursor.fetchall()
            for table in tables:
                table_name = table[0]
                if table_name in ('sqlite_sequence', 'android_metadata'):
                    continue
                print(f"Table: {table_name}")
                cursor.execute(f"SELECT * FROM {table_name}")
                rows = cursor.fetchall()
                for row in rows:
                    print(f"  {row}")
            conn.close()
        except Exception as e:
            print(f"Error reading {filename}: {e}")
