from fastapi import FastAPI
import os

app = FastAPI()

NODE_NAME = os.getenv("NODE_NAME", "local-dev")

@app.get("/")
def read_root():
    return {
        "message": "Hello from Swarm Echo Backend!",
        "node": NODE_NAME
    }

@app.get("/api/health")
def health_check():
    return {"status": "healthy"}