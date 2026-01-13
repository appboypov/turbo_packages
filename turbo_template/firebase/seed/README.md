# Firebase Emulator Seed Data

This directory contains seed data for Firebase emulators. Data is automatically
imported when starting emulators and exported on exit.

## Structure

When the emulators export data, they create subdirectories here:
- `auth_export/` - Authentication user data
- `firestore_export/` - Firestore documents and collections

## Usage

1. Start emulators with seed data:
   ```bash
   cd firebase && firebase emulators:start --import=./seed --export-on-exit=./seed
   ```

2. Or use the provided script:
   ```bash
   ./scripts/run_emulators.sh
   ```

## Creating Seed Data

1. Start emulators
2. Use the app or Emulator UI to create test data
3. Stop emulators (Ctrl+C) - data auto-exports to this directory
4. Commit the seed data to share with your team

## Notes

- Seed data is gitignored by default
- To share seed data, remove it from .gitignore
- Each team member can have their own local seed data
