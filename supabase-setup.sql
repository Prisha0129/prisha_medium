-- Run this entire file once in Supabase: SQL Editor > New query > Run.
-- It creates a single protected cloud record for your site's journal data.

create table if not exists public.journal_app_state (
  id text primary key default 'main' check (id = 'main'),
  state jsonb not null default '{"published":[],"overrides":{},"archive":[],"hidden":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

insert into public.journal_app_state (id) values ('main') on conflict (id) do nothing;

create table if not exists public.journal_admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

alter table public.journal_app_state enable row level security;
alter table public.journal_admins enable row level security;

create or replace function public.is_journal_admin()
returns boolean language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.journal_admins where user_id = auth.uid()) $$;

drop policy if exists "Users can see their own admin status" on public.journal_admins;
create policy "Users can see their own admin status" on public.journal_admins for select using (auth.uid() = user_id);

drop policy if exists "Anyone can read published journal state" on public.journal_app_state;
create policy "Anyone can read published journal state" on public.journal_app_state for select using (true);
drop policy if exists "Admins can change journal state" on public.journal_app_state;
create policy "Admins can change journal state" on public.journal_app_state for update using (public.is_journal_admin()) with check (public.is_journal_admin());

insert into storage.buckets (id, name, public) values ('journal-images', 'journal-images', true)
on conflict (id) do update set public = true;

drop policy if exists "Anyone can view journal photos" on storage.objects;
create policy "Anyone can view journal photos" on storage.objects for select using (bucket_id = 'journal-images');
drop policy if exists "Admins can upload journal photos" on storage.objects;
create policy "Admins can upload journal photos" on storage.objects for insert with check (bucket_id = 'journal-images' and public.is_journal_admin());

-- AFTER you create and confirm your account on the website, run this one line.
-- Replace the email exactly, including the quotes:
-- insert into public.journal_admins (user_id)
-- select id from auth.users where email = 'YOUR_EMAIL@example.com'
-- on conflict do nothing;
