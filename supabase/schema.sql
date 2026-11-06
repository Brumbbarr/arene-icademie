-- Arène Icademie : schéma Supabase. À coller dans SQL Editor > New query > Run.

create table if not exists public.notions (
  id text primary key,
  notion text not null,
  module text not null,
  etape int default 1,
  chapitre text,
  epreuve text,
  fiche boolean default false
);

create table if not exists public.sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  at timestamptz not null default now(),
  date date not null default current_date,
  mode text,
  titre text,
  boss text,
  victoire boolean,
  combo int default 0,
  carte text,
  source text not null default 'arene'
);

create table if not exists public.reponses (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  session_id uuid references public.sessions(id) on delete cascade,
  date date not null,
  seance text,
  question text,
  notion text not null,
  correct boolean not null,
  given text,
  attendu text,
  source text not null default 'arene',
  created_at timestamptz not null default now()
);
create index if not exists reponses_user_idx on public.reponses(user_id, date);

create table if not exists public.profil (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  titre text,
  updated_at timestamptz default now()
);

alter table public.notions enable row level security;
alter table public.sessions enable row level security;
alter table public.reponses enable row level security;
alter table public.profil enable row level security;

drop policy if exists "notions lisibles" on public.notions;
create policy "notions lisibles" on public.notions for select using (true);

drop policy if exists "mes sessions" on public.sessions;
create policy "mes sessions" on public.sessions for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "mes reponses" on public.reponses;
create policy "mes reponses" on public.reponses for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "mon profil" on public.profil;
create policy "mon profil" on public.profil for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
