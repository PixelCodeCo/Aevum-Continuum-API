from fastapi import APIRouter

router = APIRouter(prefix="/enums", tags=["enums"])

@router.get("")
def get_enums():
    return "getAll"

@router.get("/{id}")
def get_enum(id: str):
    return f"get {id}"

@router.post("")
def create_enum():
    return "post"

@router.patch("/{id}")
def update_enum(id: str):
    return f"patch {id}"

@router.delete("/{id}")
def delete_enum(id: str):
    return f"delete {id}"