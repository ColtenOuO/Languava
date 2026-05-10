#!/usr/bin/env bash

set -euo pipefail

echo "========================================"
echo " Languava Local Development Setup"
echo "========================================"
echo ""

# Ensure script is executed from repo root.
if [ ! -f "README.md" ] || [ ! -d "backend" ]; then
  echo "Error: Please run this script from the repository root."
  echo "Example:"
  echo "  bash scripts/setup-dev.sh"
  exit 1
fi

install_uv() {
  echo "uv is not installed."
  echo "Attempting to install uv..."
  echo ""

  if command -v curl >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- https://astral.sh/uv/install.sh | sh
  else
    echo "Error: Neither curl nor wget is installed."
    echo "Please install uv manually:"
    echo "  https://docs.astral.sh/uv/getting-started/installation/"
    exit 1
  fi

  # uv installer usually adds uv to ~/.local/bin.
  export PATH="$HOME/.local/bin:$PATH"

  if ! command -v uv >/dev/null 2>&1; then
    echo "Error: uv installation completed, but uv is still not available in PATH."
    echo "Try restarting your shell or add this to your shell config:"
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    exit 1
  fi

  echo "uv installed successfully: $(uv --version)"
}

echo "Checking required tools..."
echo ""

if ! command -v uv >/dev/null 2>&1; then
  install_uv
else
  echo "uv found: $(uv --version)"
fi

if command -v flutter >/dev/null 2>&1; then
  echo "flutter found: $(flutter --version | head -n 1)"
else
  echo "Warning: flutter is not installed or not available in PATH."
  echo "Frontend setup will be skipped."
fi

echo ""
echo "Setting up backend..."
echo "----------------------------------------"

cd backend

echo "Syncing backend dependencies with uv..."
uv sync

if [ -f ".env.example" ] && [ ! -f ".env" ]; then
  echo "Creating backend/.env from backend/.env.example..."
  cp .env.example .env
else
  echo "Skipping .env creation."
fi

cd ..

echo ""
echo "Setting up frontend..."
echo "----------------------------------------"

if [ -d "frontend" ]; then
  if command -v flutter >/dev/null 2>&1; then
    cd frontend
    echo "Installing frontend dependencies..."
    flutter pub get
    cd ..
  else
    echo "Skipping frontend setup because flutter is not installed."
  fi
else
  echo "Skipping frontend setup because frontend/ does not exist yet."
fi

echo ""
echo "========================================"
echo " Setup completed"
echo "========================================"
echo ""
