FROM python:3.11-slim

# ---- System dependencies (audio + ML) ----
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsndfile1 \
    libgl1 \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ---- Python deps ----
COPY pyproject.toml uv.lock ./

RUN pip install --no-cache-dir uv
RUN uv sync --locked --no-dev

# ---- App files ----
COPY bot.py bot.py
COPY resource_document.txt resource_document.txt

# ---- IMPORTANT: run with Daily transport ----
CMD ["uv", "run", "python", "bot.py", "--transport", "daily"]
