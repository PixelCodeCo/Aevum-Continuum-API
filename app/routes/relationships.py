from fastapi import APIRouter

router = APIRouter(prefix="/relationships", tags=["relationships"])

@router.get("")
def get_relationships():
    return "getAll"

@router.get("/{id}")
def get_relationship(id: str):
    return f"get {id}"

@router.post("")
def create_relationship():
    return "post"

@router.patch("/{id}")
def update_relationship(id: str):
    return f"patch {id}"

@router.delete("/{id}")
def delete_relationship(id: str):
    return f"delete {id}"