import os

modules = ["health_classifier", "safety_classifier", "governance_classifier", "education_classifier"]

for mod in modules:
    file_path = f"{mod}/train.py"
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = content.replace("epochs=50", "epochs=100")
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
        
print("Bumped epochs to 100")
