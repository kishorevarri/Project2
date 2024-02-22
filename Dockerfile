# Use a base image with Python for both Streamlit and FastAPI
FROM python:3.9-slim AS builder

# Set working directory for the app
WORKDIR /app

# Install dependencies for both front end and back end
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Streamlit
RUN pip install --no-cache-dir streamlit

# Install FastAPI
RUN pip install --no-cache-dir fastapi uvicorn

# Copy front end files
COPY frontend /app/frontend

# Install dependencies for front end
RUN pip install --no-cache-dir -r frontend/requirements.txt

# Copy back end files
COPY backend /app/backend

# Expose port for FastAPI
EXPOSE 8000

# Set entry point to start both Streamlit and FastAPI
CMD ["bash", "-c", "streamlit run --server.port 8501 frontend/app.py & uvicorn backend.main:app --host 0.0.0.0 --port 8000"]
