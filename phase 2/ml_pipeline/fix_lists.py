import os

modules = [
    "health_classifier", 
    "safety_classifier", 
    "governance_classifier", 
    "education_classifier"
]

for mod in modules:
    file_path = f"{mod}/train.py"
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Fix the list issue
    content = content.replace("texts = df['text'].astype(str).values.tolist()", "texts = np.array(df['text'].astype(str).tolist())")
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

print("✅ Fixed numpy array conversions!")
