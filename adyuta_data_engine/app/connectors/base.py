from abc import ABC, abstractmethod
from typing import Dict, Any, Optional

class BaseConnector(ABC):
    """
    Abstract base class for all Adyuta Data Engine connectors.
    """
    
    def __init__(self, source_id: str, config: Dict[str, Any]):
        self.source_id = source_id
        self.config = config

    @abstractmethod
    def fetch_data(self, last_sha: Optional[str] = None) -> Dict[str, Any]:
        """
        Fetches data from the upstream source.
        Returns a dict containing:
        - 'changed': bool (False if SHA matches last_sha)
        - 'new_sha': str
        - 'raw_data': dict or list
        - 'observed_at': datetime
        """
        pass
