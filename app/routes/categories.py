from fastapi import APIRouter

router = APIRouter(prefix="/categories", tags=["categories"])

@router.get("")
def get_categories():
    return "getAll"

@router.get("/{id}")
def get_category(id: str):
    return f"get {id}"

@router.post("")
def create_category():
    return "post"

@router.patch("/{id}")
def update_category(id: str):
    return f"patch {id}"

@router.delete("/{id}")
def delete_category(id: str):
    return f"delete {id}"