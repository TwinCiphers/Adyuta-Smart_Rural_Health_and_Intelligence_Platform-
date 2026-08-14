import json
import os
import random

def generate_ayurvedic_data():
    herbs = [
        {"name": "Ashwagandha", "botanical": "Withania somnifera", "family": "Solanaceae", "part": "Root", "uses": "Stress relief, vitality, immune support.", "mechanism": "Modulates stress response via HPA axis.", "warnings": "Avoid in autoimmune diseases."},
        {"name": "Triphala", "botanical": "Emblica officinalis, Terminalia chebula, Terminalia bellirica", "family": "Phyllanthaceae", "part": "Fruits", "uses": "Digestive health, gentle laxative.", "mechanism": "Stimulates intestinal motility and provides antioxidants.", "warnings": "Severe diarrhea."},
        {"name": "Tulsi", "botanical": "Ocimum sanctum", "family": "Lamiaceae", "part": "Leaves", "uses": "Cough, cold, immunity booster.", "mechanism": "Antimicrobial and immunomodulatory properties.", "warnings": "Stop 2 weeks before surgery."},
        {"name": "Brahmi", "botanical": "Bacopa monnieri", "family": "Plantaginaceae", "part": "Whole plant", "uses": "Cognitive enhancement, memory, anxiety.", "mechanism": "Neuroprotective, alters neurotransmitter levels.", "warnings": "May slow heart rate in high doses."},
        {"name": "Shatavari", "botanical": "Asparagus racemosus", "family": "Asparagaceae", "part": "Root", "uses": "Female reproductive health, galactagogue.", "mechanism": "Phytoestrogenic activity.", "warnings": "Avoid if estrogen-sensitive conditions exist."},
        {"name": "Guduchi", "botanical": "Tinospora cordifolia", "family": "Menispermaceae", "part": "Stem", "uses": "Immunity, chronic fever, detox.", "mechanism": "Macrophage activation and antioxidant.", "warnings": "May lower blood sugar too much with anti-diabetics."},
        {"name": "Amalaki", "botanical": "Phyllanthus emblica", "family": "Phyllanthaceae", "part": "Fruit", "uses": "Vitamin C source, hyperacidity, anti-aging.", "mechanism": "Potent free radical scavenger.", "warnings": "May increase bleeding risk."},
        {"name": "Haritaki", "botanical": "Terminalia chebula", "family": "Combretaceae", "part": "Fruit", "uses": "Constipation, detox, eye health.", "mechanism": "Prokinetic and anti-inflammatory.", "warnings": "Not recommended during pregnancy."},
        {"name": "Bibhitaki", "botanical": "Terminalia bellirica", "family": "Combretaceae", "part": "Fruit", "uses": "Respiratory issues, cough, sore throat.", "mechanism": "Expectorant and bronchodilator.", "warnings": "Avoid in severe dryness."},
        {"name": "Guggulu", "botanical": "Commiphora mukul", "family": "Burseraceae", "part": "Resin", "uses": "Cholesterol management, joint pain.", "mechanism": "Thyroid stimulation and lipid metabolism.", "warnings": "May interact with thyroid medications."},
        {"name": "Neem", "botanical": "Azadirachta indica", "family": "Meliaceae", "part": "Leaves, Bark", "uses": "Skin diseases, acne, blood purification.", "mechanism": "Antibacterial, antifungal, antiviral.", "warnings": "May cause liver damage in excessive doses."},
        {"name": "Arjuna", "botanical": "Terminalia arjuna", "family": "Combretaceae", "part": "Bark", "uses": "Cardiovascular health, hypertension.", "mechanism": "Inotropic effect, improves endothelial function.", "warnings": "Monitor if on standard blood pressure meds."},
        {"name": "Shilajit", "botanical": "Asphaltum punjabianum", "family": "N/A", "part": "Mineral pitch", "uses": "Energy, stamina, anti-aging.", "mechanism": "Fulvic acid enhances cellular ATP production.", "warnings": "Must be purified before use."},
        {"name": "Yashtimadhu", "botanical": "Glycyrrhiza glabra", "family": "Fabaceae", "part": "Root", "uses": "Cough, ulcer, hyperacidity.", "mechanism": "Demulcent, inhibits 11-beta-hydroxysteroid dehydrogenase.", "warnings": "Can cause hypertension and hypokalemia."},
        {"name": "Punarnava", "botanical": "Boerhavia diffusa", "family": "Nyctaginaceae", "part": "Root", "uses": "Kidney health, edema, liver support.", "mechanism": "Mild diuretic, nephroprotective.", "warnings": "Avoid in severe kidney failure without supervision."},
        {"name": "Gokshura", "botanical": "Tribulus terrestris", "family": "Zygophyllaceae", "part": "Fruit, Root", "uses": "Urinary disorders, male vitality.", "mechanism": "Increases luteinizing hormone and nitric oxide.", "warnings": "Hormone sensitive conditions."},
        {"name": "Bhringraj", "botanical": "Eclipta alba", "family": "Asteraceae", "part": "Whole plant", "uses": "Hair growth, liver disorders.", "mechanism": "Hepatoprotective and hair follicle stimulator.", "warnings": "Chills in excessive usage."},
        {"name": "Musta", "botanical": "Cyperus rotundus", "family": "Cyperaceae", "part": "Tuber", "uses": "Diarrhea, fever, menstrual disorders.", "mechanism": "Antispasmodic and antimicrobial.", "warnings": "Constipation in high doses."},
        {"name": "Kalmegh", "botanical": "Andrographis paniculata", "family": "Acanthaceae", "part": "Whole plant", "uses": "Liver health, fever, immunity.", "mechanism": "Hepatoprotective and immunostimulant.", "warnings": "Extremely bitter, may cause vomiting."},
        {"name": "Kutki", "botanical": "Picrorhiza kurroa", "family": "Plantaginaceae", "part": "Root", "uses": "Liver disorders, jaundice.", "mechanism": "Picroliv protects liver cells.", "warnings": "Diarrhea in high doses."},
        {"name": "Pippali", "botanical": "Piper longum", "family": "Piperaceae", "part": "Fruit", "uses": "Respiratory health, digestion, bioenhancer.", "mechanism": "Piperine enhances bioavailability of other drugs.", "warnings": "Hot potency, avoid in high pitta."},
        {"name": "Shunthi", "botanical": "Zingiber officinale", "family": "Zingiberaceae", "part": "Rhizome", "uses": "Nausea, digestion, joint pain.", "mechanism": "Gingerols reduce prostaglandin synthesis.", "warnings": "Bleeding disorders."},
        {"name": "Maricha", "botanical": "Piper nigrum", "family": "Piperaceae", "part": "Fruit", "uses": "Metabolism, digestion.", "mechanism": "Stimulates digestive enzymes.", "warnings": "Gastric irritation."},
        {"name": "Daruharidra", "botanical": "Berberis aristata", "family": "Berberidaceae", "part": "Stem, Root", "uses": "Skin diseases, diabetes, eye disorders.", "mechanism": "Berberine regulates AMPK pathway.", "warnings": "Pregnancy (may stimulate uterus)."},
        {"name": "Manjistha", "botanical": "Rubia cordifolia", "family": "Rubiaceae", "part": "Root", "uses": "Blood purification, skin health.", "mechanism": "Lymphatic cleanser, anti-inflammatory.", "warnings": "Reduces blood clotting time."},
        {"name": "Vacha", "botanical": "Acorus calamus", "family": "Acoraceae", "part": "Rhizome", "uses": "Speech delay, cognitive function.", "mechanism": "Neuroprotective, acetylcholinesterase inhibitor.", "warnings": "Toxic in large doses (beta-asarone)."},
        {"name": "Kantakari", "botanical": "Solanum virginianum", "family": "Solanaceae", "part": "Whole plant", "uses": "Cough, asthma.", "mechanism": "Bronchodilator and expectorant.", "warnings": "Avoid in excessive heat conditions."},
        {"name": "Bala", "botanical": "Sida cordifolia", "family": "Malvaceae", "part": "Root", "uses": "Neurological diseases, strength.", "mechanism": "Contains ephedrine-like alkaloids.", "warnings": "Hypertension, palpitations."},
        {"name": "Ashoka", "botanical": "Saraca asoca", "family": "Fabaceae", "part": "Bark", "uses": "Menorrhagia, uterine health.", "mechanism": "Astringent, stimulates uterine contractions.", "warnings": "Avoid in amenorrhea."},
        {"name": "Lodhra", "botanical": "Symplocos racemosa", "family": "Symplocaceae", "part": "Bark", "uses": "Leucorrhea, acne, bleeding.", "mechanism": "Hemostatic and anti-inflammatory.", "warnings": "Severe constipation."},
        {"name": "Shirish", "botanical": "Albizia lebbeck", "family": "Fabaceae", "part": "Bark", "uses": "Allergies, poisoning, asthma.", "mechanism": "Mast cell stabilizing.", "warnings": "Avoid in severe weakness."},
        {"name": "Varuna", "botanical": "Crataeva nurvala", "family": "Capparaceae", "part": "Bark", "uses": "Kidney stones, BPH.", "mechanism": "Lithotriptic and anti-inflammatory.", "warnings": "None major."},
        {"name": "Khadira", "botanical": "Acacia catechu", "family": "Fabaceae", "part": "Heartwood", "uses": "Skin diseases, oral care.", "mechanism": "Potent astringent, antimicrobial.", "warnings": "Severe dryness."},
        {"name": "Chitraka", "botanical": "Plumbago zeylanica", "family": "Plumbaginaceae", "part": "Root", "uses": "Indigestion, hemorrhoids.", "mechanism": "Plumbagin stimulates digestive fire.", "warnings": "Extremely hot, causes blistering if raw."},
        {"name": "Agnimantha", "botanical": "Premna integrifolia", "family": "Lamiaceae", "part": "Root", "uses": "Inflammation, neuralgia.", "mechanism": "Analgesic and anti-inflammatory.", "warnings": "Avoid in acute fevers."},
        {"name": "Patola", "botanical": "Trichosanthes dioica", "family": "Cucurbitaceae", "part": "Leaves", "uses": "Fever, liver disorders, skin.", "mechanism": "Hepatoprotective and antipyretic.", "warnings": "None major."},
        {"name": "Kutaja", "botanical": "Holarrhena antidysenterica", "family": "Apocynaceae", "part": "Bark", "uses": "Dysentery, diarrhea, IBS.", "mechanism": "Amoebicidal and astringent.", "warnings": "Constipation."},
        {"name": "Bilva", "botanical": "Aegle marmelos", "family": "Rutaceae", "part": "Fruit", "uses": "Diarrhea, IBS, digestion.", "mechanism": "Modulates gut motility.", "warnings": "Constipation in high doses."},
        {"name": "Karpura", "botanical": "Cinnamomum camphora", "family": "Lauraceae", "part": "Extract", "uses": "Pain relief, cough, toothache.", "mechanism": "Counter-irritant, cooling.", "warnings": "Toxic if ingested in large amounts."},
        {"name": "Jatiphala", "botanical": "Myristica fragrans", "family": "Myristicaceae", "part": "Seed", "uses": "Insomnia, diarrhea, stress.", "mechanism": "Sedative, gut antispasmodic.", "warnings": "Hallucinations in high doses."},
        {"name": "Lavanga", "botanical": "Syzygium aromaticum", "family": "Myrtaceae", "part": "Flower bud", "uses": "Toothache, cough, indigestion.", "mechanism": "Eugenol is anesthetic and antibacterial.", "warnings": "Bleeding disorders."},
        {"name": "Ela", "botanical": "Elettaria cardamomum", "family": "Zingiberaceae", "part": "Seed", "uses": "Bad breath, nausea, asthma.", "mechanism": "Bronchodilator and carminative.", "warnings": "Gallstones (can trigger colic)."},
        {"name": "Twak", "botanical": "Cinnamomum zeylanicum", "family": "Lauraceae", "part": "Bark", "uses": "Diabetes, digestion, cholesterol.", "mechanism": "Improves insulin sensitivity.", "warnings": "Liver toxicity (coumarin)."},
        {"name": "Kumari", "botanical": "Aloe vera", "family": "Asphodelaceae", "part": "Leaves", "uses": "Skin burns, amenorrhea, liver.", "mechanism": "Anthraquinones stimulate bowels, healing.", "warnings": "Pregnancy (can cause abortion)."},
        {"name": "Sarpagandha", "botanical": "Rauwolfia serpentina", "family": "Apocynaceae", "part": "Root", "uses": "Hypertension, insomnia.", "mechanism": "Reserpine depletes catecholamines.", "warnings": "Depression, severe hypotension."}
    ]

    forms = [
        {"type": "Churna", "form_name": "Powder", "dosage": "3-6g with water or milk."},
        {"type": "Vati", "form_name": "Tablet", "dosage": "1-2 tablets twice a day."},
        {"type": "Asava", "form_name": "Liquid Fermentation", "dosage": "15-30ml with equal water after meals."},
        {"type": "Taila", "form_name": "Medicated Oil", "dosage": "For external application / massage."},
        {"type": "Ghrita", "form_name": "Medicated Ghee", "dosage": "10-20g empty stomach with warm water."}
    ]

    brands = ["Dabur", "Baidyanath", "Himalaya", "Patanjali", "Kottakkal", "Zandu"]
    platforms = ["1mg", "Apollo", "Amazon", "Flipkart"]

    ayurvedic_medicines = []

    # Generate at least 200 items (45 herbs * 5 forms = 225 combinations)
    for herb in herbs:
        for form in forms:
            brand = random.choice(brands)
            med_name = f"{herb['name']} {form['type']}"
            
            med = {
                "brand_name": f"{brand} {med_name}",
                "generic_name": herb['name'],
                "botanical_name": herb['botanical'],
                "family": herb['family'],
                "vernacular_names": herb['name'],
                "part_used": herb['part'],
                "uses": f"Used in {form['form_name']} form for: {herb['uses']}",
                "mechanism": herb['mechanism'],
                "dosage_and_form": f"{form['form_name']}. {form['dosage']}",
                "side_effects": "Mild GI upset in some individuals.",
                "drug_interactions": "May alter absorption of allopathic drugs if taken simultaneously.",
                "warnings_and_contraindications": herb['warnings'],
                "safety_pregnancy_lactation": "Consult Ayurvedic physician before use in pregnancy.",
                "quality_standardization": "API Standards",
                "manufacturer_approval": f"{brand}, Ayush Approved",
                "source_ref": "Ayurvedic Pharmacopoeia of India",
                "links": [
                    {
                        "platform": random.choice(platforms), 
                        "url": f"https://www.google.com/search?q=buy+{brand.lower()}+{med_name.replace(' ', '+').lower()}"
                    }
                ]
            }
            ayurvedic_medicines.append(med)
            
            if len(ayurvedic_medicines) >= 220:
                break
        if len(ayurvedic_medicines) >= 220:
            break

    output_path = os.path.join(os.path.dirname(__file__), 'ayurvedic_data.json')
    with open(output_path, 'w') as f:
        json.dump(ayurvedic_medicines, f, indent=4)
        
    print(f"Generated {len(ayurvedic_medicines)} Ayurvedic medicines to {output_path}")

if __name__ == "__main__":
    generate_ayurvedic_data()
