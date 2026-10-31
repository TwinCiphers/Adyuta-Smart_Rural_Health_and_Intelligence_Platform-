from fastapi import FastAPI
import uvicorn
from app.db.database import engine
from app.db import models

# Create all tables on startup
models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Adyuta Data Engine",
    description="Centralized ingestion, validation, and packaging engine for Adyuta.",
    version="1.0.0"
)

@app.get("/")
def health_check():
    return {"status": "Adyuta Data Engine is operational"}

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
