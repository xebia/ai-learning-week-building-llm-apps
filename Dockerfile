FROM python:3.13-slim

## Install uv
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

# Configure uv
ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PYTHON=python3.13 \
    UV_PROJECT_ENVIRONMENT=/usr/local/

## Install package
WORKDIR /app
ADD pyproject.toml uv.lock /app/
RUN uv sync --no-dev --locked --no-install-package example_project
ADD src /app
RUN uv sync --no-dev --locked --no-editable