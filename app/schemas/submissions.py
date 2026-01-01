from datetime import datetime
from uuid import UUID
from pydantic import BaseModel


class SubmissionCreate(BaseModel):
    """What clients send to create a submission (usually auto-created with event)."""
    event_id: UUID


class SubmissionUpdate(BaseModel):
    """What reviewers send to update a submission."""
    reviewed_by: UUID | None = None
    reviewed_at: datetime | None = None
    review_notes: str | None = None


class SubmissionResponse(BaseModel):
    """What clients receive for a submission."""
    id: UUID
    event_id: UUID
    submitted_by: UUID
    reviewed_by: UUID | None
    submitted_at: datetime
    reviewed_at: datetime | None
    review_notes: str | None
    created_at: datetime