-- BLACKOUT TRAINING starter schema for Supabase (Postgres)
-- Run in Supabase SQL Editor. Enable email auth in Authentication settings.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default 'Athlete',
  sport text not null default 'Both' check (sport in ('Both','Basketball','Football')),
  level text not null default 'Beginner' check (level in ('Beginner','Intermediate','Advanced','Elite')),
  goal text default '',
  xp integer not null default 0,
  streak integer not null default 0,
  membership text not null default 'free' check (membership in ('free','premium')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.workout_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  sport text not null default 'Both',
  duration_minutes integer not null default 0 check (duration_minutes between 0 and 600),
  notes text default '',
  date timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.measurements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  metric text not null,
  value numeric not null,
  unit text not null,
  recorded_at timestamptz not null default now()
);

create table if not exists public.challenge_entries (
  id uuid primary key default gen_random_uuid(),
  challenge_key text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  progress integer not null default 0,
  completed boolean not null default false,
  updated_at timestamptz not null default now(),
  unique(challenge_key,user_id)
);

create table if not exists public.coach_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('user','assistant')),
  content text not null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.workout_logs enable row level security;
alter table public.measurements enable row level security;
alter table public.challenge_entries enable row level security;
alter table public.coach_messages enable row level security;

create policy "profiles read own" on public.profiles for select to authenticated using (auth.uid() = id);
create policy "profiles insert own" on public.profiles for insert to authenticated with check (auth.uid() = id);
create policy "profiles update own" on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create policy "workouts own all" on public.workout_logs for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "measurements own all" on public.measurements for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "challenge entries own all" on public.challenge_entries for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "coach messages own all" on public.coach_messages for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Public leaderboard: expose only aggregate/rank data through a carefully designed view or RPC.
-- Do not make profiles publicly readable just to power a leaderboard.
