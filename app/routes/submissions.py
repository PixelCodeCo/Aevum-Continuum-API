from fastapi import APIRouter

router = APIRouter(prefix="/submissions", tags=["submissions"])

@router.get("")
def get_submissions():
    return "getAll"

@router.get("/{id}")
def get_submission(id: str):
    return f"get {id}"

@router.post("")
def create_submission():
    return "post"

@router.patch("/{id}")
def update_submission(id: str):
    return f"patch {id}"

@router.delete("/{id}")
def delete_submission(id: str):
    return f"delete {id}"