-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- PROFILES TABLE
create table public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  email text not null,
  username text,
  current_xp int default 0,
  current_level int default 1,
  total_focus_time int default 0,
  created_at timestamp with time zone default now()
);

-- WEEKLY LEAGUE PARTICIPANTS TABLE
create table public.weekly_league_participants (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) not null,
  week_start_date date not null,
  starting_level int not null, -- Snapshot of level at start of week
  weekly_xp int default 0,
  created_at timestamp with time zone default now()
);

-- PENDING REWARDS TABLE
create table public.pending_rewards (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) not null,
  reward_type text not null,
  week_date date not null,
  is_claimed boolean default false,
  created_at timestamp with time zone default now()
);

-- USER BADGES TABLE
create table public.user_badges (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) not null,
  badge_slug text not null,
  earned_at timestamp with time zone default now()
);

-- ENABLE ROW LEVEL SECURITY
alter table public.profiles enable row level security;
alter table public.weekly_league_participants enable row level security;
alter table public.pending_rewards enable row level security;
alter table public.user_badges enable row level security;

-- RLS POLICIES

-- Profiles: Everyone can read, User can update own
create policy "Public profiles are viewable by everyone."
  on public.profiles for select
  using ( true );

create policy "Users can insert their own profile."
  on public.profiles for insert
  with check ( auth.uid() = id );

create policy "Users can update their own profile."
  on public.profiles for update
  using ( auth.uid() = id );

-- Weekly League: Everyone can read, User can update own
create policy "Weekly league is viewable by everyone."
  on public.weekly_league_participants for select
  using ( true );

create policy "Users can insert their own league entry."
  on public.weekly_league_participants for insert
  with check ( auth.uid() = user_id );

create policy "Users can update their own league entry."
  on public.weekly_league_participants for update
  using ( auth.uid() = user_id );

-- Pending Rewards: User sees only own, updates own
create policy "Users can see their own pending rewards."
  on public.pending_rewards for select
  using ( auth.uid() = user_id );

create policy "Users can update their own pending rewards."
  on public.pending_rewards for update
  using ( auth.uid() = user_id );

-- User Badges: Everyone can read (for profile 'museum'), User can insert own (via logic, usually backend does this but allowed here for now)
create policy "Badges are viewable by everyone."
  on public.user_badges for select
  using ( true );

create policy "Users can insert their own badges."
  on public.user_badges for insert
  with check ( auth.uid() = user_id );

-- TRIGGER FOR NEW USER CREATION
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

