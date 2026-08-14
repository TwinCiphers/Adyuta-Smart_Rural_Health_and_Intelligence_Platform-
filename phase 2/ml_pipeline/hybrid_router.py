"""
Hybrid AI Routing Logic (Demonstration for Android Integration)

This script demonstrates how the Android application will route user queries 
between the local offline TFLite models and the cloud AI service based on network availability.
"""
import requests
import json
import random

CLOUD_API_URL = "http://localhost:8000/api/v1/predict"

def check_internet_connection():
    # In Android, this would use ConnectivityManager
    # For demonstration, we simulate random connection drops
    return random.choice([True, False])

def run_local_tflite_model(query: str, module: str):
    """Simulates running the local offline .tflite model"""
    print(f"⚡ [OFFLINE] Running {module}_classifier.tflite locally on device...")
    # Real implementation would load the .tflite interpreter here
    return {
        "source": "offline_tflite",
        "query": query,
        "prediction": "General_Assistance", # Simulated prediction
        "confidence": 0.85
    }

def run_cloud_normal_model(query: str, module: str):
    """Sends the query to the heavy Cloud AI service"""
    print(f"☁️ [ONLINE] Sending to Cloud AI Service for '{module}'...")
    try:
        response = requests.post(CLOUD_API_URL, json={"query": query, "module": module}, timeout=5)
        if response.status_code == 200:
            data = response.json()
            data["source"] = "online_cloud_model"
            return data
    except Exception as e:
        print(f"⚠️ Cloud API Failed: {e}. Falling back to offline model.")
        return run_local_tflite_model(query, module)
    
    return run_local_tflite_model(query, module)

def process_user_query(query: str, module: str):
    """Main Orchestrator Function"""
    is_online = check_internet_connection()
    
    if is_online:
        result = run_cloud_normal_model(query, module)
    else:
        result = run_local_tflite_model(query, module)
        
    # Standardize Output Format for the UI
    standardized_response = {
        "status": "success",
        "data": result
    }
    return standardized_response

if __name__ == "__main__":
    print("--- ADYUTA Hybrid AI Router ---")
    
    test_cases = [
        {"module": "health", "query": "I have a severe headache and fever"},
        {"module": "safety", "query": "Help me I am in danger"},
        {"module": "governance", "query": "How to apply for PM Kisan?"},
        {"module": "education", "query": "Explain photosynthesis"},
        {"module": "agriculture", "query": "image_data_base64_string"}
    ]
    
    for case in test_cases:
        print(f"\n[Request] Module: {case['module'].upper()} | Input: '{case['query']}'")
        final_output = process_user_query(case["query"], case["module"])
        print(json.dumps(final_output, indent=2))
        print("-" * 40)
