from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import random

app = FastAPI(
    title="Adyuta Cloud AI Service",
    description="The heavy 'Normal Model' fallback for the Adyuta platform when devices have internet.",
    version="1.0.0"
)

class QueryRequest(BaseModel):
    query: str
    module: str

class QueryResponse(BaseModel):
    query: str
    prediction: str
    confidence: float
    detailed_guidance: str

@app.post("/api/v1/predict", response_model=QueryResponse)
async def predict_intent(request: QueryRequest):
    """
    This endpoint simulates a heavy NLP model (like a large transformer or LLM)
    that provides highly detailed context which the offline TFLite model cannot.
    """
    if not request.query:
        raise HTTPException(status_code=400, detail="Query cannot be empty")

    # In production, this is where you would load a heavy TensorFlow model
    # or make an API call to a Large Language Model (e.g., Gemini/OpenAI).
    
    # Simulating a smarter, more detailed response from the cloud
    simulated_prediction = "Medical_Consultation_Required"
    simulated_guidance = f"Based on our advanced cloud analysis of '{request.query}' in the {request.module} module, we recommend visiting the nearest Primary Health Centre. Ensure you stay hydrated."

    return QueryResponse(
        query=request.query,
        prediction=simulated_prediction,
        confidence=round(random.uniform(0.90, 0.99), 2),
        detailed_guidance=simulated_guidance
    )

@app.get("/health")
async def health_check():
    return {"status": "Cloud AI Service is running"}

class FeedbackRequest(BaseModel):
    module: str
    query: str
    corrected_label: str

import csv
import os
from datetime import datetime

@app.post("/api/v1/feedback")
async def receive_feedback(request: FeedbackRequest):
    """
    Ingests continuous learning feedback from Android devices when online.
    Appends the corrected experience to the local CSV datasets for future auto-retraining.
    """
    module_folders = {
        "health": "../ml_pipeline/health_classifier/data/symptoms.csv",
        "safety": "../ml_pipeline/safety_classifier/data/safety_queries.csv",
        "governance": "../ml_pipeline/governance_classifier/data/governance_queries.csv",
        "education": "../ml_pipeline/education_classifier/data/education_queries.csv"
    }

    if request.module not in module_folders:
        raise HTTPException(status_code=400, detail="Invalid module")

    csv_path = module_folders[request.module]
    
    # Append to CSV
    try:
        with open(csv_path, 'a', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow([request.query, request.corrected_label])
        return {"status": "success", "message": f"Experience logged for {request.module} module."}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Run with: uvicorn main:app --reload
