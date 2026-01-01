from datetime import datetime
from uuid import UUID
from pydantic import BaseModel, Field


class RegionCreate(BaseModel):
    """What clients send to create a region."""
    name: str = Field(..., min_length=1, max_length=200)
    parent_id: UUID | None = None  # null = top-level region


class RegionUpdate(BaseModel):
    """What clients send to update a region."""
    name: str | None = Field(None, min_length=1, max_length=200)
    parent_id: UUID | None = None


class RegionResponse(BaseModel):
    """What clients receive for a region."""
    id: UUID
    name: str
    parent_id: UUID | None
    created_at: datetime