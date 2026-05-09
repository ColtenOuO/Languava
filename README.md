# Languava

Languava is an AI-assisted English learning app designed to help users memorize vocabulary, practice sentence writing, and receive AI-powered correction and feedback.

The project focuses on four core learning features:

1. Spaced repetition based on vocabulary familiarity
2. AI sentence correction and evaluation
3. Example sentence generation for vocabulary learning
4. Word pronunciation playback with American / British accents

---

## Core Features

### 1. Familiarity-based Spaced Repetition

Users can mark each vocabulary word with a familiarity level.

The system then schedules when the word should appear again for review.

Example rule:

| Familiarity Level | Next Review |
| --- | --- |
| Unfamiliar | 1 day later |
| Normal | 7 days later |
| Familiar | 14 days later |
| Mastered | 30 days later |

This helps users review difficult words more frequently and already-mastered words less frequently.

---

### 2. AI Sentence Correction

Users can create their own sentences using vocabulary words.

The backend sends the sentence to an AI service for correction and evaluation.

The AI feedback may include:

- Corrected sentence
- Grammar feedback
- Word usage suggestions
- Fluency evaluation
- Score or rating

This helps users avoid unnatural word usage and incorrect sentence structure.

---

### 3. Example Sentence Support

The system provides basic example sentences for vocabulary words.

These examples help users understand how a word is used in context, especially when learning the word for the first time.

---

### 4. Word Pronunciation Playback

Users can listen to the correct pronunciation of vocabulary words.

The main target accents are:

- American English
- British English

This feature helps users connect spelling, meaning, and pronunciation during vocabulary learning.

---

## Tech Stack

### Frontend

- Flutter

### Backend

- FastAPI
- PostgreSQL
- Redis
- Celery
- Alembic
- uv

### AI / External Services

- LLM service for sentence correction and feedback
- Pronunciation or TTS service for word audio playback

---

## Project Structure

```text
Languava/
├── README.md
├── scripts/
│   └── setup-dev.sh
├── docs/
│   ├── backend.md
│   └── architecture/
│       └── overall-system.drawio.svg
├── backend/
│   ├── pyproject.toml
│   ├── alembic.ini
│   ├── .env.example
│   ├── alembic/
│   ├── app/
│   ├── scripts/
│   └── tests/
└── frontend/
    ├── pubspec.yaml
    ├── lib/
    ├── android/
    ├── ios/
    ├── web/
    ├── windows/
    ├── macos/
    └── linux/
```

---

## Architecture

The current high-level system architecture is stored in:

```text
docs/architecture/overall-system.drawio.svg
```

### Overall System Architecture

![Overall System Architecture](docs/architecture/overall-system.drawio.svg)

---

## Documentation

Detailed technical documents are stored under `docs/`.

| Document | Description |
| --- | --- |
| [Backend Documentation](docs/backend.md) | Backend project layout, FastAPI structure, Celery worker layer, and database migration structure. |
| [Overall System Architecture](docs/architecture/overall-system.drawio.svg) | High-level system architecture diagram. |

Future documentation may include:

```text
docs/
├── api.md
├── database.md
├── frontend.md
└── development.md
```

---

## Development Notes

Architecture diagrams should be stored in:

```text
docs/architecture/
```

Recommended diagram format:

```text
.drawio.svg
```

This format allows diagrams to be:

- displayed directly in GitHub README
- edited with Draw.io Integration in VS Code
- version-controlled through Git
- reviewed through pull requests

---

## Getting Started

### 1. Setup local development environment

Run the setup script from the repository root:

```bash
bash scripts/setup-dev.sh
```

The script will:

- install `uv` automatically if it is missing
- sync backend dependencies with `uv sync`
- create `backend/.env` from `backend/.env.example` if missing
- run `flutter pub get` if `frontend/` exists and Flutter is installed

The script does not overwrite existing `.env` files.

---

### 2. Start the backend

Open a terminal and run:

```bash
cd backend
uv run uvicorn app.main:app --reload
```

The backend should be available at:

```text
http://127.0.0.1:8000
```

---

### 3. Start the frontend

Open another terminal and run:

```bash
cd frontend
flutter run -d chrome
```

Flutter is not installed automatically by the setup script. Please install Flutter manually if you want to run the frontend locally.

---

## Status

This project is currently in the early development stage.

Current focus:

- Define MVP scope
- Build backend foundation
- Design database schema
- Implement vocabulary review flow
- Implement AI sentence correction flow