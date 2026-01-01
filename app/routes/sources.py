from fastapi import APIRouter

router = APIRouter(prefix="/sources", tags=["sources"])

@router.get("")
def get_sources():
    return "getAll"

@router.get("/{id}")
def get_source(id: str):
    return f"get {id}"

@router.post("")
def create_source():
    return "post"

@router.patch("/{id}")
def update_source(id: str):
    return f"patch {id}"

@router.delete("/{id}")
def delete_source(id: str):
    return f"delete {id}"