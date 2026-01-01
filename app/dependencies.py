import os
from supabase import create_client, Client
from dotenv import load_dotenv

def supabaseClient ():
    load_dotenv()
    url: str = os.environ.get("SUPABASE_DB_URL")
    key: str = os.environ.get("SUPABASE_DB_KEY")
    supabase: Client = create_client(url, key)
    return supabase
