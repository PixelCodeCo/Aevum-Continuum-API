from fastapi import APIRouter

router = APIRouter(prefix="/auth", tags=["auth"])

@router.get("")
def get_auths():
    return "getAll"

@router.get("/{id}")
def get_auth(id: str):
    return f"get {id}"

@router.post("")
def create_auth():
    return "post"

@router.patch("/{id}")
def update_auth(id: str):
    return f"patch {id}"

@router.delete("/{id}")
def delete_auth(id: str):
    return f"delete {id}"