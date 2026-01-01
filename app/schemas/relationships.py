from datetime import datetime
from uuid import UUID
from pydantic import BaseModel, model_validator

from .enums import RelationshipType


class RelationshipCreate(BaseModel):
    """What clients send to create a relationship between events."""
    source_event_id: UUID  # the "from" event
    target_event_id: UUID  # the "to" event
    relationship_type: RelationshipType

    @model_validator(mode="after")
    def check_no_self_reference(self):
        if self.source_event_id == self.target_event_id:
            raise ValueError("An event cannot have a relationship with itself")
        return self


class RelationshipResponse(BaseModel):
    """What clients receive for a relationship."""
    id: UUID
    source_event_id: UUID
    target_event_id: UUID
    relationship_type: RelationshipType
    created_at: datetime