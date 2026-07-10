# ADYUTA Local Health Classifier

This is the machine learning pipeline for building the offline AI symptom classifier (Phase 2), as specified in the ADYUTA synopsis.

It uses a simple `TextVectorization` and `Dense` neural network architecture via TensorFlow, and exports directly to `.tflite`.

## Setup Instructions

1. **Create a virtual environment:**
   ```bash
   python -m venv venv
   ```

2. **Activate the environment:**
   - On Windows: `.\venv\Scripts\activate`
   - On Mac/Linux: `source venv/bin/activate`

3. **Install requirements:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Train the model:**
   ```bash
   python train.py
   ```

## Output
After running the training script, you will get:
- `health_classifier.tflite`: The actual lightweight model file to bundle in the Android `assets` folder.
- `label_mapping.json`: The mapping of output integers to text categories (Emergency, Consultation, Home_Remedy, Pharmacy).
