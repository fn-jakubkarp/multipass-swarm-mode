import psycopg
from fastapi import FastAPI, HTTPException
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()


_db_url = os.getenv("DATABASE_URL")
if not _db_url:
    raise ValueError("DATABASE_URL environment variable is not set.")
DATABASE_URL: str = _db_url


@app.get("/api/clicks")
async def get_clicks():
    async with await psycopg.AsyncConnection.connect(DATABASE_URL) as aconn:
        async with aconn.cursor() as acur:
            await acur.execute("SELECT clicks FROM counter WHERE id = 1")
            result = await acur.fetchone()

            if result is None:
                return {"clicks": -1}

            return {"clicks": result[0]}


@app.post("/api/clicks/increment")
async def increment_clicks():
    async with await psycopg.AsyncConnection.connect(DATABASE_URL) as aconn:
        async with aconn.cursor() as acur:
            await acur.execute("""
                UPDATE counter 
                SET clicks = clicks + 1 
                WHERE id = 1 
                RETURNING clicks
            """)
            result = await acur.fetchone()

            if result is None:
                raise HTTPException(status_code=404, detail="Counter row not found")

            await aconn.commit()

            return {"clicks": result[0]}