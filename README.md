# 14-Day Stability Tracker

Flutter Web app to track daily stability metrics for the last 14 days and persist records in Supabase.

## Prerequisites

- Flutter 3.x
- A Supabase project

## 1) Create Supabase project

1. Go to [https://supabase.com](https://supabase.com)
2. Create a new project.
3. Open **Project Settings > API**.
4. Copy:
   - Project URL
   - anon public key

## 2) Create database table

Run this SQL in Supabase SQL editor:

```sql
create extension if not exists pgcrypto;

create table if not exists public.stability_logs (
  id uuid primary key default gen_random_uuid(),
  date date not null unique,
  pushups_done boolean not null,
  deep_work_done boolean not null,
  steps_count integer not null,
  cigarettes_count integer not null,
  score integer not null,
  created_at timestamp with time zone default now()
);

alter table public.stability_logs
  add constraint stability_logs_date_unique unique (date);
```

> If the unique constraint already exists, skip the `alter table` statement.

## 3) Install dependencies

```bash
flutter pub get
```

## 4) Run locally (web)

```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=YOUR_SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

## 5) Build web release

```bash
flutter build web --release \
  --dart-define=SUPABASE_URL=YOUR_SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

## 6) Run tests

```bash
flutter test
```

## 7) GitHub Pages deployment

Workflow file: `.github/workflows/deploy_web.yml`

Configure repository secrets:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Push to `main` branch and the workflow will:

1. Build Flutter web release
2. Deploy `build/web` to `gh-pages`

