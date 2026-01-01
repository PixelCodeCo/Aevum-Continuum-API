from datetime import datetime
from uuid import UUID
from pydantic import BaseModel, Field

from .enums import DatePrecision, EventScope, EventStatus


class EventCreate(BaseModel):
    """What clients send to create an event."""
    title: str = Field(..., min_length=1, max_length=500)
    summary: str | None = None
    start_year: int
    start_month: int | None = Field(None, ge=1, le=12)
    start_day: int | None = Field(None, ge=1, le=31)
    end_year: int | None = None
    end_month: int | None = Field(None, ge=1, le=12)
    end_day: int | None = Field(None, ge=1, le=31)
    date_precision: DatePrecision
    scope: EventScope
    importance: int | None = Field(None, ge=1, le=10)
    # Junction table IDs - passed during creation
    region_ids: list[UUID] | None = None
    category_ids: list[UUID] | None = None
    tag_ids: list[UUID] | None = None


class EventUpdate(BaseModel):
    """What clients send to update an event. All fields optional."""
    title: str | None = Field(None, min_length=1, max_length=500)
    summary: str | None = None
    start_year: int | None = None
    start_month: int | None = Field(None, ge=1, le=12)
    start_day: int | None = Field(None, ge=1, le=31)
    end_year: int | None = None
    end_month: int | None = Field(None, ge=1, le=12)
    end_day: int | None = Field(None, ge=1, le=31)
    date_precision: DatePrecision | None = None
    scope: EventScope | None = None
    importance: int | None = Field(None, ge=1, le=10)
    status: EventStatus | None = None
    region_ids: list[UUID] | None = None
    category_ids: list[UUID] | None = None
    tag_ids: list[UUID] | None = None


class EventResponse(BaseModel):
    """What clients receive for a single event."""
    id: UUID
    title: str
    summary: str | None
    start_year: int
    start_month: int | None
    start_day: int | None
    end_year: int | None
    end_month: int | None
    end_day: int | None
    date_precision: DatePrecision
    scope: EventScope
    importance: int | None
    status: EventStatus
    created_at: datetime
    updated_at: datetime
    # Nested data from junction tables
    regions: list["RegionResponse"] | None = None
    categories: list["CategoryResponse"] | None = None
    tags: list["TagResponse"] | None = None


class EventListResponse(BaseModel):
    """Paginated list of events."""
    events: list[EventResponse]
    total: int
    page: int
    per_page: int


# Avoid circular imports
from .regions import RegionResponse
from .categories import CategoryResponse
from .tags import TagResponse

EventResponse.model_rebuild()