# dependencies.py
import os
from supabase import create_client, Client
from dotenv import load_dotenv
from functools import lru_cache

@lru_cache
def get_supabase():
    load_dotenv()
    return create_client(
        os.environ.get("SUPABASE_DB_URL"),
        os.environ.get("SUPABASE_DB_KEY")
    )