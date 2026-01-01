from datetime import datetime
from uuid import UUID
from pydantic import BaseModel, Field

from .enums import TagType


class TagCreate(BaseModel):
    """What clients send to create a tag."""
    name: str = Field(..., min_length=1, max_length=200)
    tag_type: TagType = TagType.other


class TagUpdate(BaseModel):
    """What clients send to update a tag."""
    name: str | None = Field(None, min_length=1, max_length=200)
    tag_type: TagType | None = None


class TagResponse(BaseModel):
    """What clients receive for a tag."""
    id: UUID
    name: str
    tag_type: TagType
    created_at: datetime