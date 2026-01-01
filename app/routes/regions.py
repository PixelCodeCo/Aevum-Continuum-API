from fastapi import APIRouter

router = APIRouter(prefix="/regions", tags=["regions"])

@router.get("")
def get_regions():
    return "getAll"

@router.get("/{id}")
def get_region(id: str):
    return f"get {id}"

@router.post("")
def create_region():
    return "post"

@router.patch("/{id}")
def update_region(id: str):
    return f"patch {id}"

@router.delete("/{id}")
def delete_region(id: str):
    return f"delete {id}"