from .celery_app import celery_app
from app.db.database import SessionLocal
from app.db.models import SourceRegistry, DataRecord, ConnectorType
from app.connectors.github import GitHubConnector
import logging
from datetime import datetime

logger = logging.getLogger(__name__)

@celery_app.task
def ingest_github_sources():
    """
    Crawls the SourceRegistry for all enabled GitHub sources and ingests them
    if their SHA has changed since the last run.
    """
    db = SessionLocal()
    try:
        sources = db.query(SourceRegistry).filter(
            SourceRegistry.enabled == True,
            SourceRegistry.connector == ConnectorType.GITHUB
        ).all()
        
        for source in sources:
            logger.info(f"Processing source: {source.id}")
            connector = GitHubConnector(source_id=source.id, config=source.config)
            
            try:
                result = connector.fetch_data(last_sha=source.last_sha)
                
                if result.get("changed"):
                    logger.info(f"Data changed for {source.id}. New SHA: {result['new_sha']}")
                    
                    # Store new record
                    record = DataRecord(
                        source_id=source.id,
                        domain=source.domain,
                        raw_data=result.get("raw_data"),
                        normalized_data={}, # TODO: Implement normalization engine
                        commit_sha=result.get("new_sha"),
                        observed_at=result.get("observed_at") or datetime.utcnow(),
                        ingested_at=datetime.utcnow()
                    )
                    db.add(record)
                    
                    # Update source metadata
                    source.last_sha = result["new_sha"]
                    source.last_ingested_at = datetime.utcnow()
                    
                    db.commit()
                else:
                    logger.info(f"No changes for {source.id}. SHA: {source.last_sha}")
                    
            except Exception as e:
                logger.error(f"Failed to ingest source {source.id}: {e}")
                db.rollback()
                
    finally:
        db.close()
