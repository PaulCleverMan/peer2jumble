# =========================
# 0️⃣ Base image
# =========================
FROM ghcr.io/astral-sh/uv:python3.13-trixie-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PROJECT_ENVIRONMENT=/app/.venv

WORKDIR /app

# =========================
# 1️⃣ Builder stage
# =========================
FROM base AS builder

COPY --from=ghcr.io/astral-sh/uv:0.10.11 /uv /uvx /bin/

COPY pyproject.toml uv.lock ./

ARG BUILD_WORKSPACE=dev

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    if [ "$BUILD_WORKSPACE" = "dev" ]; then \
        uv sync --frozen --no-install-project --group dev; \
    else \
        uv sync --frozen --no-dev; \
    fi

COPY . .

RUN --mount=type=cache,target=/root/.cache/uv \
    if [ "$BUILD_WORKSPACE" = "dev" ]; then \
        uv sync --frozen --group dev; \
    else \
        uv sync --frozen --no-dev; \
    fi

# =========================
# 2️⃣ Runtime stage
# =========================
FROM base AS runtime

RUN apt-get update && apt-get install -y libpq5 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app /app

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8000

CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
