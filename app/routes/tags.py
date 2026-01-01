from fastapi import APIRouter

router = APIRouter(prefix="/tags", tags=["tags"])

@router.get("")
def get_tags():
    return "getAll"

@router.get("/{id}")
def get_tag(id: str):
    return f"get {id}"

@router.post("")
def create_tag():
    return "post"

@router.patch("/{id}")
def update_tag(id: str):
    return f"patch {id}"

@router.delete("/{id}")
def delete_tag(id: str):
    return f"delete {id}"