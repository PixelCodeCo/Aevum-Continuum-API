from datetime import datetime
from uuid import UUID
from pydantic import BaseModel, HttpUrl


class SourceCreate(BaseModel):
    """What clients send to create a source."""
    event_id: UUID
    url: HttpUrl | None = None
    citation: str | None = None


class SourceUpdate(BaseModel):
    """What clients send to update a source."""
    url: HttpUrl | None = None
    citation: str | None = None


class SourceResponse(BaseModel):
    """What clients receive for a source."""
    id: UUID
    event_id: UUID
    url: str | None
    citation: str | None
    created_at: datetime