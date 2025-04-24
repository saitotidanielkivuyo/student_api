import os
import logging
from fastapi import FastAPI, HTTPException, status
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import sqlite3
from contextlib import asynccontextmanager
from typing import List, Dict

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("app.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Environment variables
DATABASE_URL = os.getenv("example.db")
MAX_DB_CONNECTIONS = int(os.getenv("MAX_DB_CONNECTIONS", 10))
MIN_DB_CONNECTIONS = int(os.getenv("MIN_DB_CONNECTIONS", 2))

# Pydantic models for response validation
class Student(BaseModel):
    registration_id: str
    first_name: str
    last_name: str
    program_name: str
    program_code: str

class Subject(BaseModel):
    code: str
    name: str
    year: int

logger.info("Initializing FastAPI app with metadata")
app = FastAPI(
    title="Student Management API",
    description="API for managing student and subject data for university programs.",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Database connection management
async def get_db_connection():
    """Retrieve an async database connection."""
    conn = sqlite3.connect(DATABASE_URL)
    logger.info("Connected to database")
    return conn

@asynccontextmanager
async def lifespan(conn: sqlite3.Connection):
    """Manage database connection lifecycle."""
    try:
        await conn.commit()
        yield conn  # Return the connection for use in the decorated function
    except Exception as e:
        logger.error(f"Database error: {str(e)}")
        await conn.rollback()
        raise
    finally:
        logger.info("Closed database connection.")
        await conn.close()

app.lifespan = lifespan

@app.exception_handler(Exception)
async def global_exception_handler(request, exc: Exception):
    """Handle uncaught exceptions globally."""
    logger.error(f"Unexpected error: {str(exc)}")
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"status": "500", "detail": "Internal server error"}
    )

@app.get(
    "/students",
    response_model=List[Student],
    summary="Retrieve all students",
    description="Returns a list of students with their registration details and program information."
)
async def get_students() -> List[Student]:
    """Fetch all students with their program details."""
    try:
        # Create new connection within async context manager
        with await get_db_connection() as conn:
            query = """
                SELECT s.registration_id, s.first_name, s.last_name,
                       p.name as program_name, p.code as program_code
                FROM students s
                JOIN programs p ON s.program_id = p.id
                """
            students = await conn.execute(query).fetchall()
            
            if not students:
                logger.warning("No students found.")
                raise HTTPException(status_code=404, detail="No students found")
            
            logger.info(f"Retrieved {len(students)} students.")
            return [Student(**row) for row in students]
    except Exception as e:
        logger.error(f"Error fetching students: {str(e)}")
        raise

# Start the FastAPI server
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=9000)