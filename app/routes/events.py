from fastapi import APIRouter
from fastapi import Depends
from app.dependencies import get_supabase
from app.schemas import EventCreate, EventUpdate
from uuid import UUID

router = APIRouter(prefix="/events", tags=["events"])

@router.get("")
def get_events(supabase = Depends(get_supabase)):
    response = supabase.table("events").select("*").execute()
    return response.data

@router.get("/{id}")
def get_event(id: UUID, supabase = Depends(get_supabase)):
    response = supabase.table("events").select("*").eq("id", str(id)).execute()
    return response.data

@router.post("")
def create_event(data: EventCreate, supabase = Depends(get_supabase)):
    response = (
        supabase.table("events")
        .insert(data.model_dump(exclude={"region_ids", "category_ids", "tag_ids"}))
        .execute()
    )
    return response.data

@router.patch("/{id}")
def update_event(data: EventUpdate, id: UUID, supabase = Depends(get_supabase)):
    response = (
        supabase.table("events")
        .update(data.model_dump(exclude_unset=True, exclude={"region_ids", "category_ids", "tag_ids"}))
        .eq("id", str(id))
        .execute()
    )
    return response.data

@router.delete("/{id}")
def delete_event(id: UUID, supabase = Depends(get_supabase)):
    response = (
        supabase.table("events")
        .delete()
        .eq("id", str(id))
        .execute()
    )
    return response.data
