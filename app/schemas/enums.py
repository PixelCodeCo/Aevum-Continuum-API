from enum import Enum


class DatePrecision(str, Enum):
    day = "day"
    month = "month"
    year = "year"
    decade = "decade"
    century = "century"


class EventScope(str, Enum):
    global_ = "global"  # 'global' is reserved keyword, use trailing underscore
    continental = "continental"
    regional = "regional"
    local = "local"


class EventStatus(str, Enum):
    draft = "draft"
    submitted = "submitted"
    pending_review = "pending_review"
    approved = "approved"
    rejected = "rejected"


class RelationshipType(str, Enum):
    caused = "caused"
    influenced = "influenced"
    parallel = "parallel"
    preceded = "preceded"


class TagType(str, Enum):
    empire = "empire"
    movement = "movement"
    person = "person"
    theme = "theme"
    other = "other"