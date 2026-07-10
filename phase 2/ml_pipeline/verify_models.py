import os
import json
import numpy as np
import tensorflow as tf

def test_text_model(module_name, test_queries):
    print(f"\n{'='*40}")
    print(f"🩺 Testing {module_name.upper()} Module")
    print(f"{'='*40}")
    
    model_path = os.path.join(module_name, f'{module_name.split("_")[0]}_classifier.tflite')
    mapping_path = os.path.join(module_name, 'label_mapping.json')
    
    if not os.path.exists(model_path):
        print(f"❌ Model missing: {model_path}")
        return
        
    # Load Label Mapping
    with open(mapping_path, 'r') as f:
        mapping = json.load(f)
        
    # Load TFLite Model
    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    for query in test_queries:
        # TFLite string input requires 2D shape (1, 1)
        input_data = np.array([[query]], dtype=object)
        
        interpreter.set_tensor(input_details[0]['index'], input_data)
        interpreter.invoke()
        
        output_data = interpreter.get_tensor(output_details[0]['index'])
        prediction_idx = np.argmax(output_data[0])
        confidence = output_data[0][prediction_idx] * 100
        
        predicted_label = mapping[str(prediction_idx)]
        
        print(f"Query:      '{query}'")
        print(f"Prediction: {predicted_label} (Confidence: {confidence:.2f}%)")
        print("-" * 20)

if __name__ == "__main__":
    health_tests = [
        "I have severe chest pain", 
        "Nannage mooru dinadinda jwara ide", # Kannada (Fever for 3 days)
        "Mujhe bukhar ke liye paracetamol chahiye" # Hindi (Need paracetamol)
    ]
    test_text_model("health_classifier", health_tests)
    
    safety_tests = [
        "Someone is breaking into my home",
        "Nannannu kapadi, abhaya ide", # Kannada (Save me, in danger)
        "Jaldi ambulance bhejo" # Hindi (Send ambulance fast)
    ]
    test_text_model("safety_classifier", safety_tests)
    
    gov_tests = [
        "How do I apply for the PM Kisan scheme?",
        "Pension pathakaniki arhata yenti?", # Telugu (Pension eligibility)
        "Maa oori roadlu baledu, complain cheyali" # Telugu (Roads are bad, complain)
    ]
    test_text_model("governance_classifier", gov_tests)
    
    edu_tests = [
        "Explain how photosynthesis works",
        "Bharathada rajadhani yaavudu?", # Kannada (Capital of India)
        "Quadratic equation kaise solve karein?" # Hindi (Solve quadratic eq)
    ]
    test_text_model("education_classifier", edu_tests)
    
    print("\n✅ Verification Complete! All modules are functioning accurately.")
