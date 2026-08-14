import json
import os

def generate_mch_data():
    # 1. Pregnancy Weeks (Simplified sample across 40 weeks to avoid massive bloat, 
    # but structured for a real offline app database)
    pregnancy_weeks = []
    for week in range(1, 41):
        trimester = 1 if week <= 12 else (2 if week <= 26 else 3)
        
        growth_text = ""
        mother_text = ""
        diet_tip = ""
        warning_signs = "Vaginal bleeding, severe abdominal pain, severe headache, blurred vision."
        
        if trimester == 1:
            growth_text = "The embryo is forming vital organs like the heart and brain."
            mother_text = "You may experience morning sickness, fatigue, and mood swings."
            diet_tip = "Eat small, frequent meals. Folic acid is critical right now. Eat green leafy vegetables."
        elif trimester == 2:
            growth_text = "The baby is growing quickly and you might start feeling movements."
            mother_text = "Morning sickness usually fades. Your bump will start showing."
            diet_tip = "Increase iron and calcium intake. Include milk, eggs, pulses, and ragi."
        else:
            growth_text = "The baby is gaining weight rapidly and preparing for birth."
            mother_text = "You might feel breathless and experience swelling in your feet."
            diet_tip = "Continue protein-rich foods. Stay hydrated. Eat easily digestible meals."
            warning_signs += " Decreased baby movements, water breaking early."

        pregnancy_weeks.append({
            "week_no": week,
            "baby_growth": f"Week {week}: {growth_text}",
            "mother_changes": mother_text,
            "diet_tip": diet_tip,
            "activity_tip": "Do light walking for 30 minutes. Avoid heavy lifting.",
            "warning_signs": warning_signs,
            "audio_key": f"audio_week_{week}.mp3"
        })

    # 2. Maternal Vaccines (NIS India)
    maternal_vaccines = [
        {"code": "Td-1", "title": "Tetanus and adult Diphtheria (Td) - 1", "recommended_time": "Early in pregnancy"},
        {"code": "Td-2", "title": "Tetanus and adult Diphtheria (Td) - 2", "recommended_time": "4 weeks after Td-1"},
        {"code": "Td-Booster", "title": "Td Booster", "recommended_time": "If received 2 Td doses in a pregnancy within the last 3 years"}
    ]

    # 3. Child Vaccines (NIS India up to 5 years)
    # min_age_days is used by the rule engine to calculate when the notification should trigger
    child_vaccines = [
        {"code": "BCG", "title": "Bacillus Calmette-Guerin", "age_label": "At Birth", "min_age_days": 0, "max_age_days": 365, "optional_region_flag": 0},
        {"code": "OPV-0", "title": "Oral Polio Vaccine - 0", "age_label": "At Birth", "min_age_days": 0, "max_age_days": 15, "optional_region_flag": 0},
        {"code": "Hep-B", "title": "Hepatitis B (Birth Dose)", "age_label": "At Birth", "min_age_days": 0, "max_age_days": 1, "optional_region_flag": 0},
        
        {"code": "OPV-1", "title": "Oral Polio Vaccine - 1", "age_label": "6 Weeks", "min_age_days": 42, "max_age_days": 1825, "optional_region_flag": 0},
        {"code": "Penta-1", "title": "Pentavalent - 1", "age_label": "6 Weeks", "min_age_days": 42, "max_age_days": 365, "optional_region_flag": 0},
        {"code": "Rota-1", "title": "Rotavirus Vaccine - 1", "age_label": "6 Weeks", "min_age_days": 42, "max_age_days": 365, "optional_region_flag": 0},
        {"code": "fIPV-1", "title": "Fractional IPV - 1", "age_label": "6 Weeks", "min_age_days": 42, "max_age_days": 365, "optional_region_flag": 0},
        
        {"code": "OPV-2", "title": "Oral Polio Vaccine - 2", "age_label": "10 Weeks", "min_age_days": 70, "max_age_days": 1825, "optional_region_flag": 0},
        {"code": "Penta-2", "title": "Pentavalent - 2", "age_label": "10 Weeks", "min_age_days": 70, "max_age_days": 365, "optional_region_flag": 0},
        {"code": "Rota-2", "title": "Rotavirus Vaccine - 2", "age_label": "10 Weeks", "min_age_days": 70, "max_age_days": 365, "optional_region_flag": 0},
        
        {"code": "OPV-3", "title": "Oral Polio Vaccine - 3", "age_label": "14 Weeks", "min_age_days": 98, "max_age_days": 1825, "optional_region_flag": 0},
        {"code": "Penta-3", "title": "Pentavalent - 3", "age_label": "14 Weeks", "min_age_days": 98, "max_age_days": 365, "optional_region_flag": 0},
        {"code": "Rota-3", "title": "Rotavirus Vaccine - 3", "age_label": "14 Weeks", "min_age_days": 98, "max_age_days": 365, "optional_region_flag": 0},
        {"code": "fIPV-2", "title": "Fractional IPV - 2", "age_label": "14 Weeks", "min_age_days": 98, "max_age_days": 365, "optional_region_flag": 0},
        
        {"code": "MR-1", "title": "Measles Rubella - 1", "age_label": "9-12 Months", "min_age_days": 270, "max_age_days": 1825, "optional_region_flag": 0},
        {"code": "JE-1", "title": "Japanese Encephalitis - 1", "age_label": "9-12 Months", "min_age_days": 270, "max_age_days": 5475, "optional_region_flag": 1}, # Endemic districts only
        
        {"code": "MR-2", "title": "Measles Rubella - 2", "age_label": "16-24 Months", "min_age_days": 480, "max_age_days": 1825, "optional_region_flag": 0},
        {"code": "JE-2", "title": "Japanese Encephalitis - 2", "age_label": "16-24 Months", "min_age_days": 480, "max_age_days": 5475, "optional_region_flag": 1},
        {"code": "DPT-B1", "title": "DPT Booster - 1", "age_label": "16-24 Months", "min_age_days": 480, "max_age_days": 2555, "optional_region_flag": 0},
        {"code": "OPV-B", "title": "OPV Booster", "age_label": "16-24 Months", "min_age_days": 480, "max_age_days": 1825, "optional_region_flag": 0},
        
        {"code": "DPT-B2", "title": "DPT Booster - 2", "age_label": "5-6 Years", "min_age_days": 1825, "max_age_days": 2555, "optional_region_flag": 0}
    ]

    # 4. Nutrition Cards (WHO & Indian Context)
    nutrition_cards = [
        {"stage": "Trimester 1", "title": "Folic Acid & Energy", "tip_text": "Your baby's brain is developing. You need Folic Acid.", "local_food_examples": "Spinach, methi, lentils, beans, fortified cereals."},
        {"stage": "Trimester 2", "title": "Iron & Calcium", "tip_text": "Baby's bones are hardening and blood volume is increasing.", "local_food_examples": "Ragi, milk, yogurt, paneer, eggs, jaggery, amla."},
        {"stage": "Trimester 3", "title": "Proteins & Hydration", "tip_text": "Rapid growth requires protein. Stay hydrated to maintain amniotic fluid.", "local_food_examples": "Dal, soyabean, eggs, lean meat, coconut water."},
        {"stage": "Lactation", "title": "Extra Calories for Milk", "tip_text": "You need extra energy and fluids to produce breastmilk safely.", "local_food_examples": "Milk, oats, fennel seeds, garlic, almonds, moong dal."},
        {"stage": "Child 6-12 Months", "title": "Complementary Feeding", "tip_text": "Breastmilk alone is not enough anymore. Start mashed, soft foods.", "local_food_examples": "Mashed banana, soft khichdi (rice+dal), boiled potato, mashed papaya."}
    ]

    # 5. Danger Signs
    danger_signs = [
        {"stage": "Pregnancy", "sign_text": "Vaginal bleeding or fluid leakage", "referral_level": "Immediate PHC/Hospital"},
        {"stage": "Pregnancy", "sign_text": "Severe headache with blurred vision", "referral_level": "Immediate PHC/Hospital"},
        {"stage": "Pregnancy", "sign_text": "High fever or convulsions", "referral_level": "Immediate PHC/Hospital"},
        {"stage": "Pregnancy", "sign_text": "Baby stops moving or moves very little", "referral_level": "Immediate PHC/Hospital"},
        {"stage": "Newborn", "sign_text": "Fast breathing or chest indrawing", "referral_level": "Immediate PHC/Hospital"},
        {"stage": "Newborn", "sign_text": "Unable to feed or lethargic", "referral_level": "Immediate PHC/Hospital"},
        {"stage": "Newborn", "sign_text": "Yellow skin (severe Jaundice)", "referral_level": "Immediate PHC/Hospital"}
    ]

    mch_data = {
        "pregnancy_weeks": pregnancy_weeks,
        "maternal_vaccines": maternal_vaccines,
        "child_vaccines": child_vaccines,
        "nutrition_cards": nutrition_cards,
        "danger_signs": danger_signs
    }

    output_path = os.path.join(os.path.dirname(__file__), 'mch_data.json')
    with open(output_path, 'w') as f:
        json.dump(mch_data, f, indent=4)
        
    print(f"Generated MCH JSON data to {output_path}")

if __name__ == "__main__":
    generate_mch_data()
