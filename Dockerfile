# =========================
# 1️⃣ Builder stage
# =========================
FROM python:3.13-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 - --version 2.3.2
ENV PATH="/root/.local/bin:$PATH"

COPY pyproject.toml poetry.lock ./

ARG BUILD_WORKSPACE=dev

RUN poetry config virtualenvs.create false

RUN if [ "$BUILD_WORKSPACE" = "dev" ]; then \
        poetry install --no-root --with dev; \
    else \
        poetry install --no-root --only main; \
    fi
# =========================
# 2️⃣ Runtime stage
# =========================
FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/python3.13 /usr/local/lib/python3.13
COPY --from=builder /usr/local/bin /usr/local/bin

RUN addgroup --system --gid 1000 jumble && \
    adduser --system --uid 1000 --ingroup jumble jumble

COPY --chown=jumble:jumble . .

USER jumble

EXPOSE 8000

CMD ["gunicorn", "config.wsgi:application", \
     "--bind", "0.0.0.0:8000", \
     "--workers", "3"]
