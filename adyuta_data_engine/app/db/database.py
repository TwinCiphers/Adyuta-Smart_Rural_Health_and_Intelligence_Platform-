import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Default to SQLite if Postgres is not yet available, ensuring it always runs out of the box
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./adyuta_engine.db")

# For SQLite, we need connect_args={"check_same_thread": False}. For Postgres, we don't.
connect_args = {}
if DATABASE_URL.startswith("sqlite"):
    connect_args = {"check_same_thread": False}

engine = create_engine(DATABASE_URL, connect_args=connect_args)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
