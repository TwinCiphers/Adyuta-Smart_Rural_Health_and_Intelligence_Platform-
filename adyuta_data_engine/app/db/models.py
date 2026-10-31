import enum
from datetime import datetime
from sqlalchemy import Column, String, Integer, DateTime, Boolean, Float, Enum, JSON
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class ConnectorType(enum.Enum):
    GITHUB = "github"
    REST = "rest"
    CKAN = "ckan"
    ODATA = "odata"

class TrustTier(enum.Enum):
    TIER_1_GOV = 95
    TIER_2_RESEARCH = 85
    TIER_3_NGO = 75
    TIER_4_VERIFIED_GITHUB = 65
    TIER_5_CROWDSOURCED = 50
    TIER_6_UNVERIFIED = 10

class SourceRegistry(Base):
    """
    The master catalog of all upstream data sources.
    """
    __tablename__ = "source_registry"

    id = Column(String, primary_key=True) # e.g., 'github_weather_001'
    domain = Column(String, nullable=False) # e.g., 'safety', 'agriculture'
    connector = Column(Enum(ConnectorType), nullable=False)
    
    # Configuration JSON: { "repository": "owner/repo", "path": "data/weather.json" }
    config = Column(JSON, nullable=False) 
    
    update_frequency = Column(String) # e.g., '15m', '1h', 'daily'
    trust_score = Column(Integer, default=TrustTier.TIER_6_UNVERIFIED.value)
    
    license = Column(String)
    commercial_use_allowed = Column(Boolean, default=False)
    
    enabled = Column(Boolean, default=True)
    
    # State tracking
    last_sha = Column(String, nullable=True) # for GitHub ETags/SHAs
    last_ingested_at = Column(DateTime, nullable=True)
    
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class DataRecord(Base):
    """
    Normalized data records ingested from sources.
    """
    __tablename__ = "data_records"

    id = Column(Integer, primary_key=True, autoincrement=True)
    source_id = Column(String, index=True)
    domain = Column(String, index=True)
    
    raw_data = Column(JSON) # The raw ingested payload
    normalized_data = Column(JSON) # Adyuta standardized format
    
    commit_sha = Column(String, nullable=True) # Provenance tracking
    
    observed_at = Column(DateTime, index=True)
    ingested_at = Column(DateTime, default=datetime.utcnow)
