import requests
import base64
import json
from datetime import datetime
from typing import Dict, Any, Optional
from .base import BaseConnector

class GitHubConnector(BaseConnector):
    """
    Connector for pulling public data from GitHub repositories using the Contents API.
    Utilizes `sha` to prevent redundant downloads.
    """
    
    BASE_URL = "https://api.github.com/repos"

    def fetch_data(self, last_sha: Optional[str] = None) -> Dict[str, Any]:
        repository = self.config.get("repository")
        path = self.config.get("path")
        
        if not repository or not path:
            raise ValueError("GitHub connector requires 'repository' and 'path' in config.")
        
        url = f"{self.BASE_URL}/{repository}/contents/{path}"
        
        # We only want metadata first to check the SHA
        headers = {"Accept": "application/vnd.github.v3+json"}
        
        # TODO: Add GitHub PAT token here for authenticated requests (5000/hr limit)
        # token = os.getenv("GITHUB_TOKEN")
        # if token:
        #    headers["Authorization"] = f"token {token}"
        
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        
        metadata = response.json()
        
        # If it's a directory, metadata is a list. For now, assume it's a file.
        if isinstance(metadata, list):
            raise NotImplementedError("GitHub Connector currently supports single files, not directories.")
            
        current_sha = metadata.get("sha")
        
        if last_sha and current_sha == last_sha:
            return {
                "changed": False,
                "new_sha": current_sha,
                "raw_data": None,
                "observed_at": None
            }
            
        # If SHA changed or no last_sha, download the content
        # The Contents API returns base64 encoded content for files < 1MB
        raw_content = metadata.get("content", "")
        decoded_bytes = base64.b64decode(raw_content)
        
        # Assuming JSON for this MVP, but parser logic would go here
        try:
            parsed_data = json.loads(decoded_bytes.decode('utf-8'))
        except Exception:
            # Fallback to raw text if not JSON
            parsed_data = {"text": decoded_bytes.decode('utf-8')}
        
        return {
            "changed": True,
            "new_sha": current_sha,
            "raw_data": parsed_data,
            "observed_at": datetime.utcnow() # Note: GitHub API doesn't give commit date in Contents API directly, would need Commits API for exact observed_at
        }
