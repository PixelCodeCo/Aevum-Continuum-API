from datetime import datetime
from uuid import UUID
from pydantic import BaseModel, Field


class CategoryCreate(BaseModel):
    """What clients send to create a category."""
    name: str = Field(..., min_length=1, max_length=100)
    color: str | None = Field(None, pattern=r"^#[0-9A-Fa-f]{6}$")  # hex color


class CategoryUpdate(BaseModel):
    """What clients send to update a category."""
    name: str | None = Field(None, min_length=1, max_length=100)
    color: str | None = Field(None, pattern=r"^#[0-9A-Fa-f]{6}$")


class CategoryResponse(BaseModel):
    """What clients receive for a category."""
    id: UUID
    name: str
    color: str | None
    created_at: datetime