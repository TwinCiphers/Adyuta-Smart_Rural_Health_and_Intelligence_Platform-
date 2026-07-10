import subprocess
import time
import os

def trigger_retraining():
    print("🚀 Auto-Train Orchestrator: Triggering Machine Learning Pipeline...")
    
    # The exact command used to retrain all models using the Docker container
    docker_cmd = (
        'docker run --rm -v "%cd%:/workspace" -w /workspace tensorflow/tensorflow:2.15.0 '
        'bash -c "pip install \'pandas<2\' scikit-learn pillow \'numpy<2\' && '
        'cd health_classifier && python train.py && '
        'cd ../safety_classifier && python train.py && '
        'cd ../governance_classifier && python train.py && '
        'cd ../education_classifier && python train.py && '
        'cd ../agriculture_classifier && python train.py"'
    )
    
    print("Running Docker container to build new .tflite models...")
    try:
        # Run command synchronously to ensure completion
        process = subprocess.run(docker_cmd, shell=True, check=True, text=True, capture_output=True)
        print("✅ Retraining Complete! Models successfully learned from new experiences.")
        # print(process.stdout)
    except subprocess.CalledProcessError as e:
        print("❌ Auto-Training Failed!")
        print(e.stderr)

def monitor_datasets(threshold=10):
    """
    In production, this function runs constantly in the background (or via a cron job).
    It checks if the CSV files have grown by `threshold` rows. 
    If so, it triggers retraining.
    """
    print("Continuous Learning Monitor Started. Listening for new user experiences...")
    # Demonstration trigger:
    trigger_retraining()

if __name__ == "__main__":
    print("--- ADYUTA Continuous Learning System ---")
    monitor_datasets()
