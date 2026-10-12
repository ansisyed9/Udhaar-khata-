-- Udhaar Khata starter schema for Supabase.
-- Run in Supabase SQL Editor. RLS keeps each user's rows private.
create extension if not exists pgcrypto;

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 120),
  phone text not null default '',
  note text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  customer_id uuid not null references public.customers(id) on delete cascade,
  type text not null check (type in ('credit','payment')),
  amount numeric(14,2) not null check (amount > 0),
  date date not null default current_date,
  note text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.business_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('sale','purchase','expense')),
  amount numeric(14,2) not null check (amount > 0),
  date date not null default current_date,
  note text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists customers_user_id_idx on public.customers(user_id);
create index if not exists transactions_user_date_idx on public.transactions(user_id,date desc);
create index if not exists transactions_customer_idx on public.transactions(customer_id,date desc);
create index if not exists business_entries_user_date_idx on public.business_entries(user_id,date desc);

alter table public.customers enable row level security;
alter table public.transactions enable row level security;
alter table public.business_entries enable row level security;

drop policy if exists "users manage own customers" on public.customers;
create policy "users manage own customers" on public.customers for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "users manage own transactions" on public.transactions;
create policy "users manage own transactions" on public.transactions for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid() and exists (select 1 from public.customers c where c.id = customer_id and c.user_id = auth.uid()));
drop policy if exists "users manage own business entries" on public.business_entries;
create policy "users manage own business entries" on public.business_entries for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Never expose the service_role key in frontend code. Use only Supabase's publishable/anon key.
