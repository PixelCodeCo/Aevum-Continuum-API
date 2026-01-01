from fastapi import FastAPI
from app.routes.auth import router as auth_router
from app.routes.events import router as events_router
from app.routes.categories import router as category_router
from app.routes.enums import router as enums_router
from app.routes.regions import router as regions_router
from app.routes.relationships import router as relationships_router
from app.routes.sources import router as sources_router
from app.routes.submissions import router as submissions_router
from app.routes.tags import router as tags_router

app = FastAPI()

@app.get("health")
def health_check():
    return "ok"

app.include_router(auth_router)
app.include_router(events_router)
app.include_router(category_router)
app.include_router(enums_router)
app.include_router(regions_router)
app.include_router(relationships_router)
app.include_router(sources_router)
app.include_router(submissions_router)
app.include_router(tags_router)