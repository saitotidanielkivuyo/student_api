import os
import logging
from fastapi import FastAPI, HTTPException, status, Request, Query
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from databases import Database
from contextlib import asynccontextmanager
from typing import List, Dict
import asyncpg
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging\
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
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://student_api_admin:Kivuyo93@127.0.0.1:5432/student_db"
)
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

# Database connection pool
database = Database(
    DATABASE_URL,
    min_size=MIN_DB_CONNECTIONS,
    max_size=MAX_DB_CONNECTIONS
)

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Manage database connection lifecycle."""
    try:
        logger.info("Connecting to database...")
        await database.connect()
        yield
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        raise
    finally:
        logger.info("Disconnecting from database...")
        await database.disconnect()

# Initialize FastAPI app with metadata and lifespan
app = FastAPI(
    title="Student Management API",
    description="API for managing student and subject data for university programs.",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan
)

# Enable CORS if needed
app.add_middleware(
    CORSMiddleware,
    allow_origins=[os.getenv("CORS_ALLOW_ORIGINS", "*").split(",")],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Handle uncaught exceptions globally."""
    logger.error(f"Unexpected error: {exc}")
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": "Internal server error"}
    )


@app.get(
    "/students",
    response_model=List[Student],
    summary="Retrieve students with pagination",
    description="Returns a paginated list of students with registration and program details."
)
async def get_students(
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(10, ge=1, le=100, description="Students per page")
):
    try:
        offset = (page - 1) * page_size
        query = """
        SELECT s.registration_id, s.first_name, s.last_name,
               p.name AS program_name, p.code AS program_code
        FROM students s
        JOIN programs p ON s.program_id = p.id
        ORDER BY s.registration_id
        LIMIT :limit OFFSET :offset;
        """
        values = {"limit": page_size, "offset": offset}
        students = await database.fetch_all(query=query, values=values)
        if not students:
            logger.warning("No students found on requested page.")
            raise HTTPException(status_code=404, detail="No students found")
        logger.info(f"Retrieved {len(students)} students on page {page}.")
        return [Student(**student) for student in students]
    except asyncpg.PostgresError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error occurred")
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching students: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get(
    "/subjects",
    response_model=Dict[str, List[str]],
    summary="Retrieve Software Engineering subjects",
    description="Returns a list of subjects for the Software Engineering program, grouped by academic year."
)
async def get_subjects():
    """Fetch subjects for Software Engineering program, grouped by year."""
    try:
        query = """
        SELECT name, year
        FROM subjects
        WHERE program_id = :program_id
        ORDER BY year;
        """
        subjects = await database.fetch_all(query=query, values={"program_id": 1})
        if not subjects:
            logger.warning("No subjects found for Software Engineering.")
            raise HTTPException(status_code=404, detail="No subjects found")
        result: Dict[str, List[str]] = {}
        for subj in subjects:
            year = str(subj["year"])
            result.setdefault(year, []).append(subj["name"])
        logger.info(f"Retrieved {len(subjects)} subjects for Software Engineering.")
        return result
    except asyncpg.PostgresError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error occurred")
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching subjects: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=int(os.getenv("PORT", 8080)),
        reload=True
    )
