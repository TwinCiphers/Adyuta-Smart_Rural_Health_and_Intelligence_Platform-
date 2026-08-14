import json
import os

def generate_firstaid_data():
    topics = [
        {
            "slug": "snakebite",
            "title": "Snakebite",
            "category": "Trauma & Bites",
            "urgency_level": "Critical",
            "danger_signs": [
                "Difficulty breathing",
                "Swelling rapidly spreading",
                "Bleeding from gums or wounds",
                "Drooping eyelids or paralysis"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "ASSESS", "text_content": "Move away from the snake to a safe distance immediately."},
                {"step_no": 2, "type": "DO", "text_content": "Keep the person completely calm and still. Movement spreads venom faster."},
                {"step_no": 3, "type": "DO", "text_content": "Immobilize the bitten limb using a splint or sling, keeping it below heart level."},
                {"step_no": 4, "type": "DO", "text_content": "Remove any tight clothing, rings, or watches near the bite before swelling starts."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT tie a tight tourniquet.", "reason_text": "It cuts off blood flow completely and can cause loss of the limb."},
                {"action_text": "Do NOT cut the wound or try to suck the venom.", "reason_text": "It does not work and increases severe infection risk."},
                {"action_text": "Do NOT give herbal remedies or 'black stones'.", "reason_text": "Wastes critical time. Only antivenom works."},
                {"action_text": "Do NOT give alcohol or caffeine.", "reason_text": "Speeds up venom absorption."}
            ],
            "referral_rules": [
                {"rule_text": "Transport immediately to a District Hospital or PHC that stocks Anti-Snake Venom (ASV).", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "severe-bleeding",
            "title": "Severe Bleeding",
            "category": "Trauma & Bites",
            "urgency_level": "Critical",
            "danger_signs": [
                "Blood is spurting (arterial bleed)",
                "Bleeding does not stop after 10 mins of pressure",
                "Person is pale, cold, and confused (Shock)"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Apply direct, firm pressure to the wound with a clean cloth or sterile pad."},
                {"step_no": 2, "type": "DO", "text_content": "Maintain continuous pressure. Do not lift the cloth to check."},
                {"step_no": 3, "type": "DO", "text_content": "If the cloth soaks through, add another on top; don't remove the first one."},
                {"step_no": 4, "type": "DO", "text_content": "Lie the person down and elevate their legs to prevent shock."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT remove embedded objects (like a knife or glass).", "reason_text": "The object may be plugging a cut artery. Removing it can cause fatal bleeding."},
                {"action_text": "Do NOT use turmeric or mud to stop bleeding.", "reason_text": "Can cause severe tetanus or sepsis infection."}
            ],
            "referral_rules": [
                {"rule_text": "Rush to the nearest PHC or Hospital immediately while holding pressure.", "referral_level": "Immediate PHC"}
            ]
        },
        {
            "slug": "burns",
            "title": "Burns & Scalds",
            "category": "Environmental",
            "urgency_level": "High",
            "danger_signs": [
                "Burn covers a large area of the body",
                "Face, airway, or genitals are burned",
                "Skin is white, charred, or painless (3rd Degree)"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Cool the burn immediately under cool (not ice cold) running water for at least 20 minutes."},
                {"step_no": 2, "type": "DO", "text_content": "Remove jewelry or tight clothing near the burn before it swells."},
                {"step_no": 3, "type": "DO", "text_content": "Cover the cooled burn loosely with cling film or a clean, dry plastic bag to prevent infection."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT apply ice or ice water.", "reason_text": "It can cause further tissue damage and hypothermia."},
                {"action_text": "Do NOT apply toothpaste, butter, mud, or ointments.", "reason_text": "These trap the heat in the skin and introduce severe infections."},
                {"action_text": "Do NOT pop blisters.", "reason_text": "Blisters protect the raw skin from bacteria."}
            ],
            "referral_rules": [
                {"rule_text": "Go to hospital for burns larger than the person's hand, or on the face/joints.", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "pesticide-poison",
            "title": "Pesticide Exposure",
            "category": "Medical",
            "urgency_level": "Critical",
            "danger_signs": [
                "Excessive sweating, drooling, or tearing",
                "Pinpoint pupils and blurred vision",
                "Muscle twitching or seizures",
                "Difficulty breathing"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "ASSESS", "text_content": "Ensure your own safety. Do not touch the poison or breathe the fumes."},
                {"step_no": 2, "type": "DO", "text_content": "If inhaled: Move the person to fresh air immediately."},
                {"step_no": 3, "type": "DO", "text_content": "If on skin: Remove contaminated clothing and wash skin with large amounts of soap and water."},
                {"step_no": 4, "type": "DO", "text_content": "Bring the pesticide container or label to the hospital."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT induce vomiting unless specifically told by a doctor.", "reason_text": "Vomiting chemicals can severely burn the esophagus or enter the lungs."},
                {"action_text": "Do NOT give the person anything to eat or drink.", "reason_text": "It may speed up poison absorption or cause choking."}
            ],
            "referral_rules": [
                {"rule_text": "Rush to a District Hospital immediately. Atropine or specific antidotes are required.", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "dehydration-ors",
            "title": "Dehydration & Diarrhea",
            "category": "Medical",
            "urgency_level": "Moderate",
            "danger_signs": [
                "Sunken eyes and extreme thirst",
                "No urine output for over 8 hours",
                "Lethargy or inability to drink",
                "Blood in stool"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Prepare ORS: Mix 1 packet of ORS in exactly 1 Liter of clean drinking water."},
                {"step_no": 2, "type": "DO", "text_content": "Give the ORS slowly in small sips (a spoonful every few minutes)."},
                {"step_no": 3, "type": "DO", "text_content": "If ORS is unavailable, mix 6 level teaspoons of sugar and 1/2 teaspoon of salt in 1 Liter of clean water."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT stop feeding a child or infant.", "reason_text": "Breastfeeding or light food should continue to provide energy."},
                {"action_text": "Do NOT give sugary sodas or fruit juices.", "reason_text": "High sugar without balanced salts pulls more water into the gut, worsening diarrhea."}
            ],
            "referral_rules": [
                {"rule_text": "Take to PHC if vomiting is continuous, danger signs appear, or diarrhea lasts > 2 days.", "referral_level": "Immediate PHC"}
            ]
        },
        {
            "slug": "heatstroke",
            "title": "Heatstroke",
            "category": "Environmental",
            "urgency_level": "High",
            "danger_signs": [
                "Skin is hot, red, and dry (not sweating)",
                "Confusion, slurred speech, or delirium",
                "Loss of consciousness or seizures"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Move the person to a cool, shaded area immediately."},
                {"step_no": 2, "type": "DO", "text_content": "Remove excess clothing."},
                {"step_no": 3, "type": "DO", "text_content": "Cool them rapidly by sponging with cool water and fanning them."},
                {"step_no": 4, "type": "DO", "text_content": "Place ice packs or wet cloths on neck, armpits, and groin."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT give fluids to drink if they are confused or unconscious.", "reason_text": "High risk of choking and fluid entering the lungs."},
                {"action_text": "Do NOT give fever-reducing medicines (like Paracetamol).", "reason_text": "They do not work for environmental heatstroke and can damage the liver."}
            ],
            "referral_rules": [
                {"rule_text": "Heatstroke is a life-threatening emergency. Rush to hospital while actively cooling them.", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "fainting",
            "title": "Fainting / Unconsciousness",
            "category": "Medical",
            "urgency_level": "High",
            "danger_signs": [
                "Does not wake up after 1 minute",
                "Has trouble breathing",
                "Has a weak or irregular pulse",
                "Is pregnant or elderly"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Lay the person flat on their back."},
                {"step_no": 2, "type": "DO", "text_content": "Elevate their legs 12 inches above heart level to restore blood flow to the brain."},
                {"step_no": 3, "type": "DO", "text_content": "Loosen tight belts, collars, or clothing."},
                {"step_no": 4, "type": "DO", "text_content": "If they don't wake up quickly, check breathing and place in the Recovery Position (on their side)."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT splash water violently on their face or slap them.", "reason_text": "It can cause aspiration or injury."},
                {"action_text": "Do NOT try to make them sit up or stand.", "reason_text": "Gravity will pull blood away from the brain again."},
                {"action_text": "Do NOT pour water or put food in their mouth.", "reason_text": "Will cause choking."}
            ],
            "referral_rules": [
                {"rule_text": "If unconscious for > 1 minute or breathing is abnormal, rush to PHC.", "referral_level": "Immediate PHC"}
            ]
        },
        {
            "slug": "fracture",
            "title": "Fracture or Sprain",
            "category": "Trauma & Bites",
            "urgency_level": "Moderate",
            "danger_signs": [
                "Bone is protruding through the skin (Open fracture)",
                "Limb is cold, blue, or numb below the injury",
                "Severe deformity"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Keep the injured area completely still. Support it with your hands or cushions."},
                {"step_no": 2, "type": "DO", "text_content": "Immobilize the limb using a splint (stiff cardboard, wood) tied gently above and below the joint."},
                {"step_no": 3, "type": "DO", "text_content": "Apply a cold pack (wrapped in cloth) for 10-15 minutes to reduce swelling."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT try to push a bone back in or straighten a deformed limb.", "reason_text": "You can severe nerves and blood vessels."},
                {"action_text": "Do NOT apply heat or massage to a fresh fracture/sprain.", "reason_text": "Increases swelling and bleeding inside."}
            ],
            "referral_rules": [
                {"rule_text": "Take to a PHC/Hospital for X-Ray and casting.", "referral_level": "Immediate PHC"}
            ]
        },
        {
            "slug": "animal-bite",
            "title": "Dog / Animal Bite",
            "category": "Trauma & Bites",
            "urgency_level": "High",
            "danger_signs": [
                "Bite is on the face, neck, or hands",
                "Bleeding is severe",
                "Animal was unprovoked, wild, or acting strangely (Rabies risk)"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Wash the wound immediately and vigorously with soap and clean running water for 15 full minutes."},
                {"step_no": 2, "type": "DO", "text_content": "Apply an antiseptic like Povidone-Iodine if available."},
                {"step_no": 3, "type": "DO", "text_content": "Cover with a clean, dry dressing to stop bleeding."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT scrub the wound roughly with a hard brush.", "reason_text": "Causes more tissue damage."},
                {"action_text": "Do NOT apply chili powder, herbs, or mud to the bite.", "reason_text": "Increases severe infection risk and does not stop Rabies."}
            ],
            "referral_rules": [
                {"rule_text": "Must visit a PHC/Hospital within 24 hours for Anti-Rabies Vaccine (ARV) and Tetanus shot.", "referral_level": "Immediate PHC"}
            ]
        },
        {
            "slug": "seizure",
            "title": "Seizure / Epilepsy",
            "category": "Medical",
            "urgency_level": "High",
            "danger_signs": [
                "Seizure lasts longer than 5 minutes",
                "A second seizure starts immediately after the first",
                "Person is pregnant or has no history of epilepsy"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Clear the area of hard or sharp objects to prevent injury."},
                {"step_no": 2, "type": "DO", "text_content": "Cushion their head with a folded towel or jacket."},
                {"step_no": 3, "type": "DO", "text_content": "Once the shaking stops, gently roll them onto their side (Recovery Position) to keep the airway open."},
                {"step_no": 4, "type": "DO", "text_content": "Time the seizure. Stay with them until they are fully conscious."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT put anything in their mouth (spoon, cloth, fingers).", "reason_text": "They cannot swallow their tongue, but objects can break teeth or block the airway."},
                {"action_text": "Do NOT try to hold them down or stop their movements.", "reason_text": "Can cause muscle tears or bone fractures."},
                {"action_text": "Do NOT force them to smell onions or leather shoes.", "reason_text": "Myth. It does absolutely nothing and delays proper care."}
            ],
            "referral_rules": [
                {"rule_text": "Go to hospital if it's their first seizure, lasts >5 mins, or they don't wake up.", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "choking",
            "title": "Choking",
            "category": "Medical",
            "urgency_level": "Critical",
            "danger_signs": [
                "Cannot speak, cough, or breathe",
                "Face turning blue",
                "Clutching the throat"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Encourage them to cough forcefully if they are able to cough."},
                {"step_no": 2, "type": "DO", "text_content": "Give 5 strong back blows between the shoulder blades using the heel of your hand."},
                {"step_no": 3, "type": "DO", "text_content": "Give 5 abdominal thrusts (Heimlich maneuver): stand behind, pull inward and upward just above their navel."},
                {"step_no": 4, "type": "DO", "text_content": "Alternate 5 back blows and 5 thrusts until the object is dislodged."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT do a blind finger sweep.", "reason_text": "You might push the object deeper into the throat."},
                {"action_text": "Do NOT give water.", "reason_text": "They cannot breathe, water will enter the lungs."}
            ],
            "referral_rules": [
                {"rule_text": "If they go unconscious, begin CPR and call for emergency transport immediately.", "referral_level": "Immediate PHC"}
            ]
        },
        {
            "slug": "heart-attack",
            "title": "Heart Attack / Chest Pain",
            "category": "Medical",
            "urgency_level": "Critical",
            "danger_signs": [
                "Heavy, crushing pain in center of chest",
                "Pain radiating to left arm, jaw, or back",
                "Shortness of breath, sweating, and nausea"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Have the person sit down, rest, and try to stay calm."},
                {"step_no": 2, "type": "DO", "text_content": "Loosen tight clothing around the chest and neck."},
                {"step_no": 3, "type": "DO", "text_content": "If they are prescribed Aspirin (and not allergic), have them chew a 300mg aspirin slowly."},
                {"step_no": 4, "type": "DO", "text_content": "Prepare to perform CPR if they become unresponsive and stop breathing."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT let them walk or exert themselves.", "reason_text": "The heart is struggling and needs minimal strain."},
                {"action_text": "Do NOT ignore it as 'just gas' if the pain is severe and radiating.", "reason_text": "Delays life-saving treatment."}
            ],
            "referral_rules": [
                {"rule_text": "Do not drive them yourself if possible; call an ambulance. Rush to District Hospital.", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "electric-shock",
            "title": "Electric Shock",
            "category": "Environmental",
            "urgency_level": "Critical",
            "danger_signs": [
                "Unconscious or not breathing",
                "Severe burns at entry and exit points",
                "Irregular heartbeat or cardiac arrest"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "ASSESS", "text_content": "Turn off the source of electricity (main switch) BEFORE approaching the person."},
                {"step_no": 2, "type": "DO", "text_content": "If you cannot turn it off, use a dry, non-conducting object (dry wooden stick, plastic pipe) to push the person away from the source."},
                {"step_no": 3, "type": "DO", "text_content": "Check for breathing and pulse. Begin CPR if absent."},
                {"step_no": 4, "type": "DO", "text_content": "Treat any burns by cooling with water and covering lightly."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT touch the person with your bare hands if they are still touching the electrical source.", "reason_text": "You will be shocked and electrocuted too."},
                {"action_text": "Do NOT use anything wet or metallic to separate them.", "reason_text": "Water and metal conduct electricity."}
            ],
            "referral_rules": [
                {"rule_text": "All electrical shocks require medical evaluation, even if the person feels fine, due to internal damage.", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "drowning",
            "title": "Drowning",
            "category": "Environmental",
            "urgency_level": "Critical",
            "danger_signs": [
                "Not breathing",
                "Blue lips or face",
                "Unconscious"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "ASSESS", "text_content": "Get the person out of the water safely. Do not put yourself in danger."},
                {"step_no": 2, "type": "DO", "text_content": "Check for breathing. If not breathing, start CPR immediately (chest compressions and rescue breaths)."},
                {"step_no": 3, "type": "DO", "text_content": "Remove wet clothing and cover them with dry blankets to prevent hypothermia."},
                {"step_no": 4, "type": "DO", "text_content": "Place in Recovery Position if they are breathing but unconscious, to allow water to drain."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT try to press on their stomach to force water out.", "reason_text": "They will likely vomit and aspirate (choke) on the vomit."},
                {"action_text": "Do NOT stop CPR early.", "reason_text": "Drowning victims may require prolonged CPR before reviving."}
            ],
            "referral_rules": [
                {"rule_text": "Always go to the hospital. 'Dry drowning' or lung complications can occur hours later.", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "scorpion-sting",
            "title": "Scorpion Sting",
            "category": "Trauma & Bites",
            "urgency_level": "Moderate",
            "danger_signs": [
                "Extreme, radiating pain",
                "Muscle twitching or roving eye movements",
                "Frothing at the mouth or severe sweating (especially in children)"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Wash the sting site with soap and water."},
                {"step_no": 2, "type": "DO", "text_content": "Apply a cool compress for 10 minutes to reduce pain."},
                {"step_no": 3, "type": "DO", "text_content": "Keep the stung area still and below heart level."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT cut the wound or try to suck out venom.", "reason_text": "Increases infection risk and is ineffective."},
                {"action_text": "Do NOT give sedatives or alcohol.", "reason_text": "Can mask severe neurological symptoms."}
            ],
            "referral_rules": [
                {"rule_text": "Scorpion stings in children or elderly require immediate PHC visit for anti-scorpion venom (if applicable) or pain management.", "referral_level": "Immediate PHC"}
            ]
        },
        {
            "slug": "asthma",
            "title": "Asthma Attack",
            "category": "Medical",
            "urgency_level": "High",
            "danger_signs": [
                "Gasping for air or unable to speak in full sentences",
                "Lips or fingertips turning blue",
                "Inhaler is not helping after 10 minutes"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Help them sit upright. Do not let them lie flat."},
                {"step_no": 2, "type": "DO", "text_content": "Help them use their reliever inhaler (usually blue, like Salbutamol/Asthalin)."},
                {"step_no": 3, "type": "DO", "text_content": "Use a spacer if available. Give 1 puff every 30-60 seconds, up to 10 puffs."},
                {"step_no": 4, "type": "DO", "text_content": "Keep them calm and encourage slow, deep breaths."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT crowd around them.", "reason_text": "They need fresh air and space to avoid panic."},
                {"action_text": "Do NOT make them lie down.", "reason_text": "Lying down makes it harder to expand the lungs."}
            ],
            "referral_rules": [
                {"rule_text": "If symptoms do not improve after 10 puffs, rush to PHC.", "referral_level": "Immediate PHC"}
            ]
        },
        {
            "slug": "nosebleed",
            "title": "Nosebleed",
            "category": "Medical",
            "urgency_level": "Low",
            "danger_signs": [
                "Bleeding lasts longer than 20 minutes",
                "Bleeding is very heavy or caused by a severe head injury",
                "Person is swallowing large amounts of blood"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Sit upright and lean slightly FORWARD."},
                {"step_no": 2, "type": "DO", "text_content": "Pinch the soft part of the nose firmly against the facial bones."},
                {"step_no": 3, "type": "DO", "text_content": "Hold continuous pressure for 10-15 full minutes without letting go."},
                {"step_no": 4, "type": "DO", "text_content": "Breathe through the mouth and spit out any blood."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT lean the head backward.", "reason_text": "Blood will drain down the throat, causing choking, nausea, and vomiting."},
                {"action_text": "Do NOT blow the nose for several hours after it stops.", "reason_text": "Will dislodge the clot and restart bleeding."}
            ],
            "referral_rules": [
                {"rule_text": "If bleeding does not stop after 20 minutes of firm pressure, go to PHC.", "referral_level": "Immediate PHC"}
            ]
        },
        {
            "slug": "cpr",
            "title": "CPR (No Pulse / Breathing)",
            "category": "Medical",
            "urgency_level": "Critical",
            "danger_signs": [
                "Unconscious",
                "No normal breathing (gasping is not normal)",
                "No response to shaking or shouting"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "ASSESS", "text_content": "Check for danger, then check response. Shout for help."},
                {"step_no": 2, "type": "DO", "text_content": "Place the heel of one hand in the center of their chest, interlock your other hand on top."},
                {"step_no": 3, "type": "DO", "text_content": "Push HARD and FAST (5cm deep, 100-120 compressions per minute)."},
                {"step_no": 4, "type": "DO", "text_content": "Do not stop compressions until emergency help arrives or they wake up."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT delay compressions to check for a pulse if they are completely unresponsive.", "reason_text": "Time is brain tissue. Start pushing."},
                {"action_text": "Do NOT worry about rescue breaths if you are untrained.", "reason_text": "Hands-only CPR is highly effective for adults."}
            ],
            "referral_rules": [
                {"rule_text": "Call an ambulance immediately before or while starting CPR.", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "head-injury",
            "title": "Head Injury",
            "category": "Trauma & Bites",
            "urgency_level": "High",
            "danger_signs": [
                "Loss of consciousness, even briefly",
                "Vomiting more than once",
                "Clear fluid leaking from nose or ears",
                "Unequal pupil sizes"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Keep the person still. Support their head and neck to prevent movement."},
                {"step_no": 2, "type": "DO", "text_content": "Apply cold compress to the bumped area to reduce swelling."},
                {"step_no": 3, "type": "DO", "text_content": "If bleeding, apply firm pressure (unless you suspect a skull fracture, then press lightly around edges)."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT move their neck if they fell from a height or were in a crash.", "reason_text": "Could cause permanent spinal cord paralysis."},
                {"action_text": "Do NOT let them sleep immediately if they are severely confused.", "reason_text": "You need to monitor their consciousness."}
            ],
            "referral_rules": [
                {"rule_text": "Any head injury with loss of consciousness or vomiting needs immediate CT scan.", "referral_level": "District Hospital"}
            ]
        },
        {
            "slug": "anaphylaxis",
            "title": "Severe Allergy (Anaphylaxis)",
            "category": "Medical",
            "urgency_level": "Critical",
            "danger_signs": [
                "Swelling of lips, tongue, or throat",
                "Wheezing and severe difficulty breathing",
                "Widespread hives/rash and dizziness"
            ],
            "emergency_steps": [
                {"step_no": 1, "type": "DO", "text_content": "Use an Epinephrine Auto-Injector (EpiPen) immediately if they have one. Inject into outer thigh."},
                {"step_no": 2, "type": "DO", "text_content": "Lay them flat. Elevate legs. (If breathing is hard, let them sit upright)."},
                {"step_no": 3, "type": "DO", "text_content": "If no EpiPen, give antihistamines (like Cetirizine) if they can swallow, but rush to hospital."}
            ],
            "avoid_actions": [
                {"action_text": "Do NOT wait to see if symptoms improve.", "reason_text": "Anaphylaxis can close the airway completely within minutes."},
                {"action_text": "Do NOT make them stand up suddenly.", "reason_text": "Can cause a fatal drop in blood pressure."}
            ],
            "referral_rules": [
                {"rule_text": "Requires immediate Adrenaline injection by a doctor. Rush to PHC/Hospital.", "referral_level": "Immediate PHC"}
            ]
        }
    ]

    output_path = os.path.join(os.path.dirname(__file__), 'firstaid_data.json')
    with open(output_path, 'w') as f:
        json.dump(topics, f, indent=4)
        
    print(f"Generated {len(topics)} emergency topics to {output_path}")

if __name__ == "__main__":
    generate_firstaid_data()
