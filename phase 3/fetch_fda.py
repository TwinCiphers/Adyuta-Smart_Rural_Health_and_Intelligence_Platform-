import urllib.request
import json
import os

url = 'https://api.fda.gov/drug/label.json?search=openfda.product_type:"HUMAN%20OTC%20DRUG"&limit=100'

def fetch_medicines():
    print("Fetching from FDA...")
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
            results = data.get('results', [])
            
            parsed_meds = []
            for r in results:
                openfda = r.get('openfda', {})
                name = openfda.get('brand_name', ['Unknown'])[0]
                generic = openfda.get('generic_name', ['Unknown'])[0]
                
                if name == 'Unknown' or generic == 'Unknown':
                    continue
                    
                route = openfda.get('route', ['Oral'])[0]
                
                purpose = r.get('purpose', ['No purpose listed.'])[0]
                indications = r.get('indications_and_usage', ['No indications listed.'])[0]
                warnings = r.get('warnings', ['No warnings listed.'])[0]
                dosage = r.get('dosage_and_administration', ['No dosage listed.'])[0]
                
                parsed_meds.append({
                    "name": name,
                    "class": generic,
                    "dose": route,
                    "purpose": purpose[:200] + '...' if len(purpose) > 200 else purpose,
                    "used_for": indications[:200] + '...' if len(indications) > 200 else indications,
                    "side_effects": warnings[:200] + '...' if len(warnings) > 200 else warnings,
                    "how_to_use": dosage[:200] + '...' if len(dosage) > 200 else dosage,
                    "prescription": "OTC (Over-the-Counter)"
                })
                
            os.makedirs('assets', exist_ok=True)
            with open('assets/real_medicines.json', 'w', encoding='utf-8') as f:
                json.dump(parsed_meds, f, indent=2)
                
            print(f"Successfully saved {len(parsed_meds)} real medicines to assets/real_medicines.json")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    fetch_medicines()
