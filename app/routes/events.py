from fastapi import APIRouter

router = APIRouter(prefix="/events", tags=["events"])

@router.get("")
def get_events():
    return "getAll"

@router.get("/{id}")
def get_event(id: str):
    return f"get {id}"

@router.post("")
def create_event():
    return "post"

@router.patch("/{id}")
def update_event(id: str):
    return f"patch {id}"

@router.delete("/{id}")
def delete_event(id: str):
    return f"delete {id}"